//---------------------------
// global variables
float mean_left  = 0;
float mean_right = 0;
//----------------------------
void Get_sound_numbers(){
  //----------------------------
   mean_left  = 0;
   mean_right = 0;
   newWindow = FFT.HANN;
   fft.window( newWindow );
   fft.forward( line_in.mix ); //fourier-Transformation
   // initialization of the sound numbers ---------------------------
   for (int i = 0; i<f_means.length; i++){
     f_means_old[i] = f_means[i];
     f_means[i]     = 0;
     f_maxs[i]      = 0;
     max_freq[i]    = 1;
   }
   //----------------------------------------------------------------
   // loop through all frequency bandwidth
   for (int n =0; n<limits.length-1; n++){
     Get_means(n,limits[n],limits[n+1]);
   }
   f_diff = Mat.sum(f_means_old) - Mat.sum(f_means);
   stereo = stereo_fac*(mean_right - mean_left);
   //println(f_means);
   //println(f_maxs);
}

void Get_means(int index,int l0, int l1){
    for(int i=l0; i<l1 ;i++){
      float tempmag = fft.getBand(i);
      mean_left  += abs(line_in.left.get(i)) ;
      mean_right += abs(line_in.right.get(i));
      if (log_on){
         tempmag = log(tempmag+1);
      }
      f_means[index] += tempmag ;
      //if (log(fft.getBand(max_freq[index]+1) ) <  tempmag ){
      if (f_maxs[index]  <  tempmag ){  
        max_freq[index] = i;
        f_maxs[index]   = fft.getBand(i) ; 
        if(log_on){
          f_maxs[index]   = log(f_maxs[index]+1) ; 
        }
      }
   }
   //f_maxs[index] =   factors[index]*log(fft.getBand(max_freq[index])+1) ; 
   f_maxs[index]  *= factors[index];
   f_means[index] *= factors[index];
}
