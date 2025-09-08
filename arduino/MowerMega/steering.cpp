#include "steering.h"
#include <Arduino.h>
#include <AccelStepper.h>
#include <TMCStepper.h>

// ---- Stepper Driver Pins ----

const int dirPin = 2;
const int stepPin = 3;
const int enPin = 4;

const int opticalPin = 6;

// ---- Encoder Pins ----
const int encoderPinA = 20;
const int encoderPinB = 21;

// --- TMC2209 UART on MEGA Serial2 ----
#define R_SENSE 0.11f // Match to your driver
TMC2209Stepper driver(&Serial2, R_SENSE, 0b00);

// ---- Steering Config ----
static const uint16_t MICROSTEPS = 16;
const float stepsPerRevolution = 200.0 * MICROSTEPS;
const float steeringRange = 90.0;
const float encoderPPR = 600.0;
const float gearRatio = 5.0;

AccelStepper stepper(AccelStepper::DRIVER, stepPin, dirPin);

// ---- State ----
volatile long encoderCount = 0;
bool homed = false;
int lowCount = 0;
float targetAngle = 0.0;
bool newTarget = false;

void encoderISR() {
    int b = digitalRead(encoderPinB);
    encoderCount += (b == HIGH) ? 1 : -1;
}

void steeringInit() {
    pinMode(enPin, OUTPUT);
    digitalWrite(enPin, HIGH); // keep disabled until driver is configured

    pinMode(opticalPin, INPUT_PULLUP);
    pinMode(encoderPinA, INPUT_PULLUP);
    pinMode(encoderPinB, INPUT_PULLUP);

    attachInterrupt(digitalPinToInterrupt(encoderPinA), encoderISR, RISING);

    stepper.setEnablePin(enPin);
    stepper.setPinsInverted(false, false, true); // invert enable pin
    stepper.setMinPulseWidth(4);
    stepper.setMaxSpeed(1000);
    stepper.setAcceleration(500);

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

    if (now - homeTime >= 5000) {
        homeTime = now;
        stepper.stop();
        stepper.setCurrentPosition(0);
        homed = true;
        Serial.println();
        Serial.print("[STEERING] Steering homed to zero\n");
    }
    stepper.setSpeed(500);
    stepper.runSpeed();

    if (digitalRead(opticalPin) == LOW) lowCount++;
    else lowCount = 0;

    // Double low for zero notch
    if (lowCount >= 2) {
        stepper.stop();
        stepper.setCurrentPosition(0);
        encoderCount = 0;
        homed = true;
        Serial.print("[STEERING] Steering homed to zero\n");
    }
}

void steeringUpdate() {
    if (newTarget) {
        long steps = (targetAngle * stepsPerRevolution) / steeringRange;
        stepper.moveTo(steps);
        newTarget = false;
    }
    stepper.run();
}

void steeringSetAngle(float angle) {
    targetAngle = constrain(angle, -45.0, 45.0);
    newTarget = true;
}

float steeringGetCommandedAngle() {
    return (stepper.targetPosition() * steeringRange) / stepsPerRevolution;
}

float steeringGetActualAngle() {
    return (encoderCount * 360) / (encoderPPR * gearRatio);
}

bool steeringIsHomed() { return homed; }
