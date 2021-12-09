class Face {

  Vec3 vec1;
  Vec3 vec2;
  Vec3 vec3;
  Vec3 vec4;

  Edge[] edges;

  Boolean triangle = true;
  int[] shade = new int[3];

  Face( Vec3 vec1, Vec3 vec2, Vec3 vec3 ) { // Triangle
    this.vec1 = vec1;
    this.vec2 = vec2;
    this.vec3 = vec3;

    this.edges = new Edge[3];
    this.edges[0] = new Edge( this.vec1, this.vec2, new int[]{ 0, 255, 0 } );
    this.edges[1] = new Edge( this.vec2, this.vec3, new int[]{ 0, 255, 0 } );
    this.edges[2] = new Edge( this.vec1, this.vec3, new int[]{ 0, 255, 0 } );
  }
  
  Face( Vec3 vec1, Vec3 vec2, Vec3 vec3, Vec3 vec4 ) { // Quad
    this.vec1 = vec1;
    this.vec2 = vec2;
    this.vec3 = vec3;
    this.vec4 = vec4;
    this.triangle = false;

    this.edges = new Edge[4];
    this.edges[0] = new Edge( this.vec1, this.vec2, new int[]{ 0, 255, 0 } );
    this.edges[1] = new Edge( this.vec2, this.vec3, new int[]{ 0, 255, 0 } );
    this.edges[2] = new Edge( this.vec3, this.vec4, new int[]{ 0, 255, 0 } );
    this.edges[3] = new Edge( this.vec1, this.vec4, new int[]{ 0, 255, 0 } );
  }
  
  float getZ() { // Get depth value
    float depth = 0;    
    if ( this.triangle ) {
      depth = this.vec1.z + this.vec2.z + this.vec3.z;
    } else {
      depth = this.vec1.z + this.vec2.z + this.vec3.z + this.vec4.z;
    }
    return depth;
  }
  
  void render( float x_offset, float y_offset, float z ) {
    if ( this.vec1.z > z ) {
      if ( this.triangle ) {
        triangle( vec1.x + x_offset, vec1.y + y_offset, vec2.x + x_offset, vec2.y + y_offset, vec3.x + x_offset, vec3.y + y_offset );
      }
      else {
        quad( vec1.x + x_offset, vec1.y + y_offset, vec2.x + x_offset, vec2.y + y_offset, vec3.x + x_offset, vec3.y + y_offset, vec4.x + x_offset, vec4.y + y_offset );
      }
    }
    /*
    strokeWeight(1);
    for ( Edge e : this.edges ) {
      if ( e.v1.z > z && e.v2.z > z ) {
        e.render( x_offset, y_offset, z );
      }
    }
    */
  }
  
}
