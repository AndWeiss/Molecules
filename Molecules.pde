import processing.javafx.*; //<>//
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




int Ncores =512 ;
float globalcoresize = 50;
float sizeSpread = 0.7;
int Nelectrons = 0;
int elecSize =5;
float elecdistance = 1;
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
// is the coresize that will be adjusted by the sound numbers in draw
float[] coresize_var = new float[Ncores];
float[] coredensity = new float[Ncores];

float[][][] electroncolor = new float[Ncores][Nelectrons][3];  // location of shape
// parameters for flying behaviour ----------------------- 
float[] drag = {0.005,0.005};
float[] center= new float[2]; 
// damping factor in the collisions
float damping = 0.95;
float magnusfak = 100; // ToDo: try to control magnusfak by the mid frequencies
float whitefak = 1;
float linethickness = 1;
boolean gravflag = false;
float veloFac = 50;

// S = 1.0009993 bis 1.0069996 , m = 620, e = 2.44, 

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
boolean fillin = true;
float coresizefak;

// variables for the sound processing -----------------------------
//soundflowers check out
Minim minim;
//AudioPlayer player;
FFT fft ;
AudioOutput out;
AudioInput in;
WindowFunction newWindow = FFT.NONE;
//
int buffer          = 1024;
// the limits for the frequency intervalls
int[] limits        = {1, 6, 12, 24, 116, 512}; // must be freqValue.length + 1
float[] f_means     = {0. , 0. , 0. , 0. , 0.} ;
float[] f_means_old = new float[5];
int[] max_freq      = new int[5];
float[] f_maxs      = new float[5];
float f_diff        = 0 ;
// factors that can be controlled by the keyboard -----------
float[] factors     = {0.5 ,1. ,1. ,10. ,1. }; // Mat.constant(1.0,5);
// is assigned when button is pushed
float superfac      = 1 ; 
boolean log_on      = false;

void setup() 
{
  //size(1600, 800,P2D); //FX2D P2D
  //fullScreen(P2D,SPAN); //FX2D
  fullScreen(P2D);
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
      
      place_balls();
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
    case 'x':
      // low frequency factor +
     factors[0] += 0.01;
      break;
    case'y':
     // low frequency factor -
     factors[0] -= 0.01;
     break;
   case 's':
      // low mids frequency factor +
      factors[1] += 0.01;
      break;
    case 'a':
      // low mids frequency factor -
      factors[1] -= 0.01;
      break;
    case 'w':
      // mids frequency factor +
      factors[2] += 0.01;
      break;
    case 'q':
      // mids frequency factor -
      factors[2] -= 0.01;
      break;
    case 'd':
      // high mids frequency factor +
      factors[3] += 0.01;
      break;
    case 'f':
      // high mids frequency factor -
      factors[3] -= 0.01;
      break;
    case 'e':
      // high frequency factor +
      factors[4] += 0.01;
      break;
    case 'r':
      // high frequency factor -
      factors[4] -= 0.01;
      break;
    case 'ö':
      // turn on the filling of the ellipses 
      fillin = !fillin;
      println(fillin);
      break;
    
    case 't':
      // increases the spread of the size of the ellipses is not working in the moment why?
      sizeSpread +=0.01;
      setCoreSize();
      println(sizeSpread);
      break;
    case 'z':
      // decreases the spread of the size of the ellipses is not working in the moment why?
      sizeSpread +=-0.01;
      setCoreSize();
      println(sizeSpread);
      break;
    case 'g':
      gravflag = !gravflag;
      break;
    case '-':
      linethickness += 0.2;
      println("linethickness:");
      println(linethickness);
      break;
    case '.':
      linethickness -= 0.2;
      linethickness = max(0,linethickness);
      break;
    case 'p':
      whitefak += 0.2;
      println("whitefak");
      println(whitefak);
      break;
    case 'o':
      whitefak -= 0.2;
      break;
    case 'v':
      veloFac +=2;
      break;
    case 'c':
      veloFac -=2;
      break;  
     case '2':
      // overall scaling of all factors +
      superfac = 1.1;
      factors = Mat.multiply(factors,superfac);
      break;
     case '1':
      // overall scaling of the factors -
      superfac = 0.9;
      factors = Mat.multiply(factors,superfac);
      break;
     case ' ':
       // get the spheres back in the display area
       place_balls();
    }    
  }
  

  
float[] get_direction() {
  // returns a normalized vector in a random direction
  float[] dir = {random(-1,1), random(-1,1)};
  return Mat.divide(dir, Mat.norm2(dir)) ;
}



void draw() {
   //background(backy,10);
   fill(0,6);
   noStroke();
   rect(0,0,width,height);
   //get the sound numbers
   Get_sound_numbers();
   println("f_means");
   println(f_means);
   println("f_maxs");
   println(f_maxs); 
   // assign the sound numbers to the physical parameters  
   magnusfak = f_means[3];
   damping  = min(max(0.5,f_means[2]),1.2);
   drag[0]  = 0.2 - f_means[0];
   drag[1]  = 0.2 - f_maxs[0];
   coresizefak = min(max(f_maxs[1],0.5),2);
   for (int n = 0; n <5; n++){
     float[] dir = get_direction();
     velocity[n][0] = dir[0]*f_means[n]*veloFac;
     velocity[n][1] = dir[1]*f_means[n]*veloFac;
     
   }
   
   // loop through all cores
   for(int n =0;n<Ncores;n++){
      coresize_var[n] = coresize[n]*coresizefak;
      coremass[n] = coredensity[n]*pow(coresize_var[n],3)*PI; 

      // --------------------------------
      // check collisions with the wall
      wallcollision(n);
      // symmetry boundaries
      //symmetryBoundary(n);
      // check collisions of the spheres to each other
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
      
      
      ellipse(location[n][0], location[n][1],coresize_var[n],coresize_var[n]);
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
      t = (t+0.00001) % TWO_PI;
      for(int i =0;i<Nelectrons;i++){
        alpha=parseFloat(i)/Nelectrons*TWO_PI;
        electron[n][i][0] = location[n][0] + cos(alpha+ t) * (coresize_var[n] +elecdistance);
        electron[n][i][1] = location[n][1] + sin(alpha+ t) * (coresize_var[n]+elecdistance);
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
