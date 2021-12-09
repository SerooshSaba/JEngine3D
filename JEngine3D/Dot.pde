class Dot {

  float size = 2000;

  Vec3 position;
  int[] shade;
  
  Dot( float x, float y, float z, int[] col ) {
    this.position = new Vec3( x, y, z );
    this.shade = col;
  }

  Dot( float x, float y, float z, float size, int[] col ) {
    this.size = size;
    this.position = new Vec3( x, y, z );
    this.shade = col;
  }
  
  float getZValue() {
    return this.position.z;
  }
  
  void render( float x, float y, float z ) {
    float dot_depth = Math.abs(z) + this.position.z;
    float darkness = (1500-dot_depth)/1500;
    fill( this.shade[0]*darkness, this.shade[1]*darkness, this.shade[2]*darkness );    
    rect( this.position.x + x, this.position.y + y, this.size/dot_depth, this.size/dot_depth );
    //circle( this.position.x + x, this.position.y + y, this.size/dot_depth );
  }
  
} 