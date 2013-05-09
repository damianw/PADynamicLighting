#include <PololuLedStrip.h>

// Create an ledStrip object on pin 12.
PololuLedStrip<12> ledStrip;

// Create a buffer for holding 60 colors.  Takes 180 bytes.
#define LED_COUNT 60
rgb_color colors[LED_COUNT];
int pos = -1;
rgb_color color = (rgb_color){255, 255, 255};

void setup()
{
  Serial.begin(115200);
}

void loop()
{
  if ( Serial.available()) {
    char inchar = Serial.read();
    if (inchar == 'p') {
      while(!Serial.available());
      pos = Serial.read();
    }
    else if (inchar == 'c') {
      while(!Serial.available());
      byte red = Serial.read();
      while(!Serial.available());
      byte green = Serial.read();
      while(!Serial.available());
      byte blue = Serial.read();
        color = (rgb_color){green, blue, red};
      if (pos == -1) {
        for (int i = 0; i < 10; i++) {
          colors[i] = color;
        }
      } else {
        colors[9-pos] = color;
      }
      ledStrip.write(colors, LED_COUNT);  
    }

  }

}
