#include <Servo.h>

//for reading characters in

const byte numChars = 32;
char receivedChars[numChars];

boolean newData = false;

//Inititalise Servo
Servo myServo;

//Define Motor H-Bridge Parameters
int In1 = 7;
int In2 = 8;
int ENA = 5;

//Define variables for incoming bluetooth data
long tmr;
int flag = 0;
String RCSteer;
String RCMotorSpeed;
String Motor_Polarity;
int RCSteer_Int ;
int RCMotorSpeed_Int;
int Motor_Polarity_Int;
int angle;
char  c;

void setup() {

  //Inialise Servo Data Pin
  myServo.attach(3);

  //Initialise H-Bridge Pins Data Output
  pinMode (In1, OUTPUT);
  pinMode (In2, OUTPUT);
  pinMode (ENA, OUTPUT);

  //Initialise Bluetooth Serial communication + Serial Interupt Signal
  Serial.begin(9600);
  delay(100);
}

void loop() {
  
  //Read Strings into Arduino
    recvWithStartEndMarkers();
    showNewData();
    
     //Convert Character Array to String Object
    String RCString = receivedChars;
      
    //Extract Control Components
    RCSteer = RCString.substring(0, 3);
    RCMotorSpeed = RCString.substring(3, 6);
    Motor_Polarity = RCString.substring(6, 7);

    //Convert Strings to Integers
    RCSteer_Int = RCSteer.toInt();
    RCMotorSpeed_Int = RCMotorSpeed.toInt();
    Motor_Polarity_Int = Motor_Polarity.toInt();

    //Print data to Serial Monitor
    Serial.print("RCcode:  ");
    Serial.print(receivedChars);
    Serial.print("  Steering Value:  ");   
    Serial.print(RCSteer_Int);
    Serial.print("  ANGLE:  ");
    Serial.print(angle);
    Serial.print("  Speed Value:  ");
    Serial.print(RCMotorSpeed_Int);
    Serial.print("  Polarity Value:  ");
    Serial.println(Motor_Polarity_Int);   

    //Calling Steer and MotorControl Functions
    Steer(RCSteer_Int);
    MotorControl(Motor_Polarity_Int,RCMotorSpeed_Int); 

  }

void Steer(int RCSteer_Int){
  //Send Steering Data to Servo
  angle = map(RCSteer_Int, 0, 255, 0, 180);
  myServo.write(angle);
}

void MotorControl(int Motor_Polarity_Int, int RCMotorSpeed_Int){
  
    //Motor Logic
    switch(Motor_Polarity_Int){

    // FORWARDS
    case 1:  
      analogWrite(ENA, RCMotorSpeed_Int);
      digitalWrite(In1, HIGH);
      digitalWrite(In2, LOW);
    break;
    
    // BACKWARDS
    case 2: 
      analogWrite(ENA, RCMotorSpeed_Int);
      digitalWrite(In1, LOW);
      digitalWrite(In2, HIGH);
    break;

    // STOP
    case 0: 
    digitalWrite(In1, LOW);
    digitalWrite(In2, LOW);
    break;
    } 
}
void recvWithStartEndMarkers() {
    static boolean recvInProgress = false;
    static byte ndx = 0;
    char startMarker = '<';
    char endMarker = '>';
    char rc;
 
    while (Serial.available() > 0 && newData == false) {
        rc = Serial.read();

        if (recvInProgress == true) {
            if (rc != endMarker) {
                receivedChars[ndx] = rc;
                ndx++;
                if (ndx >= numChars) {
                    ndx = numChars - 1;
                }
            }
            else {
                receivedChars[ndx] = '\0'; // terminate the string
                recvInProgress = false;
                ndx = 0;
                newData = true;
            }
        }

        else if (rc == startMarker) {
            recvInProgress = true;
        }
    }
}

void showNewData() {
    if (newData == true ){
        newData = false;
    }
}
