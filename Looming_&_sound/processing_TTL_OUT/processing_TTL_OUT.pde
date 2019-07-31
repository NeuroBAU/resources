import processing.serial.*;

Serial myPort;

void setup() 
{
  size(200, 200);
  String portName = Serial.list()[1]; // !!! MAC
  //String portName = Serial.list()[0]; // !!! Windows
  myPort = new Serial(this, portName, 9600);
}

void draw() {
  if (mousePressed == true) {                           
    myPort.write('1');        
    println("1");
  } else {                           
    myPort.write('0');
    println("0");
  }
}
