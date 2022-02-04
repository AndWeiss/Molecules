# Molecules

It calculates the movement of particles (realized as ellipses), based on an audio input. 

It is programmed with processing version 3+ https://processing.org/download/
Additionally the papaya library, for matrix multiplication must be installed http://adilapapaya.com/papayastatistics/
also the minim library is mandatory.

The Molecules move towards a direction that is calculated by the collision of the molecules to each other. 
Some (physical) properties can be adjusted with the computer keys:

* **case 'D':**   
more damping in the collisions  
if the value is above **1** the velocity of two colliding molecules is higher than its initial velocity which means that energy is created within the collision   
`damping -= 0.001;`   
* **case 'S':**    
less damping in the collisions  
`damping += 0.001;`  
* **case  'E':**  
more "air" drag  
`drag[0] +=  0.005;`  
`drag[1] +=  0.005;`  
* **case  'W':**   
less "air" drag  
`drag[0] -= 0.005;`  
`drag[1] -= 0.005;`  
* **case  'F':**  
set the ellipses to be filled with greyscale or only the outlines  
`fillin = !fillin;`  
* **case  'B':**  
increase the mean size of the  
`globalcoresize *=1.1;`  
`coresize = Mat.multiply(coresize,1.1);`  
* **case  'V':**  
`globalcoresize *=0.9;`  
`coresize = Mat.multiply(coresize,0.9);`    
* **case  'C':**  
`sizeSpread +=0.01;`  
`setCoreSize();`  
* **case  'X':**  
`sizeSpread +=-0.01;`  
`setCoreSize();`    
* **case  'M':**  
`magnusfak += 10;`    
* **case  'N':**  
`magnusfak += -10;`    
* **case  'G':**  
`gravflag = !gravflag;`  
* **case  '-':**  
`linethickness += 0.2;`     
* **case  '.':**  
`linethickness -= 0.2;`  
`linethickness = max(0,linethickness);`   
* **case  'P':**  
`whitefak += 0.2;`     
* **case  'O':**  
`whitefak -= 0.2;`   
* **case  'J':**  
`veloFac +=10;`    
* **case  'H':**  
`veloFac -=10;`  
