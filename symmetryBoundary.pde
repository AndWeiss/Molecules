void symmetryBoundary(int index){
  
    if (location[index][0] > (mywidth-coresize_var[index])) {
      location[index][0] = coresize_var[index];
      
    }
    else if(location[index][0] < (coresize_var[index])) {
      location[index][0] = mywidth-coresize_var[index];
      
    }
    if (location[index][1] > (myheight-coresize_var[index])) {
      location[index][1] = coresize_var[index];
      
    }   
    else if (location[index][1] < coresize_var[index]) {
      location[index][1] = myheight-coresize_var[index];
    }   
}
