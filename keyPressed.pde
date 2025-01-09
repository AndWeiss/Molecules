  
void keyPressed() {
  println(key);
  switch (key) {
    case 'x':
      // low frequency factor +
     factors[0] *= 1.1;
      break;
    case'y':
     // low frequency factor -
     factors[0] *= 0.9;
     break;
   case 's':
      // low mids frequency factor +
      factors[1] *= 1.1;
      break;
    case 'a':
      // low mids frequency factor -
      factors[1] *= 0.9;
      break;
    case 'w':
      // mids frequency factor +
      factors[2] *= 1.1;
      break;
    case 'q':
      // mids frequency factor -
      factors[2] *= 0.9;
      break;
    case 'd':
      // high mids frequency factor +
      factors[3] *= 1.1;
      break;
    case 'f':
      // high mids frequency factor -
      factors[3] *= 0.9;
      break;
    case 'e':
      // high frequency factor +
      factors[4] *= 1.1;
      break;
    case 'r':
      // high frequency factor -
      factors[4] *= 0.9;
      break;
    case 'ö':
      // turn on the filling of the ellipses 
      fillin = !fillin;
      println(fillin);
      break;
    case 'z':
      // increase the spread of the size of the ellipses 
      sizeSpread *= 1.1;
      setCoreSize();
      println(sizeSpread);
      break;
    case 't':
      // decrease the spread of the size of the ellipses 
      sizeSpread *= 0.9;
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
      white_fac *= 1.1;
      println("white_fac");
      println(white_fac);
      break;
    case 'o':
      white_fac *= 0.9;
      break;
    case 'v':
      veloFac +=2;
      break;
    case 'c':
      veloFac -=2;
      break;  
     case '2':
      // overall scaling of all factors higherll
      factors = Mat.multiply(factors,2-superfac);
      break;
     case '1':
      // overall scaling of the factors lower
      factors = Mat.multiply(factors,superfac);
      break;
     case ' ':
       // get the spheres back in the display area
       place_balls();
     break;
     case 'l': 
       // turns on / off the logarithmic evaluation of the fft
       log_on = !log_on;
       break;
    case 'm': 
       // increase the stereo factor +
       stereo_fac *= 1.1;
       break;
    case 'n': 
       // increase the stereo factor +
       stereo_fac *= 0.9;
       break;
    case ENTER:
      big_bang = !big_bang;
    } // end switch 
    println("factors");
    println(factors);
    print("log is ");
    println(log_on);
}
