Moulder[] physarum;
final int phyN = 1000000;
final float TOWEIGHT =  0.75;//red follows green follows blue follows red
final float FROWEIGHT = 0.5;//red avoids blue avoids green avoids red
String baseName;

Moulder randomMoulder(){
  switch(floor(random(3))){
      case 0:
        return new RedMoulder();
      case 1:
        return new GreenMoulder();
      case 2:
        return new BlueMoulder();
      default:
        return null;
    }
}

RPSMoulder randomRPSMoulder(){
  return new RPSMoulder(floor(random(3)),TOWEIGHT,FROWEIGHT);
}



float circularNoise(float t, float nscale,float seedx,float seedy){
  return noise(seedx + nscale*cos(t),seedy + nscale*sin(t));
}

float toroidalNoise(float t1,float t2,float r1, float r2,float s1,float s2, float s3){
  float x = (r1 + r2*cos(t2))*cos(t1);
  float y = (r1 + r2*cos(t2))*sin(t1);
  float z = r2*sin(t2);
  return noise(x + s1,y + s2,z + s3);
}

void colonyMould(int colNum,float radius){
  baseName = "Colony" + colNum;
  physarum = new Moulder[phyN];
  for (int i=0;i<physarum.length;i++){
    PVector c = new PVector((3*i%colNum) * width/colNum,((2*i+3)%colNum) * height/colNum);
    physarum[i] = randomRPSMoulder();
    float r = random(radius);
    physarum[i].pos = PVector.add(c,PVector.mult(PVector.fromAngle((i*TAU/physarum.length)),r));
  }
}

void cornerMould(float radius){
  baseName = "Corner";
  physarum = new Moulder[phyN];
  for (int i=0;i<physarum.length;i++){
    physarum[i] = randomRPSMoulder();
    float r = radius + sqrt(radius)*noise(i*0.01);
    physarum[i].pos = PVector.mult(PVector.fromAngle((i*TAU/physarum.length)),r);
  }
}
void centerMould(float radius,float angleOffset){
  baseName = "Center" + round(180*angleOffset/PI);
  PVector c = new PVector(width/2,height/2);
  physarum = new Moulder[phyN];
  for (int i=0;i<physarum.length;i++){
    physarum[i] = randomRPSMoulder();
    float r = radius + 0.25*radius*randomGaussian();
    physarum[i].pos = PVector.add(c,PVector.mult(PVector.fromAngle((i*TAU/physarum.length)),r));
    physarum[i].heading = PVector.sub(c,physarum[i].pos).heading() + angleOffset;// + 0.25*randomGaussian();
  }
}
void randomMould(){
  baseName = "Random";
  physarum = new Moulder[phyN];
  for (int i=0;i<physarum.length;i++){
    physarum[i] = randomRPSMoulder();
    physarum[i].pos = new PVector(random(width),random(height));
  }
}

void sineMould(){
  baseName = "Sine";
  physarum = new Moulder[phyN];
  for (int i=0;i<physarum.length;i++){
    physarum[i] = randomRPSMoulder();
    physarum[i].pos = new PVector(i,height/2 + height*0.25*sin(TAU*i/width));
    physarum[i].heading = (new PVector(1,cos(TAU*i/width)).heading());
  }
}

void noiseMould(float xscale,float yscale){
  baseName = "Noise";
  physarum = new Moulder[phyN];
  float XSEED = random(39562305);
  float YSEED = random(39562305);
  float ZSEED = random(39562305);
  int p = 0;
  while (true){
    for (int j = 0;j<height;j++){
      for (int i = 0;i<width;i++){
        if(random(0.5f) > toroidalNoise(TAU*i/(float)width,TAU*j/(float)height,xscale,yscale,XSEED,YSEED,ZSEED)){//if good roll
          //add mould
          physarum[p] = randomMoulder();
          physarum[p].pos = new PVector(i,j);
          p++;
        }
        if(p == phyN){return;}
      }
    }
  }
  
  
}


void setup(){
  fullScreen();
  //size(720,720);
  
  //sineMould();
  centerMould(height/4f,PI/2);
  //colonyMould(4,20);
  //noiseMould(15f,15f);
  
  background(0);
  noStroke();
}
void draw(){
  filter(BLUR);
  
  fill(0,15);
  rect(-1,-1,width+2,height+2);
  
  loadPixels();
  for(Moulder spore:physarum){
    spore.stepTime();
  }
  updatePixels();
  
  String fullName = "frames/Physarum" + phyN + baseName + "To" + TOWEIGHT + "Fro" + FROWEIGHT + "Sense" + round(physarum[0].sensorAngle/DEGREES) + "Turn" + round(physarum[0].turnAngle/DEGREES);
  saveFrame(fullName + "/physarum#########.png");
  
}
