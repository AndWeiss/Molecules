void no_boundary(int index){
  // let the balls fly out of the screen and replace them in the center
  if (location[index][0] > (mywidth-coresize_var[index])) {
      location[index][0] = center[0];
      location[index][1] = center[1];
      
    }
    else if(location[index][0] < (coresize_var[index])) {
      location[index][0] = center[0];
      location[index][1] = center[1];
      
    }
    if (location[index][1] > (myheight-coresize_var[index])) {
      // We're reducing velocity ever so slightly 
      // when it hits the bottom of the window
      location[index][0] = center[0];
      location[index][1] = center[1];
      
    }   
    else if (location[index][1] < (coresize_var[index])) {
      // We're reducing velocity ever so slightly 
      // when it hits the bottom of the window
      location[index][0] = center[0];
      location[index][1] = center[1];
    }   






}
