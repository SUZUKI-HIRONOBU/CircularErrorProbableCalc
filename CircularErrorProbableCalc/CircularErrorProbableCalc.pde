// Circular Error Probable 
// One game will be finished when an outline of dot touches a squre.
// GPLv3
// Hironobu SUZUKI <hironobu dot suzuki at gmail dot com>
//
class ImpactPoint {
  float x;
  float y;
  ImpactPoint (float tx, float ty) {
    x=tx ;
    y=ty;
  }
  float ldist() {
    return dist(width/2, height/2, x, y);
  }
}
float cep=150;
float onmap=178; // onmap was calcurated constant previously.
float ceprate=onmap/cep;
float sum=0;
float round=0;
boolean train=true; // Make it false if you don't need to recalcurate ceprate and onmap.
float effect=30;

void setup() {
  size(900, 900);
  if ( train == false ) {
    background(0);
    fill(255);
    rectMode(CENTER);
    rect(width/2, height/2, 35*ceprate, 35*ceprate);
  }
}

int idx=0;
boolean hit=false;
ImpactPoint[] impactpoint  = new ImpactPoint[1000];
int traincount=0;
void draw() {
  if (train) {
    // recalcurate ceprate and onmap to fit screen
    background(255);
    textSize(64);
    fill(0);
    textAlign(CENTER);
    text("TRAIN NOW...", width/2, height/2);
    for (int i=0; i < impactpoint.length/100; i++) {
      float x = randomGaussian()*cep;
      float y = randomGaussian()*cep;
      impactpoint[traincount++] =new ImpactPoint(x+ width/2, y+height/2);
    }
    if (traincount < impactpoint.length) {
      return;
    }
    float distarray[] = new float[impactpoint.length];
    for (int i=0; i < impactpoint.length; i++) {
      distarray[i] = impactpoint[i].ldist();
    }
    float sorted_distarray[]=sort(distarray);
    onmap=sorted_distarray[sorted_distarray.length/2];
    ceprate=onmap/cep;
    println("ONMAP-CEPRATE: ", onmap, ceprate);
    train=false;
    background(0);
    fill(255);
    rectMode(CENTER);
    rect(width/2, height/2, 35*ceprate, 35*ceprate);
    return;
  }
  sum++; // Number of Total 
  if (hit == true ) {
    delay(2000);
    hit=false;
    background(0);
    fill(255);
    rectMode(CENTER);
    rect(width/2, height/2, effect*ceprate, effect*ceprate);
  }
  float x = randomGaussian()*cep;
  float y = randomGaussian()*cep;
  impactpoint[idx] =new ImpactPoint(x+ width/2, y+height/2);
  fill(255, 0, 0);
  ellipse(x + width/2, y+height/2, effect*ceprate, effect*ceprate);
  fill(255, 0, 0, 50);
  ellipse(x + width/2, y+height/2, 2*effect*ceprate, 2*effect*ceprate);
  idx++;
  if (dist(width/2, height/2, x + width/2, y+height/2) < (3*effect/2)*ceprate ) {
    textSize(32);
    fill(255);
    textAlign(CENTER);
    text(idx, width/2, 32);
    fill(200, 128, 128, 70);
    ellipse(width/2, height/2, onmap*2, onmap*2);
    idx=0;
    round++; // Number of Hit
    println("Rate(total): ", str(round((round/sum)*100)), "%"); 
    hit=true;
    return;
  }
}