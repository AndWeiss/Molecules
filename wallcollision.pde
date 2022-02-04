void wallcollision(int index){
  
    if (location[index][0] > (width-coresize[index])) {
      velocity[index][0] *= -damping;
      location[index][0] = width-coresize[index];
      
    }
    else if(location[index][0] < (coresize[index])) {
      velocity[index][0] *= -damping;
      location[index][0] = coresize[index];
      
    }
    if (location[index][1] > (height-coresize[index])) {
      // We're reducing velocity ever so slightly 
      // when it hits the bottom of the window
      velocity[index][1] *= -damping; 
      location[index][1] = height-coresize[index];
      
    }   
    else if (location[index][1] < coresize[index]) {
      // We're reducing velocity ever so slightly 
      // when it hits the bottom of the window
      velocity[index][1] *= -damping; 
      location[index][1] = coresize[index];
    }   
}
