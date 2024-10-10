# Molecules

It calculates the movement of particles (realized as ellipses), based on an audio input. 

It is programmed with processing version 3+ https://processing.org/download/
Additionally the papaya library, for matrix multiplication must be installed http://adilapapaya.com/papayastatistics/
also the minim library is mandatory.

The Molecules move towards a direction that is calculated by the collision of the molecules to each other. 

Some (physical) parameters change with the sound input. 

The sound input transformed to a fourier space, which is separated into five intervalls. 
Get_sound_numbers will calculate the mean (f_means) and the maximum (f_maxs) values of the magnitude in these intervalls. 
Addidinaly it calculates the magnitude difference to the timely earlyer mean value, and the stereo intensity by comparing left and right audio input.
The calculated sound number are scaled with factors (factors), which can be adjusted with the keyboard.

//     0: , 1: size , 2: damping, 3: magnusfak, 4: drag 

// initial values are
'float[] factors     = {0.5 ,1. ,0.04 ,10. ,0.05 }; '


* **case 'x':**

      // low frequency factor +
      
     factors[0] += 0.01;
       
* **case'y':**

     // low frequency factor -
     
     factors[0] -= 0.01;

* **case 's':**

      // low mids frequency factor +
      
      factors[1] += 0.01;

* **case 'a':**

      // low mids frequency factor -
      
      factors[1] -= 0.01;
       
* **case 'w':**

      // mids frequency factor +
      
      factors[2] += 0.01;
       
* **case 'q':**

      // mids frequency factor -
      
      factors[2] -= 0.01;
       
* **case 'd':**
      // high mids frequency factor +
      factors[3] += 0.01;
       
* **case 'f':**

  // high mids frequency factor -
  
  factors[3] -= 0.01;
   
* **case 'e':**

  // high frequency factor +
  
  factors[4] += 0.01;
   
* **case 'r':**

  // high frequency factor -
  
  factors[4] -= 0.01;
   
* **case 'ö':**

  // turn on the filling of the ellipses 
  
  fillin = !fillin;
  println(fillin);
   

* **case 't':**

  // increases the spread of the size of the ellipses 
  
  sizeSpread +=0.01;
  setCoreSize();
  println(sizeSpread);
   
* **case 'z':**

  // decreases the spread of the size of the ellipses is not working in the moment why?
  sizeSpread +=-0.01;
  setCoreSize();
  println(sizeSpread);
   
* **case 'g':**

  gravflag = !gravflag;
   
* **case '-':**

  linethickness += 0.2;
  println("linethickness:**");
  println(linethickness);
   
* **case '.':**

  linethickness -= 0.2;
  linethickness = max(0,linethickness);
   
* **case 'p':**

  whitefak += 0.2;
   
* **case 'o':**

  whitefak -= 0.2;
   
* **case 'v':**

  veloFac +=2;
   
* **case 'c':**

  veloFac -=2;
     
 * **case '2':**
 
  // overall scaling of all factors +
  
  superfac = 1.1;
  
  factors = Mat.multiply(factors,superfac);
   
 * **case '1':**
 
  // overall scaling of the factors -
  
  superfac = 0.9;
  
  factors = Mat.multiply(factors,superfac);
   
 * **case ' ':**
 
   // get the spheres back in the display area
   
   place_balls();
  
 * **case 'l':** 
 
   // turns on / off the logarithmic evaluation of the fft
   
   log_on = !log_on;
    



