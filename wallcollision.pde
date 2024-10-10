void wallcollision(int index){
  
    if (location[index][0] > (mywidth-coresize_var[index])) {
      velocity[index][0] *= -damping;
      location[index][0] = mywidth-coresize_var[index];
      
    }
    else if(location[index][0] < (coresize_var[index])) {
      velocity[index][0] *= -damping;
      location[index][0] = coresize_var[index];
      
    }
    if (location[index][1] > (myheight-coresize_var[index])) {
      // We're reducing velocity ever so slightly 
      // when it hits the bottom of the window
      velocity[index][1] *= -damping; 
      location[index][1] = myheight-(coresize_var[index]);
      
    }   
    else if (location[index][1] < (coresize_var[index])) {
      // We're reducing velocity ever so slightly 
      // when it hits the bottom of the window
      velocity[index][1] *= -damping; 
      location[index][1] = coresize_var[index];
    }   
}
