class Node extends Dot {

  Vec3 dir = new Vec3(0, 0, 0);
  
  Node( float x, float y, float z, float size, int[] col ) {
    super( x, y, z, size, col );
  }

  Node( float x, float y, float z, float size, float x_dir, float y_dir, float z_dir, int[] col ) {
    super( x, y, z, size, col );
    this.dir = new Vec3( x_dir, y_dir, z_dir );
  }
  
  // General methods - - - - - - - - - - - - - - - - - - - - - - - -
  float Speed() {
    return (float) Math.sqrt( this.dir.x*this.dir.x + this.dir.y*this.dir.y + this.dir.z*this.dir.z );
  }

  void move() {
    this.position.x += this.dir.x;
    this.position.y += this.dir.y;
    this.position.z += this.dir.z;

    float friction = 0.9995;
    this.dir.x *= friction;
    this.dir.y *= friction;
    this.dir.z *= friction;
  }

  float distance_to( Node other ) {
    double xd = Math.abs( this.position.x - other.position.x );
    double yd = Math.abs( this.position.y - other.position.y );
    double zd = Math.abs( this.position.z - other.position.z );
    return (float) Math.sqrt( xd*xd + yd*yd + zd*zd );
  }

  // Liquid behaviour - - - - - - - - - - - - - - - - - - - - - - -

  void behaveAsLiquid( Node other ) {
    
    float distance = this.distance_to( other );

    float coheasion_rate = 0.0075;

    // Repulsion
    if ( this.repell_node( 0.25, other, distance ) ) {
      this.dir.x *= 0.99;
      this.dir.y *= 0.99;
      this.dir.z *= 0.99;
    }
    
    // Cohesion
    else if ( distance > 8 && distance < 10 ) {
      this.dir.x = this.dir.x * ( 1 - coheasion_rate ) + other.dir.x * coheasion_rate;
      this.dir.y = this.dir.y * ( 1 - coheasion_rate ) + other.dir.y * coheasion_rate;
      this.dir.z = this.dir.z * ( 1 - coheasion_rate ) + other.dir.z * coheasion_rate;
    }

  }

  void moveLiquid( ArrayList<Shape> boxes ) {
    
    float boxX, boxY, boxZ, size;
    float step_back_x, step_back_y, step_back_z;
    // Detection with boxes
    for ( Shape box : boxes ) {
      
      // Position and dimention
      boxX = box.vectors[0].x;
      boxY = box.vectors[0].y;
      boxZ = box.vectors[0].z;
      size = Math.abs( boxX - box.vectors[1].x );

      // If the node hits a box
      if ( this.position.x > boxX && this.position.x < boxX + size ) { 
        if ( this.position.y > boxY && this.position.y < boxY + size ) { 
          if ( this.position.z > boxZ && this.position.z < boxZ + size ) { 
            
            // Find what side it hit
            step_back_x = this.position.x - this.dir.x;
            step_back_y = this.position.y - this.dir.y;
            step_back_z = this.position.z - this.dir.z;
            
            if ( step_back_x < boxX || step_back_x > boxX + size ) {
              this.dir.x *= -1 * 0.25;
              this.position.x += this.dir.x * 5;
            }

            else if ( step_back_y < boxY || step_back_y > boxY + size ) {
              this.dir.y *= -1 * 0.25;
              this.dir.x *= 0.98;
              this.dir.z *= 0.98;
              this.position.y += this.dir.y * 5;
            }

            else if ( step_back_z < boxZ || step_back_z > boxZ + size ) {
              this.dir.z *= -1 * 0.25;
              this.position.z += this.dir.z * 5;
            }

          }
        }
      }

    }

    // Move
    this.position.x += this.dir.x;
    this.position.y += this.dir.y;
    this.position.z += this.dir.z;

    // Gravity
    this.dir.y += 0.0005;
  }

  // Gravitational attraction - - - - - - - - - - - - - - - - - - -

  float distance_to( Attractor attractor ) {
    double xd = Math.abs( this.position.x - attractor.position.x );
    double yd = Math.abs( this.position.y - attractor.position.y );
    double zd = Math.abs( this.position.z - attractor.position.z );
    return (float) Math.sqrt( xd*xd + yd*yd + zd*zd );
  }

  float distanceToClosestAttractor( ArrayList<Attractor> attractors ) {
    float min_distance = distance_to(attractors.get(0));
    for ( int i = 1; i < attractors.size(); i++ ) {
      float distance = this.distance_to(attractors.get(i));
      if ( distance < min_distance ) {
        min_distance = distance;
      }
    }
    return min_distance;
  }

  int[] ClosestAttractorColor( ArrayList<Attractor> attractors ) {
    Attractor atr = attractors.get(0);
    float min_distance = distance_to(attractors.get(0));
    for ( int i = 1; i < attractors.size(); i++ ) {
      float distance = this.distance_to(attractors.get(i));
      if ( distance < min_distance ) {
        atr = attractors.get(i);
        min_distance = distance;
      }
    }
    return atr.shade;
  }

  void attract_attractor( Attractor other ) {
    float r = distance_to( other );
    if ( r > 3 ) {

      float G = 0.5;
      float F = G / ( r * r );

      // Position difference
      float xdir = other.position.x - this.position.x;
      float ydir = other.position.y - this.position.y;
      float zdir = other.position.z - this.position.z;

      // Normalize
      float len = (float) Math.sqrt( xdir*xdir + ydir*ydir + zdir*zdir );
      xdir /= len;
      ydir /= len;
      zdir /= len;

      this.dir.x += xdir * F;
      this.dir.y += ydir * F;
      this.dir.z += zdir * F;

    } else {
      float friction = 0.9995;
      this.dir.x *= friction;
      this.dir.y *= friction;
      this.dir.z *= friction;
    }
  }

  void attract_node( Node other, float distance ) {
    if ( distance > 8 ) {

      float G = 0.0025;
      float F = G / ( distance * distance );

      float xdir = other.position.x - this.position.x;
      float ydir = other.position.y - this.position.y;
      float zdir = other.position.z - this.position.z;

      float len = (float) Math.sqrt( xdir*xdir + ydir*ydir + zdir*zdir );

      xdir /= len;
      ydir /= len;
      zdir /= len;

      this.dir.x += xdir * F;
      this.dir.y += ydir * F;
      this.dir.z += zdir * F;
      
    } 
  }

  boolean repell_node( float force, Node other, float distance ) {
    boolean value = false;
    if ( distance < 8 ) {

      float G = force;
      float F = G / ( distance * distance );

      float xdir = this.position.x - other.position.x;
      float ydir = this.position.y - other.position.y;
      float zdir = this.position.z - other.position.z;

      float len = (float) Math.sqrt( xdir*xdir + ydir*ydir + zdir*zdir );

      xdir /= len;
      ydir /= len;
      zdir /= len;

      float friction = 0.9995;
      this.dir.x += xdir * F * friction;
      this.dir.y += ydir * F * friction;
      this.dir.z += zdir * F * friction;

      value = true;

    }
    return value;
  }

  void render( float x, float y, float z ) {
    super.render( x, y, z );
  }

}