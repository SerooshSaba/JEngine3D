class Vec3 {

  float x;
  float y;
  float z;
  
  Vec3( float x, float y, float z ) {
    this.x = x;
    this.y = y;
    this.z = z;
  }
  
  void scale( float scalar ) {
    this.x *= scalar;
    this.y *= scalar;
    this.z *= scalar;
  }
  
  float[] matmul( float[][] m, float[] v ) {
    int size = v.length;
    float result[] = new float[size];
    for ( int col = 0; col < m.length; col++ ) {
      float sum = 0;
      for ( int index = 0; index < v.length; index++ ) {
        sum += m[index][col] * v[index];
      }
      result[col] = sum;
    }
    return result;
  }
  
  void rotX( float degrees ) {
    float radians = 3.14159 / 180 * degrees;
    float c = cos(radians);
    float s = sin(radians);
    float[][] mat = {
      { 1, 0, 0 },
      { 0, c, -s },
      { 0, s, c }
    };
    float[] vec = { this.x, this.y, this.z };
    float[] result = this.matmul( mat, vec );
    this.x = result[0];
    this.y = result[1];
    this.z = result[2]; 
  }
  
  void rotY( float degrees ) {
    float radians = 3.14159 / 180 * degrees;
    float c = cos(radians);
    float s = sin(radians);
    float[][] mat = {
      {  c, 0, s },
      {  0, 1, 0 },
      { -s, 0, c }
    };
    float[] vec = { this.x, this.y, this.z };
    float[] result = this.matmul( mat, vec );
    this.x = result[0];
    this.y = result[1];
    this.z = result[2]; 
  }
  
  void rotLockedY( float degrees, float totalxrotation ) {
    this.rotX( totalxrotation );
    this.rotY( degrees );
    this.rotX( -totalxrotation );
  }
  
  void rotXCamera( float degrees, Projector p ) {
    this.z -= p.z;
    this.rotX( degrees );
    this.z += p.z;
  }
  
  void rotYCamera( float degrees, float xrotation, Projector p ) {
    this.rotXCamera( xrotation, p );
    this.z -= p.z;
    this.rotY( degrees );
    this.z += p.z;
    this.rotXCamera( -xrotation, p );
  }
  
  void transX( float translation ) {
    this.x += translation;
  }
  void transY( float translation ) {
    this.y += translation;
  }
  void transZ( float translation ) {
    this.z += translation;
  }
  
  Vec3 subs( Vec3 other ) {
    return new Vec3( this.x - other.x, this.y - other.y, this.z - other.z );
  }
  
  float length() {
    return (float) Math.sqrt( this.x*this.x + this.y*this.y + this.z*this.z );
  }
  
  void render( float x_offset, float y_offset ) {
    noStroke();
    fill(255,0,0);
    rect( this.x + x_offset, this.y + y_offset, 1, 1 );
  }
  
  @Override
  String toString() {
    return this.x + " " + this.y + " " + this.z;
  }
  
}
