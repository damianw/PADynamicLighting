import java.awt.AWTException;
import java.awt.Robot;
import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.awt.*;
import processing.serial.*;

final int TOLERANCE = 0;

PImage screenShot;
Serial port;
color[] colors = new color[10];
boolean forward = true;
WriteThread writethread = new WriteThread();

int segmentWidth = 0;

void setup() {
  size(displayWidth/2, displayHeight/10);
  segmentWidth = displayWidth/10;
  screenShot = getScreen();
  //thread("screenLoop");
  port = new Serial(this, Serial.list()[1], 115200);
}

void screenLoop() {
  while(true) {
    screenShot = getScreen();
  }
}

void draw () {
  //image(screenShot,0,0, width, height);
  //delay(250);
  screenShot = getScreen();
  //for v2
  //port.write('d');
  IterThread threads[] = new IterThread[10];
  if (forward){
    for (int i = 0; i < 10; i++){
      //pixLoop(i);
      IterThread foo = new IterThread(i);
      threads[i] = foo;
      foo.start();
    }
    forward = false;
  } else {
    for (int i = 9; i >= 0; i--){
      //pixLoop(i);
      IterThread foo = new IterThread(i);
      threads[i] = foo;
      foo.start();
    }
    forward = true;
  }
  boolean ready = false;
  while (!ready) {
    for (IterThread thread : threads){
      ready = ready || thread.running;
    }
  }
  while(writethread.running);
  writethread = new WriteThread();
  writethread.start();
//  for (int i = 0; i < 10; i++){
//    port.write("p" + (char)i + "c" + (char)red(colors[i]) + (char)green(colors[i]) + (char)blue(colors[i]));
//    port.write('p');
//    port.write(i);
//    port.write('c');
//    port.write((int)red(colors[i]));
//    port.write((int)green(colors[i]));
//    port.write((int)blue(colors[i]));
//  }
}

void write() {
  for (int i = 0; i < 10; i++){
    port.write('p');
    port.write(i);
    port.write('c');
    port.write((int)red(colors[i]));
    port.write((int)green(colors[i]));
    port.write((int)blue(colors[i]));
  }
}

void pixLoop(int i) {
  int start = i*segmentWidth;
  int end = start + segmentWidth;
  //println("Segment: " + start + ", " + segmentWidth);
  PImage segment = screenShot.get(start, 0, segmentWidth, displayHeight);
  //PImage segment = screenShot.get(start, 0, segmentWidth, 1);
  color avg = average(segment);
  if ((red(avg) > red(colors[i]) + TOLERANCE || red(avg) < red(colors[i]) - TOLERANCE) ||
    (green(avg) > green(colors[i]) + TOLERANCE || green(avg) < green(colors[i]) - TOLERANCE) ||
    (blue(avg) > blue(colors[i]) + TOLERANCE || blue(avg) < blue(colors[i]) - TOLERANCE)) {
      port.write('p');
      port.write(i);
      port.write('c');
      port.write((int)red(avg));
      port.write((int)green(avg));
      port.write((int)blue(avg));
      //print(hex(avg) + ' ');
      fill(avg); 
      rect(start/2, 0, segmentWidth/2, displayHeight/10);
      colors[i] = avg;
    }
}

color average(PImage segment) {
  long rsum = 0, gsum = 0, bsum = 0;
  //for (int i = 0; i < segment.pixels.length; i+=10){
  //  color pixel = segment.pixels[i];
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
