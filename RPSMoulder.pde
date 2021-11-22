class RPSMoulder extends Moulder{
  int RPS;
  float weightTo,weightFro;
  RPSMoulder(int rps,float _weightTo,float _weightFro){
    super();
    if (rps < 0 || rps > 2){throw new IllegalArgumentException("0,1,2 are the valid rps values.");}
    RPS = rps;
    weightTo = _weightTo;
    weightFro = _weightFro;
  }
  
  void sense(){
    //calculate pixel indices for sensors
    int leftS  = pixelIndex(PVector.add(pos,PVector.mult(PVector.fromAngle(heading + sensorAngle),sensorDistance)));
    int midS   = pixelIndex(PVector.add(pos,PVector.mult(PVector.fromAngle(heading),sensorDistance)));
    int rightS = pixelIndex(PVector.add(pos,PVector.mult(PVector.fromAngle(heading - sensorAngle),sensorDistance)));
    switch(RPS){
      case 0://red
        senseL = round(red(pixels[leftS])    +  weightTo*green(pixels[leftS])  -  weightFro*blue(pixels[leftS]));
        senseM = round(red(pixels[midS])     +  weightTo*green(pixels[midS])   -  weightFro*blue(pixels[midS]));
        senseR = round(red(pixels[rightS])   +  weightTo*green(pixels[rightS]) -  weightFro*blue(pixels[rightS]));
        break;
      case 1://green
        senseL = round(green(pixels[leftS])  +  weightTo*blue(pixels[leftS])   -  weightFro*red(pixels[leftS]));
        senseM = round(green(pixels[midS])   +  weightTo*blue(pixels[midS])    -  weightFro*red(pixels[midS]));
        senseR = round(green(pixels[rightS]) +  weightTo*blue(pixels[rightS])  -  weightFro*red(pixels[rightS]));
        break;
      case 2://blue
        senseL = round(blue(pixels[leftS])   +  weightTo*red(pixels[leftS])    -  weightFro*green(pixels[leftS]));
        senseM = round(blue(pixels[midS])    +  weightTo*red(pixels[midS])     -  weightFro*green(pixels[midS]));
        senseR = round(blue(pixels[rightS])  +  weightTo*red(pixels[rightS])   -  weightFro*green(pixels[rightS]));
        break;
    }
  }
  
  void deposit(){
    int index = pixelIndex(pos);
    int r = round(red(pixels[index]));
    int g = round(green(pixels[index]));
    int b = round(blue(pixels[index]));
    
    switch(RPS){
      case 0://red
        r += depositRate;
        break;
      case 1://green
        g += depositRate;
        break;
      case 2://blue
        b += depositRate;
        break;
    }
    
    if(r>255){r = 255;}
    if(g>255){g = 255;}
    if(b>255){b = 255;}
    pixels[index] = color(r,g,b);
  }
  
}
