// thread for an individual LED segment
// calculates the appropriate color and saves it to 'colors'
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
    PImage segment = screenShot.get(start, 0, segmentWidth, displayHeight);
    //uncomment for single row at top
    //PImage segment = screenShot.get(start, 0, segmentWidth, 1);
    color avg = average(segment);
    fill(avg); 
    rect(i*30, 380, 30, 20);
    colors[i] = avg;
    quit();
  }

  void quit() {
    running = false;
    interrupt();
  }

}
