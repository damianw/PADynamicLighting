import java.awt.AWTException;
import java.awt.Robot;
import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.awt.*;
import processing.serial.*;

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
  port = new Serial(this, Serial.list()[1], 115200);
}

void draw () {
  screenShot = getScreen();
  IterThread threads[] = new IterThread[10];
  for (int i = 0; i < 10; i++){
    IterThread foo = new IterThread(i);
    threads[i] = foo;
    foo.start();
  }
  boolean unready = true;
  while (unready) {
    unready = false;
    for (IterThread thread : threads){
      unready = unready || thread.running;
    }
  }
  while(writethread.running);
  writethread = new WriteThread();
  writethread.start();
}

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
