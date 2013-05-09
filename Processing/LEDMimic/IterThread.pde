class IterThread extends Thread {
  boolean running;           // Is the thread running?  Yes or no?
  boolean available;
  int iter;
 
  // Constructor, create the thread
  // It is not running by default
  IterThread (int iter) {
    this.iter = iter;
    running = false;
  }
  
  // Overriding "start()"
  void start () {
    // Set running equal to true
    running = true;
    // Do whatever start does in Thread, don't forget this!
    super.start();
  }
 
 
   // We must implement run, this gets triggered by start()
  void run () {
    int i = iter;
    int start = i*segmentWidth;
    int end = start + segmentWidth;
    //println("Segment: " + start + ", " + segmentWidth);
    PImage segment = screenShot.get(start, 0, segmentWidth, displayHeight);
    //PImage segment = screenShot.get(start, 0, segmentWidth, 1);
    color avg = average(segment);
//    if ((red(avg) > red(colors[i]) + TOLERANCE || red(avg) < red(colors[i]) - TOLERANCE) ||
//      (green(avg) > green(colors[i]) + TOLERANCE || green(avg) < green(colors[i]) - TOLERANCE) ||
//      (blue(avg) > blue(colors[i]) + TOLERANCE || blue(avg) < blue(colors[i]) - TOLERANCE)) {
//        port.write('p');
//        port.write(i);
//        port.write('c');
//        port.write((int)red(avg));
//        port.write((int)green(avg));
//        port.write((int)blue(avg));
        //print(hex(avg) + ' ');
        fill(avg); 
        rect(start/2, 0, segmentWidth/2, displayHeight/10);
        colors[i] = avg;
//    }
  }
  
  // Our method that quits the thread
  void quit() {
    running = false;  // Setting running to false ends the loop in run()
    // IUn case the thread is waiting. . .
    interrupt();
  }
  
  boolean available(){
    return available;
  }
}
