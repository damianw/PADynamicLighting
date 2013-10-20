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

void setup() {
  size(displayWidth/2, displayHeight/10); // debug window
  segmentWidth = displayWidth/10; // 10 segments
  screenShot = getScreen(); // start with a screenshot
  port = new Serial(this, Serial.list()[0], 115200); // connect to arduino
  // make sure to set the serial port as appropriate
}

void draw () {
  screenShot = getScreen(); // take a screenshot
  // TODO find a way to optimize this
  IterThread threads[] = new IterThread[10]; // a thread for each segment
  for (int i = 0; i < 10; i++){ // run each thread
    IterThread foo = new IterThread(i);
    threads[i] = foo;
    foo.start();
  }
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
