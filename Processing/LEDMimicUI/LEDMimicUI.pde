import controlP5.*;
import java.awt.AWTException;
import java.awt.Robot;
import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.awt.*;
import processing.serial.*;

PImage screenShot; // keep a global screenshot var
Serial port; // to communicate with the arduino
color[] colors = new color[10]; // array to hold colors for the strip
WriteThread writethread = new WriteThread(); // thread writing to arduino

int segmentWidth = 0; // constant pixel width of segment

ControlP5 cp5;
Knob colorKnob;
color mainColor;

boolean power = false;
boolean auto = false;

void setup() {
  size(displayWidth/2, displayHeight/10); // debug window
  segmentWidth = displayWidth/10; // 10 segments
  screenShot = getScreen(); // start with a screenshot
  port = new Serial(this, Serial.list()[1], 115200); // connect to arduino
  // make sure to set the serial port as appropriate

  mainColor = color(0);
  size(300, 400);
  smooth();
  background(0);
  cp5 = new ControlP5(this);
  
  cp5.addToggle("powertoggle")
    .setPosition(20,20)
    .setSize(80,40)
    .setValue(false)
    .setMode(ControlP5.SWITCH);
    
  colorKnob = cp5.addKnob("colorknob")
                 .setRange(0,255)
                 .setValue(0)
                 .setPosition(75,120)
                 .setRadius(75)
                 .setDragDirection(Knob.HORIZONTAL)
                 //.setLabelVisible(false);
                 .setColorBackground(color(0))
                 .setColorForeground(color(0))
                 .setColorActive(color(0));
  colorKnob.captionLabel().set("Color");
  
  cp5.addToggle("autotoggle")
    .setPosition(240,20)
    .setSize(40,40)
    .setValue(false);
                    
}

void colorknob(int value) {
  colorMode(HSB, 255);
  mainColor = color(value, 255, 255);
  colorMode(RGB, 255);
  if (value == 255) mainColor = color(255);
  
   for (int i = 0; i < 10; i++){
     colors[i] = mainColor;
   }
   beginWrite();
}

void powertoggle(boolean value) {
  writethread.quit();
  if (value) colorknob((int)colorKnob.getValue());
  power = value;
}

void autotoggle(boolean value) {
  writethread.quit();
  if (!value) colorknob((int)colorKnob.getValue());
  auto = value;
}

void draw(){
  if (auto || !power) {
    colorKnob.setColorBackground(color(150));
    colorKnob.setColorForeground(color(80));
    colorKnob.setColorActive(color(80));
    colorKnob.lock();
  } else {
    colorKnob.setColorBackground(mainColor);
    colorKnob.setColorForeground(color(0));
    colorKnob.setColorActive(color(0));
    colorKnob.unlock();
  }
  if (power) {
    if (auto) {
      screenShot = getScreen(); // take a screenshot
      // TODO find a way to optimize this
      IterThread threads[] = new IterThread[10]; // a thread for each segment
      for (int i = 0; i < 10; i++){ // run each thread
        IterThread foo = new IterThread(i);
        threads[i] = foo;
        foo.start();
      }
      beginWrite();
    } else {
     
    }
    //thread("beginWrite");
    
  } else {
    for (int i = 0; i < 10; i++){
      colors[i] = color(0);
    }
    beginWrite();
  }
}

void beginWrite() {
  // wait until the writethread is done, then write
  while(writethread.running);
  writethread = new WriteThread();
  writethread.start();
}

//calculates the average color of a segment
color average(PImage segment) {
  long rsum = 0, gsum = 0, bsum = 0;
  for (color pixel : segment.pixels) {
    rsum += red(pixel);
    gsum += green(pixel);
    bsum += blue(pixel);
  }
  if (segment.pixels.length == 0) {
    return color(0, 0, 0);
  }
  rsum /= segment.pixels.length;
  gsum /= segment.pixels.length;
  bsum /= segment.pixels.length;
  return color(rsum, gsum, bsum);
}

// takes a screenshot
// TODO optimize this
PImage getScreen() {
  GraphicsEnvironment ge = GraphicsEnvironment.getLocalGraphicsEnvironment();
  GraphicsDevice[] gs = ge.getScreenDevices();
  DisplayMode mode = gs[0].getDisplayMode();
  Rectangle bounds = new Rectangle(0, 0, mode.getWidth(), mode.getHeight());
  BufferedImage desktop = new BufferedImage(mode.getWidth(), mode.getHeight(), BufferedImage.TYPE_INT_RGB);

  try {
    desktop = new Robot(gs[0]).createScreenCapture(bounds);
  }
  catch(AWTException e) {
    System.err.println("Screen capture failed.");
  }

  return (new PImage(desktop));
}
