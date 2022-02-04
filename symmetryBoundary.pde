void symmetryBoundary(int index){
  
    if (location[index][0] > (width-coresize[index])) {
      location[index][0] = coresize[index];
      
    }
    else if(location[index][0] < (coresize[index])) {
      location[index][0] = width-coresize[index];
      
    }
    if (location[index][1] > (height-coresize[index])) {
      location[index][1] = coresize[index];
      
    }   
    else if (location[index][1] < coresize[index]) {
      location[index][1] = height-coresize[index];
    }   
}
