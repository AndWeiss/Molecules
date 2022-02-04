import papaya.*;
import java.util.Date;
import java.io.File;

import ddf.minim.analysis.*;
import ddf.minim.*;
import ddf.minim.ugens.*;
import ddf.minim.spi.*; // for AudioStream
import processing.pdf.*; //for pdf export




// for the sound processing

/*import ddf.minim.analysis.*;
import ddf.minim.*;
import papaya.*;
import ddf.minim.ugens.*;
import ddf.minim.spi.*; // for AudioStream
*/

  


//
int backy =0;
float strokewidth =1; 
//

int buffer = 1024;


int Ncores =512 ;
float globalcoresize = 20;
float sizeSpread = 0.9;
int Nelectrons = 0;
int elecSize =1;
float elecdistance = 2;
//
float[][] location = new float[Ncores][2];  // location of shape
float[][] velocity = new float[Ncores][2];  // velocity of shape
float[][] gravity  = new float[Ncores][2];   // gravity acts at the shape's acceleration
float[][] nextgravity  = new float[Ncores][2];   // gravity for the next timestep
float[][] localgravity =  new float[Ncores][2]; // actually its the acceleration
//
float[][][] electron = new float[Ncores][Nelectrons][2];  // location of shape
// helping matrices
float[][][] myPvec = new float[3][Ncores][2];
//
float[][] corecolor = new float[Ncores][3];
float[] coremass = new float[Ncores];
float[] coresize = new float[Ncores];
float[] coredensity = new float[Ncores];
float[] freqValue = new float[5];
int[] freqboarders = {1,6,12,24,116,buffer}; // must be size(freqValue)+1
// start frequency of 40 Hz, 200 Hz, 500 Hz, 1000 Hz, 5000 Hz, 5000 Hz and buffer

float[][][] electroncolor = new float[Ncores][Nelectrons][3];  // location of shape
// parameters for flying behaviour ----------------------- 
float[] drag = {0.005,0.005};
float[] center= new float[2]; 
float damping = 0.95;
float magnusfak = 50;
float whitefak = 1;
float linethickness = 1;
boolean gravflag = false;
float veloFac = 100;

float alpha =0;
float t =0;
float dt = 0.01;
float velocityElec = 1;
// corners geometry ------------------------------
float[] corner_rub = new float[3];
float[] corner_lub = new float[3];
float[] corner_rlb = new float[3];
float[] corner_llb = new float[3];
//
float[] corner_ruf = new float[3];
float[] corner_luf = new float[3];
float[] corner_rlf = new float[3];
float[] corner_llf = new float[3];

// helping variables -----------------------------
int connection = 0;
float R, G, B;
float sign = 1;
boolean flag = true;
int randstart ;
int Nmoving = 1;
boolean fillin = false;

// variables for the sound processing -----------------------------


//soundflowers check out
Minim minim;
//AudioPlayer player;
FFT fft ;
AudioOutput out;
AudioInput in;
WindowFunction newWindow = FFT.NONE;



void setup() 
{
  //size(1600, 800,FX2D); //FX2D P2D
  fullScreen(FX2D, SPAN);
  background(backy);
  center[0] = width/2;
  center[1]=height/2;
  
  // for the Sound processing ------
  
  // we pass this to Minim so that it can load files from the data directory
  minim = new Minim(this);                                               
  // construct a LiveInput by giving it an InputStream from minim.                                                  
  in = minim.getLineIn(); //new LiveInput( inputStream );
  fft = new FFT( buffer, in.sampleRate() );
  println(in.sampleRate()); 
  // -------------------------------
  

  
  for(int i =0;i<Ncores;i++){
      coresize[i]= globalcoresize - random(globalcoresize*sizeSpread) ;
      //
      /*
      templocx = globalcoresize + itemp*globalcoresize*2;
      if( templocx > (width-coresize[i])){
        itemp = 0;
        templocy +=globalcoresize*2;
      }
      templocx = globalcoresize + itemp*globalcoresize*2;
      itemp += 1;
      */
      //println(templocx, "  ", templocy);
      
      location[i][0] = random(width); // randomGaussian()+center[0];
      location[i][1] = random(height); //randomGaussian()+center[1];
      //
      velocity[i][0] = 0;
      velocity[i][1] = 0;
      
    
      gravity[i][0] = 0;
      gravity[i][1] = 0;
       
      localgravity[i][0] = 0;
      localgravity[i][1] = 0;
      
      corecolor[i][0] = 10+ random(245);
      corecolor[i][1] = 10+ random(245);
      corecolor[i][2] = 10+ random(245);
      
      //println(velocity[i][0]);
      //println(velocity[i][1]);
      
    
    for (int j=0;j<Nelectrons;j++){
      electroncolor[i][j][0] = random(255);
      electroncolor[i][j][1] = random(255);
      electroncolor[i][j][2] = random(255);
    }
    
    coredensity[i] = 1;
    coremass[i]=coredensity[i]*pow(coresize[i],3)*PI;
  }
  // an extra treatment for the sun
  /*
  coresize[0]=50;
  coredensity[0] = 0.0001;
  coremass[0]=coredensity[0]*pow(coresize[0],3)*PI;
  location[0] = center; 
  velocity[0][0] = width/12;
  velocity[0][1] = 0 ;
  velocity[0][2] = 0;
  corecolor[0][0] =  255;
  corecolor[0][1] =  255;
  corecolor[0][2] =  255;
  */
 
  //drawspace(corner_rub,corner_lub, corner_rlb, corner_llb, corner_ruf,corner_luf, corner_rlf, corner_llf);
}


  
void keyPressed() {
  println(key);
  switch (key) {
    case 'D': 
      // more damping in the collisions
      damping -= 0.001; 
      println("D = + collision damping");
      println(damping);
      break;
    case 'S': 
      // less damping in the collisions
      damping += 0.001; 
      println("S= - collision damping");
      println(damping);
      break;
    case 'E':
      // more "air" drag
      drag[0] +=  0.005; 
      drag[1] +=  0.005;
      println(drag[0]);
      break;
    case 'W': 
      // less "air" drag
      drag[0] -= 0.005; 
      drag[1] -= 0.005;
      println(drag[0]);
      break;
    case 'F':
      fillin = !fillin;
      println(fillin);
      break;
    case 'B':
      globalcoresize *=1.1;
      coresize = Mat.multiply(coresize,1.1);
      println(globalcoresize);
      break;
    case 'V':
      globalcoresize *=0.9;
      coresize = Mat.multiply(coresize,0.9);
      println(globalcoresize);
      break;
    case 'C':
      sizeSpread +=0.01;
      setCoreSize();
      println(sizeSpread);
      break;
    case 'X':
      sizeSpread +=-0.01;
      setCoreSize();
      println(sizeSpread);
      break;
    case 'M':
      magnusfak += 10;
      println('M');
      println(magnusfak);
      break;
    case 'N':
      magnusfak += -10;
      println('N');
      println(magnusfak);
      break;
    case 'G':
      gravflag = !gravflag;
    case '-':
      linethickness += 0.2;
      println("linethickness:");
      println(linethickness);
      break;
    case '.':
      linethickness -= 0.2;
      linethickness = max(0,linethickness);
      break;
    case 'P':
      whitefak += 0.2;
      println("whitefak");
      println(whitefak);
      break;
    case 'O':
      whitefak -= 0.2;
      break;
    case 'J':
      veloFac +=10;
      break;
    case 'H':
      veloFac -=10;
      break;  
    }
  }
  
  
void draw() {
   //background(backy,10);
   fill(0,6);
   noStroke();
   rect(0,0,width,height);
   // Soud processing 
   newWindow = FFT.HANN;
   fft.window( newWindow );
   fft.forward( in.mix ); //fourier-Transformation
   //running through all frequencies
   for(int j =0;j<freqValue.length;j++){
     freqValue[j] =0;
     for(int i = freqboarders[j];i<freqboarders[j+1];i++){
       freqValue[j] += fft.getBand(i);
     }
     //freqValue[j]/=freqboarders[j+1];
   }
   for(int n =0;n<Ncores;n++){
      // for the Sound processing ------
      // set the size and velocity depending on the frequency spectrum
      //freqValue[0] = pow(log(fft.getBand(n)+1),0.3);
      //freqValue[1] = log(fft.getBand(n+1)+1);
      if(n<5){
        velocity[n][0] = random(-1,1)*freqValue[n]*veloFac;
        velocity[n][1] = random(-1,1)*freqValue[n]*veloFac;
        //coresize[n] = (freqValue[0]+freqValue[n])*2+globalcoresize;
        coredensity[n] = (freqValue[0]+freqValue[n])*2000;
      }
      /*
      stroke(255); 
      line(n*width/Ncores,0,n*width/Ncores,log(fft.getBand(2*n))*height);
      //line((n*width/Ncores),0,(n*width/Ncores),height);
      */
      //println("nach sound: ");
      //println(velocity[n][0]); //<>//
      //println(velocity[n][1]);
      
      // -------------------------------
      
      // check collisions with the wall
      //wallcollision(n);
       
      // symmetry boundaries
      symmetryBoundary(n);
     
      // check collisions:
      collision(n,gravflag);
      
           
      //*/
      //println(location[2]);
      
      // Display the Molecules at the location vector
      
      //stroke(255);
      //strokeWeight(1); //strichbreite
      if(fillin){
        fill(Mat.norm2(velocity[n])*whitefak);
        noStroke();
      }
      else{
        noFill();
        strokeWeight(linethickness);
        stroke(Mat.norm2(velocity[n])*whitefak);
      }
      //println("Norm: ");
      //println(Mat.norm2(velocity[n]));
      
      
      ellipse(location[n][0], location[n][1],coresize[n]*2,coresize[n]*2);
      /*
      noFill();
      box(200);
      */
      //println("Cernel:------------------------");
      //println(location[0],location[1],location[2]);
      //println("Electrons:------------------------");
      //
      /*
      stroke(150);
      //connection = floor(random(Ncores));
      //line(location[n][0],location[n][1],location[n][2],location[connection][0],location[connection][1],location[connection][2]);
      
      if (n==(Ncores-1)){
        line(location[n][0],location[n][1],location[n][2],location[0][0],location[0][1],location[0][2]);
      }
      else{
        line(location[n][0],location[n][1],location[n][2],location[n+1][0],location[n+1][1],location[n+1][2]);
      }
      */
      
      
      //println(gravity[n]);
      for(int i =0;i<Nelectrons;i++){
        alpha=parseFloat(i)/Nelectrons*PI;
        electron[n][i][0] = location[n][0] + sin(t) + (coresize[n]+elecdistance);
        electron[n][i][1] = location[n][1] + cos(t) + (coresize[n]+elecdistance);
        noStroke();
        //R = i*255/Nelectrons;
        //G = 255-i*20; //255-n*255/ebenen; //100;
        //B = 255- i*255/Nelectrons;
        fill(electroncolor[n][i][0],electroncolor[n][i][1],electroncolor[n][i][2]);
        //fill(255);
        ellipse(electron[n][i][0],electron[n][i][1],elecSize,elecSize);
        
        //translate(500,250, 0);
        //ellipse(500,250,10,10);
        //stroke(R,G,B);
        //strokeWeight(1);
        //line(electron[n][i][0],electron[n][i][1],electron[n][i][2],location[n][0],location[n][1],location[n][2]);
        
        
        //println(electron[n][i][0],electron[n][i][1],electron[n][i][2]);
      }
      
     
      
      velocity[n][0] += (gravity[n][0])/2*dt -drag[0]*velocity[n][0]*dt ;
      velocity[n][1] += (gravity[n][1])/2*dt -drag[1]*velocity[n][1]*dt;
      //
      location[n][0] +=  velocity[n][0]*dt;
      location[n][1] +=  velocity[n][1]*dt;
      
      gravity[n][0] *= pow(dt,0.1) ;
      gravity[n][1] *= pow(dt,0.1) ;
      
      //gravity[n][0] = 0;
      //gravity[n][1] = 0;
   }
   t +=dt;
    //println(t);
  }
  void mousePressed() {
    noLoop();
  }
  void mouseReleased() {
    loop();
  }
/*
class HLine { 
  float ypos, velocity; 
  HLine (float y, float s) {  
    ypos = y; 
    velocity = s; 
  } 
  void update() { 
    ypos += velocity; 
    if (ypos > height) { 
      ypos = 0; 
    } 
    line(0, ypos, width, ypos); 
  } 
} */
