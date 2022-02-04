void setCoreSize(){
   for(int i =0;i<Ncores;i++){
      coresize[i]= globalcoresize - random(globalcoresize*sizeSpread) ;
   }
}
