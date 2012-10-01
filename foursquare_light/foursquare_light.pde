
// values for dimming the LED 
const byte dim_curve[] = {
    0,   1,   1,   2,   2,   2,   2,   2,   2,   3,   3,   3,   3,   3,   3,   3,
    3,   3,   3,   3,   3,   3,   3,   4,   4,   4,   4,   4,   4,   4,   4,   4,
    4,   4,   4,   5,   5,   5,   5,   5,   5,   5,   5,   5,   5,   6,   6,   6,
    6,   6,   6,   6,   6,   7,   7,   7,   7,   7,   7,   7,   8,   8,   8,   8,
    8,   8,   9,   9,   9,   9,   9,   9,   10,  10,  10,  10,  10,  11,  11,  11,
    11,  11,  12,  12,  12,  12,  12,  13,  13,  13,  13,  14,  14,  14,  14,  15,
    15,  15,  16,  16,  16,  16,  17,  17,  17,  18,  18,  18,  19,  19,  19,  20,
    20,  20,  21,  21,  22,  22,  22,  23,  23,  24,  24,  25,  25,  25,  26,  26,
    27,  27,  28,  28,  29,  29,  30,  30,  31,  32,  32,  33,  33,  34,  35,  35,
    36,  36,  37,  38,  38,  39,  40,  40,  41,  42,  43,  43,  44,  45,  46,  47,
    48,  48,  49,  50,  51,  52,  53,  54,  55,  56,  57,  58,  59,  60,  61,  62,
    63,  64,  65,  66,  68,  69,  70,  71,  73,  74,  75,  76,  78,  79,  81,  82,
    83,  85,  86,  88,  90,  91,  93,  94,  96,  98,  99,  101, 103, 105, 107, 109,
    110, 112, 114, 116, 118, 121, 123, 125, 127, 129, 132, 134, 136, 139, 141, 144,
    146, 149, 151, 154, 157, 159, 162, 165, 168, 171, 174, 177, 180, 183, 186, 190,
    193, 196, 200, 203, 207, 211, 214, 218, 222, 226, 230, 234, 238, 242, 248, 255,
};

int activityLevelTarget = 0;
float activityLevelScaled = 0.0;
int activityUp = 1;

int pinRed = 9;
int pinGreen = 10;
int pinBlue = 11;

int rgbCurrent[3];
int hsvCurrent[3];

int valRCurrent = 0;
int valGCurrent = 0;
int valBCurrent = 0;

int valRTarget = 0;
int valGTarget = 0;
int valBTarget = 0;

int fadeSpeed = 5;

int timeStart = 0;
int timeIncrement = 0;
int timeThreshold = 2000;

int pulseStart = 0;
int pulseDuration = 2000;
boolean pulseUp = true;
float pulseVal = 0.0;
float pulseSpeed = 0.2;
float pulseR = 251;
float pulseG = 122;
float pulseB = 0;

void setup() {

  pinMode(pinRed, OUTPUT);
  pinMode(pinGreen, OUTPUT);
  pinMode(pinBlue, OUTPUT);
  
  analogWrite(pinRed, 0);
  analogWrite(pinGreen, 0);
  analogWrite(pinBlue, 0);
  
  Serial.begin(9600);
}

void pulseDoAsync(int hueVal, int satVal, int brtVal) {
    // start
    if (pulseStart == 0) {
      pulseStart = millis();
    }
    
    // check duration
    if (millis() - pulseStart > pulseDuration) {
      
      // stop pulse, return normal
      pulseStart = 0;
    } else {
      
      // do pulse
      if (pulseUp) { 
       pulseVal += pulseSpeed;
       if (pulseVal > 1.0) {
         pulseVal = 1.0;
         pulseUp = false;
       }
      } else {
       pulseVal -= pulseSpeed;
       if (pulseVal < 0) {
         pulseVal = 0;
         pulseUp = true;
       }
      }
      
      // light lights
      analogWrite(pinRed, pulseR * pulseVal);
      analogWrite(pinGreen, pulseG * pulseVal);
      analogWrite(pinBlue, pulseB * pulseVal);
    }
}

void pulseDo(int hueVal, int satVal, int brtVal) {
    int rgbPulseHigh[3];
    int rgbPulseMed[3];
    int rgbPulseLow[3];
    
    getRGB(hueVal, satVal, brtVal, rgbPulseHigh);
    getRGB(hueVal, satVal, brtVal-25, rgbPulseMed);
    getRGB(hueVal, satVal, brtVal-50, rgbPulseLow);
    
    analogWrite(pinRed, rgbPulseLow[0]);
    analogWrite(pinGreen, rgbPulseLow[1]);
    analogWrite(pinBlue, rgbPulseLow[2]);
  
    delay(100);
    
    analogWrite(pinRed, rgbPulseMed[0]);
    analogWrite(pinGreen, rgbPulseMed[1]);
    analogWrite(pinBlue, rgbPulseMed[2]);
  
    delay(100);
    
    analogWrite(pinRed, rgbPulseHigh[0]);
    analogWrite(pinGreen, rgbPulseHigh[1]);
    analogWrite(pinBlue, rgbPulseHigh[2]);
    
    delay(100);
    
    analogWrite(pinRed, rgbPulseMed[0]);
    analogWrite(pinGreen, rgbPulseMed[1]);
    analogWrite(pinBlue, rgbPulseMed[2]);
  
    delay(100);    
    
    analogWrite(pinRed, rgbPulseLow[0]);
    analogWrite(pinGreen, rgbPulseLow[1]);
    analogWrite(pinBlue, rgbPulseLow[2]);
  
    delay(100);
    
    analogWrite(pinRed, rgbPulseMed[0]);
    analogWrite(pinGreen, rgbPulseMed[1]);
    analogWrite(pinBlue, rgbPulseMed[2]);
  
    delay(100);
  
    analogWrite(pinRed, rgbPulseHigh[0]);
    analogWrite(pinGreen, rgbPulseHigh[1]);
    analogWrite(pinBlue, rgbPulseHigh[2]);
    
    delay(100);
    
    analogWrite(pinRed, rgbPulseMed[0]);
    analogWrite(pinGreen, rgbPulseMed[1]);
    analogWrite(pinBlue, rgbPulseMed[2]);
  
    delay(100);
    
    analogWrite(pinRed, rgbPulseLow[0]);
    analogWrite(pinGreen, rgbPulseLow[1]);
    analogWrite(pinBlue, rgbPulseLow[2]);
   
    delay(100);
   
    // revert to activity value
    getRGB(hueVal, satVal, brtVal, rgbCurrent);
    
    analogWrite(pinRed, rgbCurrent[0]);
    analogWrite(pinGreen, rgbCurrent[1]);
    analogWrite(pinBlue, rgbCurrent[2]);
}


void getRGB(int hue, int sat, int val, int colors[3]) { 
  /* convert hue, saturation and brightness ( HSB/HSV ) to RGB
     The dim_curve is used only on brightness/value and on saturation (inverted).
     This looks the most natural.      
  */

  val = dim_curve[val];
  sat = 255-dim_curve[255-sat];

  int r;
  int g;
  int b;
  int base;

  if (sat == 0) { // Acromatic color (gray). Hue doesn't mind.
    colors[0] = val;
    colors[1] = val;
    colors[2] = val;
  } else  { 

    base = ((255 - sat) * val)>>8;

    switch(hue/60) {
    case 0:
        r = val;
        g = (((val-base)*hue)/60)+base;
        b = base;
    break;

    case 1:
        r = (((val-base)*(60-(hue%60)))/60)+base;
        g = val;
        b = base;
    break;

    case 2:
        r = base;
        g = val;
        b = (((val-base)*(hue%60))/60)+base;
    break;

    case 3:
        r = base;
        g = (((val-base)*(60-(hue%60)))/60)+base;
        b = val;
    break;

    case 4:
        r = (((val-base)*(hue%60))/60)+base;
        g = base;
        b = val;
    break;

    case 5:
        r = val;
        g = base;
        b = (((val-base)*(60-(hue%60)))/60)+base;
    break;
    }

    colors[0] = r;
    colors[1] = g;
    colors[2] = b;
  }

}

int& fadeVal(int& current, int& target) {

  if (target != current) { 
    if (current < target) {
      // fade up
      current += fadeSpeed;
      if (current > target) {
        current = target;
      }
    } else
    { 
      // fade down
      current -= fadeSpeed;
      if (current < target) {
        current = target;
      }
    }
  }
  return target;
}

void loop() {
  byte cmd;
  byte hueVal;
  byte satVal;
  byte brtVal;

  // default start time
  if (timeStart == 0) {
    timeStart = millis();
  }
  
  // test algorithm to jump hue levels
  /*
  if (millis() - timeStart > timeThreshold) {
      timeIncrement += 1;
      timeStart = millis();
      
      if (timeIncrement > 2) {
        timeIncrement = 0;
        timeStart = millis();
        
        // test pulse
        pulseDo = true;
      }
  }
  
  // this hue stuff is used for testing
  activityLevelTarget = 50 * (timeIncrement+2);
  activityLevelScaled = (float)activityLevelTarget/255;
  h2rgb(activityLevelScaled, valRTarget, valGTarget, valBTarget);

  // fade rgb  
  fadeVal(valRCurrent, valRTarget);
  fadeVal(valGCurrent, valGTarget);
  fadeVal(valBCurrent, valBTarget);
  */
  
  // read the sensor (with args):
  if( Serial.available() == 4 ) {  // command length is 4 bytes
   // command (activity or pulse)
   cmd = Serial.read();
   // hue
   hueVal = Serial.read();
   // saturation
   satVal = Serial.read();   
   // brightness
   brtVal = Serial.read();

  }
  
  switch (cmd) {
      case 'p': 
        // perform a pulse
        // TODO: Fix pulseDo to pulse the HSB value then return to the current activity level color    
        pulseDo(345, satVal, brtVal);
        
        // debug logging
        Serial.print("Set Pulse: [HSB ");
        Serial.print(hueVal, DEC);
        Serial.print(",");
        Serial.print(satVal, DEC);
        Serial.print(",");
        Serial.print(brtVal, DEC);
        Serial.println("]");
        
        break;

      case 'a':
        // set activity value
        getRGB(hueVal, satVal, brtVal, rgbCurrent);
        
        analogWrite(pinRed, rgbCurrent[0]);
        analogWrite(pinGreen, rgbCurrent[1]);
        analogWrite(pinBlue, rgbCurrent[2]);
        
        // debug logging
        Serial.print("Set Activity Level: [HSB ");
        Serial.print(hueVal, DEC);
        Serial.print(",");
        Serial.print(satVal, DEC);
        Serial.print(",");
        Serial.print(brtVal, DEC);
        Serial.print("] => [RGB ");
        Serial.print(rgbCurrent[0]);
        Serial.print(",");
        Serial.print(rgbCurrent[1]);
        Serial.print(",");
        Serial.print(rgbCurrent[2]);
        Serial.println("]");
        
        break;
  } 

}
// End Loop
