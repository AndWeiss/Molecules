void setCoreSize(){
   for(int i =0;i<Ncores;i++){
      coresize[i]= globalcoresize - random(globalcoresize*sizeSpread) ;
   }
}

void place_balls(){
  for(int i =0;i<Ncores;i++){
    location[i][0] = random(mywidth); // randomGaussian()+center[0];
    location[i][1] = random(myheight); //randomGaussian()+center[1];
    // 
    velocity[i][0] = 0;
    velocity[i][1] = 0;
  }
}
