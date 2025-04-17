#include <Wire.h>
#include <Adafruit_PWMServoDriver.h>
Adafruit_PWMServoDriver pwm = Adafruit_PWMServoDriver();
#define SERVOMIN  150 // This is the 'minimum' pulse length count (out of 4096)
#define SERVOMAX  600 // This is the 'maximum' pulse length count (out of 4096)
#define USMIN  600 // This is the rounded 'minimum' microsecond length based on the minimum pulse of 150
#define USMAX  2400 // This is the rounded 'maximum' microsecond length based on the maximum pulse of 600
#define SERVO_FREQ 50 // Analog servos run at ~50 Hz updates
#define L_OFF  300
#define L_ON 200
#define F1 130
#define F2 290
#define F3 470
uint8_t servonum = 0;
int command = 0;
int waittime = 0;
int currentServoPos = L_OFF;
void setup() {

  pwm.begin();
  pwm.setOscillatorFrequency(27000000);
  pwm.setPWMFreq(SERVO_FREQ);  // Analog servos run at ~50 Hz updates
  delay(10);
  Serial.begin(115200);
  pwm.setPWM(0, 0, L_OFF);
  pwm.setPWM(1, 0, L_OFF);
  pwm.setPWM(2, 0, L_OFF);
}
void loop() {
  while (Serial.available() > 0) {
    commandParser();
  }
}
void commandParser() {
  command = Serial.parseInt();
  waittime = Serial.parseInt();
  if (Serial.read() == '\n') {
    rotateServo();
  }

}
void rotateServo() {
  //Laser 1 ON
  if (command == 1) {
    pwm.setPWM(0, 0, L_ON);
  }
  //Laser 1 OFF
  if (command == 2) {
    pwm.setPWM(0, 0, L_OFF);
  }
  //Laser 1 Only
  if (command == 10) {
    pwm.setPWM(1, 0, L_OFF);
    pwm.setPWM(2, 0, L_OFF);

     for(int pos = currentServoPos ; pos > F1; pos -= 10) {
      pwm.setPWM(3, 0, pos);
      delayMicroseconds(10);
    }
    currentServoPos = F1;
    pwm.setPWM(0, 0, L_ON);
    delay(waittime);
    Serial.println("OK");
  }
  ///////////////////////////
  //Laser 2 ON
  if (command == 3) {
    pwm.setPWM(1, 0, L_ON);
  }
  //Laser 2 OFF
  if (command == 4) {
    pwm.setPWM(1, 0, L_OFF);
  }
  //Laser 2 Only
  if (command == 20) {
    pwm.setPWM(0, 0, L_OFF);
    pwm.setPWM(2, 0, L_OFF);
    if (currentServoPos == F1) {
      for(int pos = currentServoPos ; pos < F2; pos += 10) {
      pwm.setPWM(3, 0, pos);
      delayMicroseconds(10);
      } 
    }
    else if (currentServoPos == F3) {
    for(int pos = currentServoPos ; pos > F2; pos -= 10) {
      pwm.setPWM(3, 0, pos);
      delayMicroseconds(10);
      }
    } 
    currentServoPos = F2;
    pwm.setPWM(1, 0, L_ON);
    delay(waittime);    
    Serial.println("OK");
  }
  ////////////////////////////
  //Laser 3 ON
  if (command == 5) {
    pwm.setPWM(2, 0, L_ON);
  }
  //Laser 3 OFF
  if (command == 6) {
    pwm.setPWM(2, 0, L_OFF);
  }
  //Laser 3 Only
  if (command == 30) {
    pwm.setPWM(0, 0, L_OFF);
    pwm.setPWM(1, 0, L_OFF);
    
    for(int pos = currentServoPos ; pos < F3; pos += 10) {
      pwm.setPWM(3, 0, pos);
      delayMicroseconds(10);
    }
    currentServoPos = F3;

    pwm.setPWM(2, 0, L_ON);
    delay(waittime);
    Serial.println("OK");

  }

}
