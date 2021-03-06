// thread for writing the colors to the arduino
class WriteThread extends Thread {
  boolean running;
 
  WriteThread () {
    running = false;
  }
  
  void start () {
    running = true;
    super.start();
  }

  void run () {
    // write each color to the arduino
    for (int i = 0; i < 10; i++){
      port.write("p" + (char)i + "c" + (char)red(colors[i])
        + (char)green(colors[i]) + (char)blue(colors[i]));
    }
    quit();
  }
  
  void quit() {
    running = false;
    interrupt();
  }

}
