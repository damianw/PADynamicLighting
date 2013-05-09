class WriteThread extends Thread {
  boolean running;           // Is the thread running?  Yes or no?
  boolean available;
 
  // Constructor, create the thread
  // It is not running by default
  WriteThread () {
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
    for (int i = 0; i < 10; i++){
      port.write("p" + (char)i + "c" + (char)red(colors[i]) + (char)green(colors[i]) + (char)blue(colors[i]));
//      port.write('p');
//      port.write(i);
//      port.write('c');
//      port.write((int)red(colors[i]));
//      port.write((int)green(colors[i]));
//      port.write((int)blue(colors[i]));
    }
    quit();
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
