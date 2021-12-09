class Edge {
  
  int[] shade = { 0, 255, 0 };
  Vec3 v1;
  Vec3 v2;
  
  Edge( Vec3 v1, Vec3 v2 ) {
    this.v1 = v1;
    this.v2 = v2;
  }
  
  Edge( Vec3 v1, Vec3 v2, int[] shade ) {
    this.v1 = v1;
    this.v2 = v2;
    this.shade = shade;
  }

  void render( float x_offset, float y_offset, float z ) {
    if ( this.v1.z > z && this.v2.z > z ) {
      stroke( this.shade[0], this.shade[1], this.shade[2] );
      line( this.v1.x + x_offset, this.v1.y + y_offset, this.v2.x + x_offset, this.v2.y + y_offset );
    }
  }
  
}
