class Projector {
  
  float x = 500;
  float y = 500;
  float z = -600;
  
  ArrayList<Face> faces;

  ArrayList<Shape> shapes;
  ArrayList<Dot> dots;
  ArrayList<Node> nodes;
  ArrayList<Ray> rays;

  Projector( ArrayList<Shape> shapes, ArrayList<Dot> dots, ArrayList<Node> nodes, ArrayList<Ray> rays ) {

    this.faces = new ArrayList();

    for ( Shape shape : shapes ) {
      if ( shape.faces != null ) { 
        for ( Face face : shape.faces ) {
          this.faces.add( face );
        }
      }
    }

    this.shapes = shapes;
    this.dots = dots;
    this.nodes = nodes;
    this.rays = rays;
  }
  
  void project( Shape shape, String type ) {
    // Copy vectors state 
    Vec3[] vectors_copy = new Vec3[shape.vectors.length];
    for ( int i = 0; i < vectors_copy.length; i++ ) {
      vectors_copy[i] = new Vec3( shape.vectors[i].x, shape.vectors[i].y, shape.vectors[i].z ); 
    }
    // Project vectors
    for ( int i = 0; i < shape.vectors.length; i++ ) {
      float k1 = Math.abs(this.z-shape.vectors[i].z);
      shape.vectors[i].x = Math.abs(this.z)/k1 * ( shape.vectors[i].x );
      shape.vectors[i].y = Math.abs(this.z)/k1 * ( shape.vectors[i].y );
    }
    // Render object
    shape.render( this.x, this.y, type, this.z );
    // Return vectors to their normal unprojected state
    for ( int i = 0; i < shape.vectors.length; i++ ) {
      shape.vectors[i].x = vectors_copy[i].x;
      shape.vectors[i].y = vectors_copy[i].y;
      shape.vectors[i].z = vectors_copy[i].z;
    }
  }
  
  void projectShapes( String type ) {
    Vec3[] vectors_copy;
    for ( Shape shape : this.shapes ) {
      // Copy vectors state 
      vectors_copy = new Vec3[shape.vectors.length];
      for ( int i = 0; i < vectors_copy.length; i++ ) {
        vectors_copy[i] = new Vec3( shape.vectors[i].x, shape.vectors[i].y, shape.vectors[i].z ); 
      }
      // Project vectors
      for ( int i = 0; i < shape.vectors.length; i++ ) {
        float k1 = Math.abs(this.z-shape.vectors[i].z);
        shape.vectors[i].x = Math.abs(this.z)/k1 * ( shape.vectors[i].x );
        shape.vectors[i].y = Math.abs(this.z)/k1 * ( shape.vectors[i].y );
      }
      // Render object
      shape.render( this.x, this.y, type, this.z );
      // Return vectors to their normal unprojected state
      for ( int i = 0; i < shape.vectors.length; i++ ) {
        shape.vectors[i].x = vectors_copy[i].x;
        shape.vectors[i].y = vectors_copy[i].y;
        shape.vectors[i].z = vectors_copy[i].z;
      }
    }
  }
  
  void projectRay( ArrayList<Ray> rays ) {
    for ( Ray ray : rays ) {
      
      Vec3[] vectors_copy = new Vec3[ ray.vectors.length ];
      // Copy vectors state 
      for ( int i = 0; i < vectors_copy.length; i++ ) {
        vectors_copy[i] = new Vec3( ray.vectors[i].x, ray.vectors[i].y, ray.vectors[i].z ); 
      }
      // Project vectors
      for ( int i = 0; i < ray.vectors.length; i++ ) {
        float k1 = Math.abs(this.z-ray.vectors[i].z);
        ray.vectors[i].x = Math.abs(this.z)/k1 * ( ray.vectors[i].x );
        ray.vectors[i].y = Math.abs(this.z)/k1 * ( ray.vectors[i].y );
      }
      
      // Render object
      ray.render( this.x, this.y, this.z );

      // Return vectors to their normal unprojected state
      for ( int i = 0; i < ray.vectors.length; i++ ) {
        ray.vectors[i].x = vectors_copy[i].x;
        ray.vectors[i].y = vectors_copy[i].y;
        ray.vectors[i].z = vectors_copy[i].z;
      }
      
    }
  }

  void projectDots( int frame ) {
    
    // Sort dots every 100 frames
    if ( frame % 500 == 0 ) {
      this.sortDots();
    }

    noStroke();

    for ( Dot dot : this.dots ) {
      if ( dot.position.z > this.z ) {
        Vec3 copy = new Vec3( dot.position.x, dot.position.y, dot.position.z  );
        // Project x and y
        float k1 = Math.abs(this.z-dot.position.z);
        dot.position.x = Math.abs(this.z)/k1 * ( dot.position.x );
        dot.position.y = Math.abs(this.z)/k1 * ( dot.position.y );
        // Render dot with projected x and y
        dot.render( this.x, this.y, this.z );
        // Revert back to original state
        dot.position.x = copy.x;
        dot.position.y = copy.y;
      }
    }
  }

  void projectAttractors( ArrayList<Attractor> attr ) {
    noStroke();
    for ( Attractor at : attr ) {
      if ( at.position.z > this.z ) {
        Vec3 copy = new Vec3( at.position.x, at.position.y, at.position.z  );

        float k1 = Math.abs(this.z-at.position.z);
        at.position.x = Math.abs(this.z)/k1 * ( at.position.x );
        at.position.y = Math.abs(this.z)/k1 * ( at.position.y );

        at.render( this.x, this.y, this.z );

        at.position.x = copy.x;
        at.position.y = copy.y;
      }
    }
  }

  void projectNodes( int frame ) {
    if ( frame % 10000 == 0 ) {
      this.sortNodes();
    }
    noStroke();
    for ( Node node : this.nodes ) {
      if ( node.position.z > this.z ) {
        Vec3 copy = new Vec3( node.position.x, node.position.y, node.position.z );
        // Project x and y
        float k1 = Math.abs(this.z-node.position.z);
        node.position.x = Math.abs(this.z)/k1 * ( node.position.x );
        node.position.y = Math.abs(this.z)/k1 * ( node.position.y );
        // Render dot with projected x and y
        node.render( this.x, this.y, this.z );
        // Revert back to original state
        node.position.x = copy.x;
        node.position.y = copy.y;
      }
    }
  }

  void projectFaces( int frame ) {

    noStroke();

    // Copy vectors positions
    ArrayList<Vec3> vectors_copy = new ArrayList();

    for ( Shape shape : this.shapes ) {
      for ( Vec3 vector : shape.vectors ) {
        vectors_copy.add( new Vec3( vector.x, vector.y, vector.z ) );
      }
    }

    // Project the vectors of all models
    for ( Shape shape : this.shapes ) {
      for ( Vec3 vector : shape.vectors ) {
        float k1 = Math.abs(this.z-vector.z);
        vector.x = Math.abs(this.z)/k1 * ( vector.x );
        vector.y = Math.abs(this.z)/k1 * ( vector.y );
      }
    }

    // Sort faces every 100 frames
    if ( frame % 250 == 0 ) {
      this.sortFaces();
    }

    // Render faces
    for ( Face face : this.faces ) {

      Vec3 p1 = face.vec1;
      Vec3 p2 = face.vec2;
      Vec3 p3 = face.vec3;
      
      Vec3 a = p2.subs( p1 );
      Vec3 b = p3.subs( p1 );
      
      Vec3 C = new Vec3( a.y*b.z - a.z*b.y, a.x*b.z - a.z*b.x, a.x*b.y - a.y*b.x );

      float C_len = C.length();

      C.x = C.x / C_len;
      C.y = C.y / C_len;
      C.z = C.z / C_len;

      float[] light_cam = new float[]{ 0, 0, -1 };

      float dot = C.x * light_cam[0] + C.y * light_cam[1] + C.z * light_cam[2];

      if ( dot > 0 ) {
        fill( face.shade[0] * dot, face.shade[1] * dot, face.shade[2] * dot );
        face.render( this.x, this.y, this.z );
      }
    }

    // Unproject the vectors
    int selector = 0;

    for ( Shape shape : this.shapes ) {
      for ( Vec3 vector : shape.vectors ) {
        vector.x = vectors_copy.get(selector).x;
        vector.y = vectors_copy.get(selector).y;
        vector.z = vectors_copy.get(selector).z;
        selector++;
      }
    }

  }

  void sortFaces() {
    for ( int i = 0; i < this.faces.size(); i++ ) {
      for ( int j = 0; j < this.faces.size(); j++ ) {
        if ( i != j ) {
          if ( this.faces.get(i).getZ() > this.faces.get(j).getZ() ) {
            Face temp = this.faces.get(i);
            this.faces.set( i, this.faces.get(j) );
            this.faces.set( j, temp );
          }
        }
      }
    }
  }

  void sortDots() {
    
    for ( int i = 0; i < this.dots.size(); i++ ) {
      for ( int j = 0; j < this.dots.size(); j++ ) {
        if ( i != j ) {
          if ( this.dots.get(i).position.z > this.dots.get(j).position.z ) {
            Dot temp = this.dots.get(i);
            this.dots.set( i, this.dots.get(j) );
            this.dots.set( j, temp );
          }
        }
      }
    }

  }

  void sortNodes() {
    for ( int i = 0; i < this.nodes.size(); i++ ) {
      for ( int j = 0; j < this.nodes.size(); j++ ) {
        if ( i != j ) {
          if ( this.nodes.get(i).position.z > this.nodes.get(j).position.z ) {
            Node temp = this.nodes.get(i);
            this.nodes.set( i, this.nodes.get(j) );
            this.nodes.set( j, temp );
          }
        }
      }
    }
  }

}
