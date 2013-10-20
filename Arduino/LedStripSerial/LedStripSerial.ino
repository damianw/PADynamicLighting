#include <PololuLedStrip.h>

// Create an ledStrip object on pin 12.
PololuLedStrip<12> ledStrip;

// Create a buffer for holding 60 colors.  Takes 180 bytes.
#define LED_COUNT 60
#define PWR_OUT 8
rgb_color colors[LED_COUNT];
int oldpos = -1;
bool pwr_state;
rgb_color color = (rgb_color){255, 255, 255};

void setup()
{
  Serial.begin(115200);
  pinMode(PWR_OUT, OUTPUT);
  digitalWrite(PWR_OUT, HIGH);
  pwr_state = true;
}

void loop()
{
  if ( Serial.available()) {
    char inchar = Serial.read();
    if (inchar == 'p') {
      while(!Serial.available());
      oldpos = Serial.read();
    }
    else if (inchar == 'c') {
      while(!Serial.available());
      byte red = Serial.read();
      while(!Serial.available());
      byte green = Serial.read();
      while(!Serial.available());
      byte blue = Serial.read();
      color = (rgb_color){green, blue, red};
      if (oldpos == -1) {
        for (int i = 0; i < 10; i++) {
          colors[i] = color;
        }
      } else {
        colors[9-oldpos] = color;
      }
      ledStrip.write(colors, LED_COUNT);  
    }
    else if (inchar == 'p') {
      if (pwr_state) {
        digitalWrite(PWR_OUT, LOW);
        pwr_state = false;
      } else {
        digitalWrite(PWR_OUT, HIGH);
        pwr_state = true;
      }
    }
    else if (inchar == 'u') {
      digitalWrite(PWR_OUT, HIGH);
      pwr_state = true;
    }
    else if (inchar == 'd') {
      digitalWrite(PWR_OUT, LOW);
      pwr_state = false;
    }
  }
}
