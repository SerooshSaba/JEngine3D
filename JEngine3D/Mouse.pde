class Mouse {
  
  float x;
  float y;
  
  float sens = 0.25;
  
  void updateMouse() {
    this.x = mouseX;
    this.y = mouseY;
  }
  
  float[] drag() {
    return new float[]{ sens * ( mouseX - this.x ), sens * ( mouseY - this.y ) }; 
  }
  
}
