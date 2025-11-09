#include "steering.h"
#include <Arduino.h>
#include <AccelStepper.h>
#include <TMCStepper.h>

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

AccelStepper stepper(AccelStepper::DRIVER, stepPin, dirPin);

// ===========================
// ---- State ----
// ===========================
volatile long encoderCount = 0;
bool homed = false;
int lowCount = 0;
float targetAngle = 0.0f;
bool newTarget = false;

void steeringInit() {
    pinMode(enPin, OUTPUT);
    digitalWrite(enPin, HIGH); // keep disabled until driver is configured

    // Stepper driver  (AccelStepper)
    stepper.setEnablePin(enPin);
    stepper.setPinsInverted(false, false, true); // invert enable pin
    stepper.setMinPulseWidth(4);
    stepper.setMaxSpeed(500);
    stepper.setAcceleration(300);

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
    static unsigned long lastDotTime = 0;
    unsigned long now = millis();
    static unsigned long homeTime = 0;
    if (now - lastDotTime > 1000) {
        Serial.print(".");
        lastDotTime = now;
    }
    // TEMP (until optical installed)

    if (now - homeTime >= 4000) {
        homeTime = now;
        stepper.stop();
        stepper.setCurrentPosition(0);
        homed = true;
        Serial.println();
        Serial.print("[STEERING] Steering homed to zero\n");
    }
}

void steeringUpdate() {
    if (newTarget) {
        const long steps = - wheelDegToSteps(targetAngle);
        stepper.moveTo(steps);
        newTarget = false;
    }
    stepper.run();
}

void steeringSetAngle(float angle) {
    targetAngle = constrain(angle, -45.0f, 45.0f);
    Serial.print("[STEERING] New target angle: ");
    Serial.println(targetAngle);
    newTarget = true;
}

float steeringGetCommandedAngle() {
    return stepsToWheelDeg(stepper.targetPosition());
}

bool steeringIsHomed() { return homed; }