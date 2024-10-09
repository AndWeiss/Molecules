void collision(int startindex,boolean gravon){
  float[] distance = new float[3];
  float[] distancem= new float[3];
  float absdistance;
  float[] distanceunit= new float[3];
  //float[] distanceunitabs;
  float[] startvelo=velocity[startindex];
  float r1 =coresize_var[startindex];
  float[] velodiff = new float[3];
  float dissub = 0;
  float r2;
  float m1 = coremass[startindex];
  float m2;
  float [] aminusc = new float[2];
  float velodiffnorm;
  // gravitaional constant (from Newton)
  //float G = 6.674*pow(10,-11);
  for (int i =(startindex+1);i<Ncores;i++){
    // distance vector directs to ball startindex
    distance = Mat.subtract(location[startindex],location[i]);
    absdistance = max(Mat.norm2(distance),0.000001);
    distanceunit = Mat.divide(distance,absdistance);
    r2 = coresize_var[i];
    m2 = coremass[i];
    if (absdistance < (r1+r2)){
      /*for (int j=0;j<3;j++){
        location[startindex][j] +=  (coresize*2-distance[j]);
      }*/
      // the distance vector pointing to ball [i]
      distancem = Mat.multiply(distance,-1);
      //distanceunitabs = Mat.abs(distanceunit);
      // simple collision:
      //velocity[startindex] = Mat.multiply(Mat.multiply(distanceunit,damping),Mat.norm2(velocity[i])) ;
      //velocity[i] = Mat.multiply(Mat.multiply(distanceunit,-damping),Mat.norm2(startvelo));
      // elastic collision from: https://en.wikipedia.org/wiki/Elastic_collision
      velodiff = Mat.subtract(startvelo,velocity[i]);
      // funky error extrem velocities
      //velocity[startindex] = Mat.subtract(startvelo, Mat.multiply(distance,2*m2/(m1+m2)*Mat.dotProduct(velodiff,distance)/absdistance));
      //velocity[i] = Mat.subtract(velocity[i], Mat.multiply(distancem,2*m1/(m1+m2)*Mat.dotProduct(Mat.multiply(velodiff,-1),distancem)/absdistance));
      // correct elastic collision:
      velocity[startindex] = Mat.multiply(Mat.subtract(startvelo, Mat.multiply(distance,2*m2/(m1+m2)*Mat.dotProduct(velodiff,distance)/pow(absdistance,2))),damping);
      velocity[i]          = Mat.multiply(Mat.subtract(velocity[i], Mat.multiply(distancem,2*m1/(m1+m2)*Mat.dotProduct(Mat.multiply(velodiff,-1),distancem)/pow(absdistance,2))),damping);
      
      location[i] = Mat.sum(location[i],Mat.multiply(distanceunit,(-1*((r2+r1)-absdistance))));
      
      // simple realisation of the magnus effect.. (very poor)
      //localgravity[startindex] = Mat.sum(localgravity[startindex], Mat.multiply(distanceunit,-500000));
      //localgravity[i]          = Mat.sum(localgravity[i], Mat.multiply(distanceunit,500000));
      // trying better
      // hm.. something is wrong
      // normalize
      velodiffnorm = Mat.norm2(velodiff); 
      if (velodiffnorm>0.001){
        aminusc  = Mat.divide(velodiff,velodiffnorm);
        gravity[startindex] = Mat.sum(gravity[startindex], Mat.multiply(distanceunit,(-1+(Mat.dotProduct(distanceunit,aminusc)))*magnusfak));
        gravity[i]          = Mat.sum(gravity[i], Mat.multiply(distanceunit,(1-(Mat.dotProduct(distanceunit,aminusc)))*magnusfak));
      }
    }
    if(gravon){
      //make gravity of the balls on each other
      dissub = 0;//-(r2+r1)/2;
      gravity[startindex] = Mat.sum(gravity[startindex],Mat.multiply(distanceunit,-m2*pow(absdistance-dissub,-2))); 
      gravity[i]          = Mat.sum(gravity[i],Mat.multiply(distanceunit,m1*pow(absdistance-dissub,-2)));
      //println(gravity[i]);
    }
  }
}
