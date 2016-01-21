import processing.serial.*;

Serial myPort;

byte inByte;
boolean isOn;
float amplitude = 30;
float fillGap = 2.5;
float freq_mod = 1.0;

byte[] readBuffer = new byte[32];
int numReadBytes = 0;

int sensorVal1;
int sensorVal2;


//For details of ICubeX commands, check out the firmware API documentation
static final byte[] ICUBE_RESET = new byte[] { (byte)0xF0, (byte)0x7D, (byte) 0x00, (byte)0x22, (byte)0xF7};
static final byte[] ICUBE_SET_HOST = new byte[] { (byte)0xF0, (byte)0x7D, (byte) 0x00, (byte)0x5A, (byte)0x00, (byte)0xF7};

static final byte[] ICUBE_STREAM1 = new byte[] { (byte)0xF0, (byte)0x7D, (byte) 0x00, (byte) 0x01, (byte) 0x41, (byte)0xF7};
static final byte[] ICUBE_STOP1 = new byte[] { (byte)0xF0, (byte)0x7D, (byte) 0x00, (byte) 0x01, (byte) 0x01, (byte)0xF7};

static final byte[] ICUBE_STREAM2 = new byte[] { (byte)0xF0, (byte)0x7D, (byte) 0x00, (byte) 0x01, (byte) 0x42, (byte)0xF7};
static final byte[] ICUBE_STOP2 = new byte[] { (byte)0xF0, (byte)0x7D, (byte) 0x00, (byte) 0x01, (byte) 0x02, (byte)0xF7};


void setup() {

  isOn = false;
  size(640, 360);
  int idx = -1;

  //go through list and look for serial port.
  // NOTE: on windows it will be a COMX port, and the code
  // below will have the be modified accordingly.
  for (int i=0; i<Serial.list().length; i++) {
    //print(Serial.list()[i]);
    println("");
    if (Serial.list()[i].equals("/dev/tty.SLAB_USBtoUART")) {
      println("found icube at idx = " +i);
      idx = i;
      break;
    }
  }

  //connect to the first available ICubeX port
  if (idx != -1) {
    myPort = new Serial(this, Serial.list()[idx], 115200);
    println("opening port...");

    //Reboot and set up sensor
    println("sending reset");
    myPort.write(ICUBE_RESET);
    
    println("sending host cmd");
    myPort.write(ICUBE_SET_HOST);
    
    delay(1000);
  }
}

void serialEvent(Serial myPort) {
  
  //this method keeps track of incoming bytes
  // and assembles a complete message.
  // NOTE: we're not doing overflow checking so
  // assume data coming from digitizer is correct
  
  //print(String.format("%02x ", inByte));
  inByte = (byte) myPort.read();
  readBuffer[numReadBytes] = inByte;
  numReadBytes++;
  if (inByte == (byte)0xf7)
  {
    //If we have more than two sensors on, the positions
    // of sensor values will have to be adjusted.
    for (int i=0; i<numReadBytes; i++) {
      //print(String.format("%02x ", readBuffer[i]));
      sensorVal1 = (int) readBuffer[4];
      sensorVal2 = (int) readBuffer[5];
    }
    numReadBytes = 0;
    //println("");
  }
  //if (inByte == 0xF7)
  //  println("");
}

void draw() {

  amplitude = map(sensorVal1, 1, 127, 2, 50);
  freq_mod = map(sensorVal2, 1, 127, 1.2, 4);

  setGrad(); //from examples; draw something pretty!
  println(sensorVal1+" "+sensorVal2);
}

void mousePressed()
{
  //we toggle the sensors each time the mouse is pressed
  isOn = !isOn;
  if (isOn) {

    myPort.write(ICUBE_STREAM1);
    myPort.write(ICUBE_STREAM2);
  } else {
    myPort.write(ICUBE_STOP1);
    myPort.write(ICUBE_STOP2);
  }
  println("turning on sensor 0");
  //myPort.write(ICUBE_STREAM0);
}

//this is modified from the Basic/Color/WaveGradient example, 
// just to show some stuff on screen that react to sensor input

void setGrad() {
  PImage gradient = createImage((int)(width*freq_mod), (int)(height*freq_mod), RGB);
  float frequency = 0;

  for (int i =- 75; i < height+75; i++) {
    // Reset angle to 0, so waves stack properly
    float angle = 0;
    // Increasing frequency causes more gaps
    frequency += 0.002*freq_mod;
    for (float j = 0; j < width+75; j++) {
      float py = i + sin(radians(angle)) * amplitude;
      angle += frequency;
      color c = color(abs(py-i)*255/amplitude, 255-abs(py-i)*255/amplitude, j*(255.0/(width+50)));
      // Hack to fill gaps. Raise value of fillGap if you increase frequency
      for (int filler = 0; filler < fillGap; filler++) {
        gradient.set(int(j-filler), int(py)-filler, c);
        gradient.set(int(j), int(py), c);
        gradient.set(int(j+filler), int(py)+filler, c);
      }
    }
  }
  // Draw the image to the screen
  set(int(-freq_mod*20), int(-freq_mod*20), gradient);
}