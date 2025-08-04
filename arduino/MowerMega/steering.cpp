#include "steering.h"
#include <Arduino.h>

const int stepPin = 2;
const int dirPin = 3;
const int opticalPin = 6;

// ---- Encoder Pins ----
const int encoderPinA = 20;
const int encoderPinB = 21;

// ---- Steering Config ----
const float stepsPerRevolution = 200.0 * 16.0;
const float steeringRange = 90.0;
const float encoderPPR = 600.0;
const float gearRatio = 5.0;

AccelStepper stepper(AccelStepper::DRIVER, stepPin, dirPin);

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
  pinMode(opticalPin, INPUT_PULLUP);
  pinMode(encoderPinA, INPUT_PULLUP);
  pinMode(encoderPinB, INPUT_PULLUP);

  attachInterrupt(digitalPinToInterrupt(encoderPinA), encoderISR, RISING);

  stepper.setMaxSpeed(1000);
  stepper.setAcceleration(500);

  homed = false;
  lowCount = 0;
  
  Serial.println("System starting...");
}


void steeringHome() {
  if (homed) return;
  stepper.setSpeed(-200);
  stepper.runSpeed();

  if(digitalRead(opticalPin) == LOW) lowCount++;
  else lowCount = 0;

  if(lowCount >= 2) {
    stepper.stop();
    stepper.setCurrentPosition(0);
    encoderCount = 0;
    homed = true;
    Serial.println("Steering homed to zero");
  }
}

void steeringUpdate() {
  if(newTarget) {
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
