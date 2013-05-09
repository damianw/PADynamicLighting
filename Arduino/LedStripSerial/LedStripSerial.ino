#include <PololuLedStrip.h>

// Create an ledStrip object on pin 12.
PololuLedStrip<12> ledStrip;

// Create a buffer for holding 60 colors.  Takes 180 bytes.
#define LED_COUNT 60
rgb_color colors[LED_COUNT];
int pos = -1; // variable for holding segment position
// color to be set
rgb_color color = (rgb_color){255, 255, 255};

void setup()
{
  Serial.begin(115200); // change to desired speed
}

void loop()
{
  if ( Serial.available()) {
    char inchar = Serial.read(); //read in the command
    switch(inchar) { // two commands available
      case 'p': // set the pos
        while(!Serial.available());
        pos = Serial.read();
        break;
      case 'c': // set the color of pos
        while(!Serial.available());
        byte red = Serial.read();
        while(!Serial.available());
        byte green = Serial.read();
        while(!Serial.available());
        byte blue = Serial.read();
        // GBR is used because the library is fucked
        color = (rgb_color){green, blue, red};
        if (pos == -1) { // -1 sets all the segments
          for (int i = 0; i < 10; i++) {
            colors[i] = color;
          }
        } else { // otherwise set them in reverse
          colors[9-pos] = color;
        }
        ledStrip.write(colors, LED_COUNT); // write the colors
        break;  
    }

  }

}
