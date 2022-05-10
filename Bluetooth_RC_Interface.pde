import processing.serial.*;
import controlP5.*;
Serial myPort;
ControlP5 cp5;

//Initialising Global Variables
int Motor_Speed = 0;
int Steering = 0;
int Forward = 0;
int Backward = 0;
String angleStatus; 

void setup() {
  
//Inserting Controller Buttons and Sliders

size(450,500);
cp5 = new ControlP5(this);
cp5.addSlider("Steering").setPosition(50,150).  setSize(200, 100). setRange(0,255);
cp5.addSlider("Motor_Speed").setPosition(50,275).  setSize(175, 100). setRange(0,205);
cp5.addButton("Forward").setValue(205).setPosition(300,150).setSize(100,100);
cp5.addButton("Backward").setValue(205).setPosition(300,275).setSize(100,100);

//Initialising Bluetooth Communication

myPort = new Serial(this, "COM3", 9600); // Starts the serial communication at 9600 baud rate
myPort.bufferUntil('\n');// Reading Serial Data up to new line. The character '\n' or 'New Line'
}

void serialEvent (Serial myPort){// Checks for available data in the Serial Port
angleStatus = myPort.readStringUntil('\n');//Reads the data sent from the Arduino
}

void draw (){
  
//Drawing Title and Backround of Controller
  background(20,150,200);
  fill(120,170,220);
  rect(10,10,425,50);
  fill(0);
  textSize(23);
  text("RC Car Bluetooth Controller Interface",15,45);

  //Defining RC Car Parameters 000-000-0
  //000-xxx-x = Steering
  //xxx-000-x = Motor Speed
  //xxx-xxx-0 = Motor ON/OFF  
  
//String needs to be defined inside the draw function to keep updating strings
String sfSteering = nf(Steering,3);       //3-digit steering value
String sfMotor_Speed = nf(Motor_Speed,3); //3-digit motor-speed value


if(mousePressed&& mouseX>300 && mouseX<400 && mouseY>150 && mouseY<250){
       println('<'+sfSteering + sfMotor_Speed + "1"+'>');     
       myPort.write('<'+sfSteering + sfMotor_Speed + "1"+'>'); delay(100);} //Send Go FWD String to Arduino

else if(mousePressed&& mouseX>300 && mouseX<400 && mouseY>275 && mouseY<375){
       println('<'+sfSteering + sfMotor_Speed + "2"+'>');
    
       myPort.write('<'+sfSteering + sfMotor_Speed + "2"+'>'); delay(100);} //Send Go BCK String to Arduino
     else{
       println('<'+sfSteering + sfMotor_Speed + "0"+'>');
      
       myPort.write('<'+sfSteering + sfMotor_Speed + "0"+'>'); delay(100);} //Send STOP String to Arduino
 
}
