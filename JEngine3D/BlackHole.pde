class BlackHole extends Shape {
    
    BlackHole() {
      
      ArrayList<Vec3> vectors = new ArrayList();
      
      int len = 15;
      int rot = 300;
      
      float i = len;
      while ( i > 0 ) {
        for ( int j = 0; j < rot; j++ ) { // Rotation
          float angle = 2 * 3.14159 * j/rot;
          float x = (float) Math.cos(angle) * i;
          float y = 100 / i + 1;
          float z = (float) Math.sin(angle) * i;
          vectors.add( new Vec3( x, y, z ) );
        }
        i -= 0.1;
      }
      
      this.vectors = vectors.toArray(new Vec3[vectors.size()]);
            
      println( this.vectors.length );
    }
    
}
