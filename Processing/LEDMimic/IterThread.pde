class IterThread extends Thread {
  boolean running;
  int iter;
 
  IterThread (int iter) {
    this.iter = iter;
    running = false;
  }
  
  void start () {
    running = true;
    super.start();
  }
 
  void run () {
    int i = iter;
    int start = i*segmentWidth;
    int end = start + segmentWidth;
    //println("Segment: " + start + ", " + segmentWidth);
    PImage segment = screenShot.get(start, 0, segmentWidth, displayHeight);
    //uncomment for single row at top
    //PImage segment = screenShot.get(start, 0, segmentWidth, 1);
    color avg = average(segment);
    fill(avg); 
    rect(start/2, 0, segmentWidth/2, displayHeight/10);
    colors[i] = avg;
    quit();
  }

  void quit() {
    running = false;
    interrupt();
  }

}
