#include "steering.h"
#include <Arduino.h>
#include <AccelStepper.h>
#include <TMCStepper.h>
#include "wheel_telemetry.h"

// ===========================
// ----- Driver Pins (MEGA)
// ===========================
const int enPin = 5;
const int stepPin = 6;
const int dirPin = 7;

// ===========================
// ----- TMC2209 (UART on Serial2)
// ===========================
 #define R_SENSE 0.11f
TMC2209Stepper driver(&Serial2, R_SENSE, 0b00);

// ===========================
// ----- Steering Config
// ===========================
static const uint16_t MICROSTEPS = 4;
const float stepsPerRevolution = 200.0f * MICROSTEPS;
const float steeringRange = 90.0f;
const float gearRatio = 5.0f;

// Homing params
static const long HOMING_SPEED_STEPS = 400;       // steps/s, sign controlled per direction
static unsigned long g_homingNoPulseMs = 400; // inactivity threshold (user-adjustable)

// ===========================
// ----- Helpers
// ===========================
static inline long wheelDegToSteps(float deg) {
    const float s = (deg * gearRatio * stepsPerRevolution) / 360.0f;
    return (long)(s + (s >= 0 ? 0.5f : -0.5f)); // round to nearest
}

static inline float stepsToWheelDeg(long steps) {
    return (steps * 360.0f) / (gearRatio * stepsPerRevolution);
}

// Minimum acceptable span between stops (e.g., 5 degrees worth of steps)
static inline long minSpanSteps() { return labs(wheelDegToSteps(5.0f)); }

// Steps per one encoder pulse on steering turn encoder
static inline float stepsPerEncPulse() {
    const float stepsPerWheelRev = stepsPerRevolution * gearRatio;
    const int ppr = wheelGetAnglePPR();
    return (ppr > 0) ? (stepsPerWheelRev / (float)ppr) : 100.0f; // fallback
}

// Minimum time between valid encoder pulses at the given stepper speed (ms)
static inline unsigned long minPulseIntervalMsForSpeed(float stepsPerSec) {
    float spp = stepsPerEncPulse();
    if (stepsPerSec <= 1.0f) return 100UL; // conservative large interval
    float expectedPeriodMs = (spp / fabs(stepsPerSec)) * 1000.0f;
    // Allow generous tolerance: accept only if >= 50% of expected period
    float minMs = expectedPeriodMs * 0.5f;
    if (minMs < 2.0f) minMs = 2.0f; // never below 2ms
    return (unsigned long)minMs;
}

AccelStepper stepper(AccelStepper::DRIVER, stepPin, dirPin);

// ===========================
// ---- State ----
// ===========================
volatile long encoderCount = 0;
bool homed = false;
int lowCount = 0;
float targetAngle = 0.0f;
bool newTarget = false;
// limits stored in steps relative to zero after homing
long leftLimit = 0;
long rightLimit = 0;
// Manual center calibration offset (in steps). Positive shifts logical center.
static long centerOffsetSteps = 900; // user adjustable after homing

void steeringInit() {
    pinMode(enPin, OUTPUT);
    digitalWrite(enPin, HIGH); // keep disabled until driver is configured

    // Stepper driver  (AccelStepper)
    stepper.setEnablePin(enPin);
    stepper.setPinsInverted(false, false, true); // invert enable pin
    stepper.setMinPulseWidth(4);
    stepper.setMaxSpeed(1000);
    stepper.setAcceleration(600);

    // --- TMC2209 Setup (UART) ---
    Serial2.begin(115200);
    delay(100);
    driver.begin();

    // --- Common sane defaults ---
    driver.pdn_disable(true);
    driver.I_scale_analog(false);
    driver.toff(5);
    driver.blank_time(24);
    driver.rms_current(600); // mA
    driver.microsteps(MICROSTEPS);
    driver.en_spreadCycle(false);
    driver.pwm_autoscale(true);
    driver.pwm_autograd(true);
    driver.intpol(true);
    driver.TCOOLTHRS(0);

    // --- Now enable driver ---
    digitalWrite(enPin, LOW);

    homed = false;
    lowCount = 0;

    Serial.print("[STEERING] init\n");
    if (!homed) Serial.print("[STEERING] Homing..\n");
}

void steeringHome() {
    if (homed) return;

    enum HomingState { HS_INIT, HS_SEEK_NEG, HS_SEEK_POS, HS_CENTERING };
    static HomingState state = HS_INIT;

    static long lastTurnCount = 0;
    static unsigned long lastPulseAt = 0;
    static unsigned long lastAcceptedPulseAt = 0;
    static unsigned long windowStartAt = 0; // start time of pulse-rate window
    static int windowPulseCount = 0;        // accepted pulses in the current window
    static unsigned long minPulseIntervalMs = 0; // computed per speed
    static int minPulsesPerWindow = 0;      // computed threshold
    static unsigned long stateStartAt = 0;  // time when current seek state started

    static long lastPulseSteps = 0; // stepper position at last accepted encoder pulse

    static long stopNegSteps = 0; // steps at negative end stop
    static long stopPosSteps = 0; // steps at positive end stop

    // Track whether we actually saw encoder activity during each seek
    static bool sawPulseNeg = false;
    static bool sawPulsePos = false;

    unsigned long now = millis();

    switch (state) {
        case HS_INIT: {
            // Initialize encoder tracking
            lastTurnCount = wheelGetTurnCount();
            lastPulseAt = now;
            lastAcceptedPulseAt = 0;
            windowStartAt = 0;
            windowPulseCount = 0;
            stateStartAt = now;
            lastPulseSteps = stepper.currentPosition();
            sawPulseNeg = false;
            sawPulsePos = false;

            // Compute dynamic filters based on speed and encoder ppr
            minPulseIntervalMs = minPulseIntervalMsForSpeed(fabs((float)HOMING_SPEED_STEPS));
            float expectedPps = fabs((float)HOMING_SPEED_STEPS) / stepsPerEncPulse();
            float expectedPerWindow = expectedPps * (g_homingNoPulseMs / 1000.0f);
            // Require at least 50% of expected pulses to consider movement healthy; min 2
            minPulsesPerWindow = (int)floor(expectedPerWindow * 0.5f);
            if (minPulsesPerWindow < 2) minPulsesPerWindow = 2;

            // Begin seeking in negative direction
            stepper.setSpeed(-HOMING_SPEED_STEPS);
            state = HS_SEEK_NEG;
            Serial.print("[STEERING] Homing: seek negative..\n");
            break;
        }
        case HS_SEEK_NEG: {
            // Run at constant speed toward negative end
            stepper.runSpeed();

            long tc = wheelGetTurnCount();
            if (tc != lastTurnCount) {
                lastTurnCount = tc;
                // Enforce minimum time between valid pulses based on speed
                if (lastAcceptedPulseAt == 0 || (now - lastAcceptedPulseAt) >= minPulseIntervalMs) {
                    if (windowStartAt == 0) { windowStartAt = now; windowPulseCount = 0; }
                    windowPulseCount++;
                    lastPulseAt = now;               // for compatibility
                    lastAcceptedPulseAt = now;       // accepted pulse timestamp
                    lastPulseSteps = stepper.currentPosition();
                    sawPulseNeg = true;
                } else {
                    // Ignored fast pulse (likely bounce) near limit
                }
            }

            // Rate-based stall detection window
            if (windowStartAt != 0 && (now - windowStartAt) >= g_homingNoPulseMs) {
                if (windowPulseCount < minPulsesPerWindow) {
                    stopNegSteps = lastPulseSteps; // use last accepted pulse pos
                    Serial.print("[STEERING] Negative stop at steps: ");
                    Serial.println(stopNegSteps);

                    // Immediately reverse to seek positive end
                    stepper.setSpeed(HOMING_SPEED_STEPS);
                    // reset for next seek
                    stateStartAt = now;
                    lastAcceptedPulseAt = 0;
                    windowStartAt = 0;
                    windowPulseCount = 0;
                    state = HS_SEEK_POS;
                    Serial.print("[STEERING] Homing: seek positive..\n");
                    break;
                } else {
                    // healthy movement, start a new window
                    windowStartAt = now;
                    windowPulseCount = 0;
                }
            }

            // Fallback: pure inactivity (no accepted pulse yet since start)
            if (!sawPulseNeg && (now - stateStartAt) >= g_homingNoPulseMs) {
                stopNegSteps = lastPulseSteps; // at start value
                Serial.print("[STEERING] Negative stop (no pulses) at steps: ");
                Serial.println(stopNegSteps);

                stepper.setSpeed(HOMING_SPEED_STEPS);
                stateStartAt = now;
                lastAcceptedPulseAt = 0;
                windowStartAt = 0;
                windowPulseCount = 0;
                state = HS_SEEK_POS;
                Serial.print("[STEERING] Homing: seek positive..\n");
            }
            break;
        }
        case HS_SEEK_POS: {
            stepper.runSpeed();

            long tc = wheelGetTurnCount();
            if (tc != lastTurnCount) {
                lastTurnCount = tc;
                if (lastAcceptedPulseAt == 0 || (now - lastAcceptedPulseAt) >= minPulseIntervalMs) {
                    if (windowStartAt == 0) { windowStartAt = now; windowPulseCount = 0; }
                    windowPulseCount++;
                    lastPulseAt = now;
                    lastAcceptedPulseAt = now;
                    lastPulseSteps = stepper.currentPosition();
                    sawPulsePos = true;
                } else {
                    // ignored fast pulse
                }
            }

            if (windowStartAt != 0 && (now - windowStartAt) >= g_homingNoPulseMs) {
                if (windowPulseCount < minPulsesPerWindow) {
                    stopPosSteps = lastPulseSteps; // use last accepted pulse pos
                    Serial.print("[STEERING] Positive stop at steps: ");
                    Serial.println(stopPosSteps);

                    // Validate span large enough and ensure we saw at least some pulses overall
                    long minStop = min(stopNegSteps, stopPosSteps);
                    long maxStop = max(stopNegSteps, stopPosSteps);
                    long span = maxStop - minStop;

                    if (span < minSpanSteps()) {
                        Serial.print("[STEERING][WARN] Homing span too small: ");
                        Serial.println(span);
                        // restart homing
                        stepper.stop();
                        state = HS_INIT;
                        break;
                    }

                    // Move to center between the two measured stops
                    long center = minStop + span / 2;

                    stepper.moveTo(center);
                    state = HS_CENTERING;
                    Serial.print("[STEERING] Homing: move to center steps: ");
                    Serial.println(center);

                    // reset windowing for next phases
                    windowStartAt = 0;
                    windowPulseCount = 0;
                    lastAcceptedPulseAt = 0;
                } else {
                    // healthy movement, start a new window
                    windowStartAt = now;
                    windowPulseCount = 0;
                }
            }

            if (!sawPulsePos && (now - stateStartAt) >= g_homingNoPulseMs) {
                // No pulses at all -> we started already at positive limit
                stopPosSteps = lastPulseSteps;
                Serial.print("[STEERING] Positive stop (no pulses) at steps: ");
                Serial.println(stopPosSteps);

                long minStop = min(stopNegSteps, stopPosSteps);
                long maxStop = max(stopNegSteps, stopPosSteps);
                long span = maxStop - minStop;

                if (span < minSpanSteps()) {
                    Serial.print("[STEERING][WARN] Homing span too small: ");
                    Serial.println(span);
                    stepper.stop();
                    state = HS_INIT;
                    break;
                }
                long center = minStop + span / 2;
                stepper.moveTo(center);
                state = HS_CENTERING;
                Serial.print("[STEERING] Homing: move to center steps: ");
                Serial.println(center);
            }

            break;
        }
        case HS_CENTERING: {
            // Accelerated move to center
            stepper.run();
            if (stepper.distanceToGo() == 0) {
                long minStop = min(stopNegSteps, stopPosSteps);
                long maxStop = max(stopNegSteps, stopPosSteps);
                long center = (minStop + maxStop) / 2;

                // Set logical zero at center
                stepper.setCurrentPosition(0);

                // Store limits relative to zero
                leftLimit = minStop - center;
                rightLimit = maxStop - center;

                // Reset any prior calibration offset (optional: keep? choose reset for clarity)
                centerOffsetSteps = 0;

                homed = true;
                state = HS_INIT; // reset for any future homing attempts

                Serial.print("[STEERING] Homed. Limits L/R steps: ");
                Serial.print(leftLimit);
                Serial.print(" / ");
                Serial.println(rightLimit);
                Serial.print("[STEERING] Center calibration offset steps: ");
                Serial.println(centerOffsetSteps);
            }
            break;
        }
    }
}

void steeringSetHomingNoPulseMs(unsigned long ms) {
    g_homingNoPulseMs = ms;
}

void steeringUpdate() {
    if (newTarget) {
        const long steps = - wheelDegToSteps(targetAngle);
        // Apply manual center calibration offset after homing
        long adjusted = steps + (homed ? centerOffsetSteps : 0);
        // Optional: clamp to discovered limits if homed
        if (homed) {
            long clamped = constrain(adjusted, leftLimit, rightLimit);
            stepper.moveTo(clamped);
        } else {
            stepper.moveTo(adjusted);
        }
        newTarget = false;
    }
    stepper.run();
}

void steeringSetAngle(float angle) {
    // keep commanded angle within expected steering range
    targetAngle = constrain(angle, -45.0f, 45.0f);
    Serial.print("[STEERING] New target angle: ");
    Serial.println(targetAngle);
    newTarget = true;
}

float steeringGetCommandedAngle() {
    // Return the logical commanded angle (without calibration offset influence)
    return - stepsToWheelDeg(stepper.targetPosition() - (homed ? centerOffsetSteps : 0));
}

// Physical angle considering calibration offset and current position (may differ while moving)
float steeringGetPhysicalAngle() {
    return - stepsToWheelDeg(stepper.currentPosition() - (homed ? centerOffsetSteps : 0));
}

// Set center calibration offset in degrees. Positive shifts logical center by given deg.
void steeringSetCenterOffsetDeg(float deg) {
    if (!homed) return; // only after homing
    centerOffsetSteps = wheelDegToSteps(deg);
    Serial.print("[STEERING][CAL] New center offset deg: ");
    Serial.print(deg);
    Serial.print(" steps: ");
    Serial.println(centerOffsetSteps);
}
float steeringGetCenterOffsetDeg() {
    return stepsToWheelDeg(centerOffsetSteps);
}

// Convenience: apply observed physical error when commanding zero. If wheel physically points +errDeg
// (i.e., to the right) when we command 0, we want to shift center left, so subtract error.
void steeringApplyObservedZeroErrorDeg(float errDeg) {
    if (!homed) return;
    // errDeg is physical angle when commanding 0. We want future commanded 0 to yield 0 physical => offset -= errDeg
    centerOffsetSteps -= wheelDegToSteps(errDeg);
    Serial.print("[STEERING][CAL] Applied zero error deg: ");
    Serial.print(errDeg);
    Serial.print(" resulting offset deg: ");
    Serial.println(steeringGetCenterOffsetDeg());
}

// Reset calibration offset to zero (re-center logically on midpoint discovered during homing)
void steeringResetCenterCalibration() {
    centerOffsetSteps = 0;
    Serial.print("[STEERING][CAL] Center calibration reset. Offset steps: 0\n");
}
bool steeringIsHomed() { return homed; }