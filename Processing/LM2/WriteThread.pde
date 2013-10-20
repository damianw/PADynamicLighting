// thread for writing the colors to the arduino
class WriteThread extends Thread {
  boolean running;
  LM2 sketch;
  Serial port;
 
  WriteThread (LM2 sketch) {
    this.sketch = sketch;
    running = false;
  }
  
  void start () {
    running = true;
    super.start();
  }

  void run () {
    port = new Serial(sketch, Serial.list()[1], 115200); // connect to arduino
    while (true) {
      // write each color to the arduino
      for (int i = 0; i < 10; i++){
        println(colors[i]);
        port.write("p" + (char)i + "c" + (char)red(colors[i])
          + (char)green(colors[i]) + (char)blue(colors[i]));
      }
    }
  }
  
  void quit() {
    running = false;
    interrupt();
  }

}
