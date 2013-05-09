#include <PololuLedStrip.h>

// Create an ledStrip object on pin 12.
PololuLedStrip<12> ledStrip;

// Create a buffer for holding 60 colors.  Takes 180 bytes.
#define LED_COUNT 60
rgb_color colors[LED_COUNT];
int oldpos = -1;
rgb_color color = (rgb_color){255, 255, 255};

void setup()
{
  Serial.begin(115200);
}

void loop()
{
  // Update the colors.
//  byte time = millis() >> 2;
//  for(byte i = 0; i < LED_COUNT; i++)
//  {
//    byte x = time - 8*i;
//    colors[i] = (rgb_color){ x, 255 - x, x };
//  }
  if ( Serial.available()) {
    char inchar = Serial.read();
    if (inchar == 'p') {
//      for (int i = 0; i < 10; i++){
//        while (!Serial.available()){};
//        byte red = Serial.read();
//        byte green = Serial.read();
//        byte blue = Serial.read();
//        if (inchar 
//        colors[i] = (rgb_color){green, blue, red};
//      }
      while(!Serial.available());
      oldpos = Serial.read();
//      int pos = Serial.read();
//      if (pos != oldpos && pos < 10 && pos >= 0) {
//        //colors[pos] = color;
//        //colors[oldpos] = (rgb_color){0, 0, 0};
//        oldpos = pos;
//      }
      
    }
    else if (inchar == 'c') {
//      while(!Serial.available());
//      int red = Serial.parseInt();
//      while(!Serial.available());
//      Serial.read();
//      while(!Serial.available());
//      int green = Serial.parseInt();
//      while(!Serial.available());
//      Serial.read();
//      while(!Serial.available());
//      int blue = Serial.parseInt();
      while(!Serial.available());
      byte red = Serial.read();
      while(!Serial.available());
      byte green = Serial.read();
      while(!Serial.available());
      byte blue = Serial.read();
      //if (red != 'p' && red != 'c' && green != 'p' && green != 'c' && blue != 'p' && blue != 'c') {
        color = (rgb_color){green, blue, red};
        if (oldpos == -1) {
          for (int i = 0; i < 10; i++) {
            colors[i] = color;
          }
        } else {
          colors[9-oldpos] = color;
        }
      //}
      ledStrip.write(colors, LED_COUNT);  
    }
      
  }
  // Write the colors to the LED strip.
  //ledStrip.write(colors, LED_COUNT);  
  
  //delay(10);
}
