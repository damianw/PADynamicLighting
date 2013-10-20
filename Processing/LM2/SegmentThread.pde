// thread for an individual LED segment
// calculates the appropriate color and saves it to 'colors'
class SegmentThread extends Thread {
  boolean running;
  int num;
 
  SegmentThread (int num) {
    this.num = num;
    running = false;
  }
  
  void start () {
    running = true;
    super.start();
  }
 
  void run () {
    while (true) {
      int start = num * segmentWidth;
      int end = start + segmentWidth;
      PImage segment = screenshot.get(start, 0, segmentWidth, displayHeight);
      color avg = average(segment);
      fill(avg); 
      rect(start/2, 0, segmentWidth/2, displayHeight/10);
      colors[num] = avg;
      quit();
    }
  }

  void quit() {
    running = false;
    interrupt();
  }

}
