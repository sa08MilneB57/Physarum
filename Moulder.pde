float DEGREES = PI/180f;

abstract class Moulder{
  final float sensorAngle = 15*DEGREES;
  final float sensorDistance = 5f;
  float speed;
  final int depositRate = 8;
  final float turnAngle = 15*DEGREES;
  int senseL,senseM,senseR;
  float heading;
  PVector pos;
  //a little bit of mould, moulding about
  Moulder(){
    pos = new PVector(random(width),random(height));
    heading = random(TAU);
    speed = 0.5f + random(1.5);
  }
  
  void stepTime(){
    sense();
    turn();
    move();
    deposit();
  }
  
  int pixelIndex(PVector p){return pixelIndex(p.x,p.y);}
  int pixelIndex(float x,float y){
    ////assumes periodic boundary
    if(x<0 || x>=width) {x = ((x%width)+width)%width;}
    if(y<0 || y>=height){y = ((y%height)+height)%height;}
    int X = floor(x);
    int Y = floor(y);
    return X + width*Y;
  }
  
  abstract void sense();
  
  void turn(){
    int maxSense = max(max(senseL,senseR),senseM);
    int minSense = min(min(senseL,senseR),senseM);
    if(senseM == maxSense){
      return;
    } else if (senseM==minSense){
      heading += turnAngle*randomGaussian();
    } else if (senseL == maxSense){
      heading += turnAngle;
    } else if (senseR == maxSense){
      heading -= turnAngle;
    }
    
    heading = (heading+TAU)%TAU;
  }
  void move(){
    PVector vel = PVector.mult(PVector.fromAngle(heading),speed);
    pos = PVector.add(pos,vel);
    if(pos.x<0 || pos.x>=width) {pos.x = ((pos.x%width)+width)%width;}
    if(pos.y<0 || pos.y>=height){pos.y = ((pos.y%height)+height)%height;}
  }
  abstract void deposit();
}

class BrightMoulder extends Moulder{
  
  void sense(){
    //calculate positions for sensors
    PVector leftS  = PVector.add(pos,PVector.mult(PVector.fromAngle(heading + sensorAngle),sensorDistance));
    PVector midS   = PVector.add(pos,PVector.mult(PVector.fromAngle(heading),sensorDistance));
    PVector rightS = PVector.add(pos,PVector.mult(PVector.fromAngle(heading - sensorAngle),sensorDistance));
    senseL = round(brightness(pixels[pixelIndex(leftS)]));
    senseM = round(brightness(pixels[pixelIndex(midS)]));
    senseR = round(brightness(pixels[pixelIndex(rightS)]));
  }
    void deposit(){
    int index = pixelIndex(pos);
    int b = round(brightness(pixels[index]));
    if(b>255){println("B was ",b);return;}
    pixels[index] = color(b+depositRate);
  }
}

class RedMoulder extends Moulder{
  
  void sense(){
    //calculate positions for sensors
    PVector leftS  = PVector.add(pos,PVector.mult(PVector.fromAngle(heading + sensorAngle),sensorDistance));
    PVector midS   = PVector.add(pos,PVector.mult(PVector.fromAngle(heading),sensorDistance));
    PVector rightS = PVector.add(pos,PVector.mult(PVector.fromAngle(heading - sensorAngle),sensorDistance));
    senseL = round(red(pixels[pixelIndex(leftS)]));
    senseM = round(red(pixels[pixelIndex(midS)]));
    senseR = round(red(pixels[pixelIndex(rightS)]));
  }
    void deposit(){
    int index = pixelIndex(pos);
    int r = round(red(pixels[index]));
    int g = round(green(pixels[index]));
    int b = round(blue(pixels[index]));
    if(r>255){println("R was ",r);return;}
    pixels[index] = color(r+depositRate,g,b);
  }
}
class GreenMoulder extends Moulder{
  
  void sense(){
    //calculate positions for sensors
    PVector leftS  = PVector.add(pos,PVector.mult(PVector.fromAngle(heading + sensorAngle),sensorDistance));
    PVector midS   = PVector.add(pos,PVector.mult(PVector.fromAngle(heading),sensorDistance));
    PVector rightS = PVector.add(pos,PVector.mult(PVector.fromAngle(heading - sensorAngle),sensorDistance));
    senseL = round(green(pixels[pixelIndex(leftS)]));
    senseM = round(green(pixels[pixelIndex(midS)]));
    senseR = round(green(pixels[pixelIndex(rightS)]));
  }
  void deposit(){
    int index = pixelIndex(pos);
    int r = round(red(pixels[index]));
    int g = round(green(pixels[index]));
    int b = round(blue(pixels[index]));
    if(g>255){println("G was ",g);return;}
    pixels[index] = color(r,g+depositRate,b);
  }
}
class BlueMoulder extends Moulder{
  
  void sense(){
    //calculate positions for sensors
    PVector leftS  = PVector.add(pos,PVector.mult(PVector.fromAngle(heading + sensorAngle),sensorDistance));
    PVector midS   = PVector.add(pos,PVector.mult(PVector.fromAngle(heading),sensorDistance));
    PVector rightS = PVector.add(pos,PVector.mult(PVector.fromAngle(heading - sensorAngle),sensorDistance));
    senseL = round(blue(pixels[pixelIndex(leftS)]));
    senseM = round(blue(pixels[pixelIndex(midS)]));
    senseR = round(blue(pixels[pixelIndex(rightS)]));
  }
    void deposit(){
    int index = pixelIndex(pos);
    int r = round(red(pixels[index]));
    int g = round(green(pixels[index]));
    int b = round(blue(pixels[index]));
    if(b>255){println("B was ",b);return;}
    pixels[index] = color(r,g,b+depositRate);
  }
}
