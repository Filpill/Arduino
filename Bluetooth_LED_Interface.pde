import processing.serial.*;
Serial myPort;
String ledStatus="LED: OFF";


void setup() {
size(450,500);
myPort = new Serial(this, "COM5", 9600); // Starts the serial communication
myPort.bufferUntil('\n');// Defines up to which character the data from the serial port will be read. 
//The character '\n' or 'New Line'
}

void serialEvent (Serial myPort){// Checks for available data in the Serial Port
  ledStatus = myPort.readStringUntil('\n');//Reads the data sent from the Arduino (the String "LED: OFF/ON) 
  //and it puts into the "ledStatus" variable
  //println(ledStatus);
}

void draw(){
  background(237, 240, 241);
  fill(20, 160, 133);
  stroke(33);
  strokeWeight(1);
  rect(50, 100, 150, 50, 10);
  rect(250, 100, 150, 50, 10);
  fill(255);

  textSize(32);
  text("Turn ON", 60, 135);
  text("Turn OFF", 255, 135);
  textSize(24);
  fill(33);
  text("Status:", 180, 200);
  textSize(30);
  textSize(16);

  text(ledStatus,155,240);

  if(mousePressed && mouseX>50 && mouseX<200 && mouseY>100 && mouseY<150){
    myPort.write('1'); // Sends the character '1' to the arduino and that will turn on the LED
    stroke(255,0,0);
    strokeWeight(2);
    noFill();
    rect(50, 100, 150, 50, 10);
  }
  if(mousePressed && mouseX>250 && mouseX<400 && mouseY>100 && mouseY<150){
    myPort.write('0'); // Sends the character '0' to the arduino and that will turn on the LED
    stroke(255,0,0);
    strokeWeight(2);
    noFill();
    rect(250, 100, 150, 50, 10);
  }
}
