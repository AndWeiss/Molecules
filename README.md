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


* **case 'x':**
      // low frequency factor +
     factors[0] += 0.01;
      break;
* **case'y':**
     // low frequency factor -
     factors[0] -= 0.01;
     break;
* **case 's':**
      // low mids frequency factor +
      factors[1] += 0.01;
      break;
* **case 'a':**
      // low mids frequency factor -
      factors[1] -= 0.01;
      break;
* **case 'w':**
      // mids frequency factor +
      factors[2] += 0.01;
      break;
* **case 'q':**
      // mids frequency factor -
      factors[2] -= 0.01;
      break;
* **case 'd':**
      // high mids frequency factor +
      factors[3] += 0.01;
      break;
    * **case 'f':**
      // high mids frequency factor -
      factors[3] -= 0.01;
      break;
    * **case 'e':**
      // high frequency factor +
      factors[4] += 0.01;
      break;
    * **case 'r':**
      // high frequency factor -
      factors[4] -= 0.01;
      break;
    * **case 'ö':**
      // turn on the filling of the ellipses 
      fillin = !fillin;
      println(fillin);
      break;
    
    * **case 't':**
      // increases the spread of the size of the ellipses is not working in the moment why?
      sizeSpread +=0.01;
      setCoreSize();
      println(sizeSpread);
      break;
    * **case 'z':**
      // decreases the spread of the size of the ellipses is not working in the moment why?
      sizeSpread +=-0.01;
      setCoreSize();
      println(sizeSpread);
      break;
    * **case 'g':**
      gravflag = !gravflag;
      break;
    * **case '-':**
      linethickness += 0.2;
      println("linethickness:**");
      println(linethickness);
      break;
    * **case '.':**
      linethickness -= 0.2;
      linethickness = max(0,linethickness);
      break;
    * **case 'p':**
      whitefak += 0.2;
      println("whitefak");
      println(whitefak);
      break;
    * **case 'o':**
      whitefak -= 0.2;
      break;
    * **case 'v':**
      veloFac +=2;
      break;
    * **case 'c':**
      veloFac -=2;
      break;  
     * **case '2':**
      // overall scaling of all factors +
      superfac = 1.1;
      factors = Mat.multiply(factors,superfac);
      break;
     * **case '1':**
      // overall scaling of the factors -
      superfac = 0.9;
      factors = Mat.multiply(factors,superfac);
      break;
     * **case ' ':**
       // get the spheres back in the display area
       place_balls();
     break;
     * **case 'l':** 
       // turns on / off the logarithmic evaluation of the fft
       log_on = !log_on;
       break;



