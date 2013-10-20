import java.awt.AWTException;
import java.awt.Robot;
import java.awt.Rectangle;
import java.awt.image.BufferedImage;
import java.awt.*;
import processing.serial.*;

PImage screenshot;
color[] colors;
WriteThread writethread;
SegmentThread[] segments;

int segmentWidth = 0;

void setup() {
	colors = new color[10];
	writethread = new WriteThread(this);
	segments = new SegmentThread[10];

	size(displayWidth/2, displayHeight/10); // debug window
  segmentWidth = displayWidth/10; // 10 segments
  screenshot = getScreen(); // start with a screenshot
  // make sure to set the serial port as appropriate

  for (int i = 0; i < 10; i++) {
  	colors[i] = color(0, 0, 0);
  	segments[i] = new SegmentThread(i);
  	segments[i].start();
  }

  writethread.start();

}

void draw(){
	screenshot = getScreen();
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
