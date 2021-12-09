import java.util.*;
import java.lang.Object;

class Shape {
  
  int[] shade = new int[]{ 255, 255, 255 };

  Vec3[] vectors;
  Edge[] edges;
  Face[] faces;

  String type;

  // - - - - - - - Translate - - - - -
  
  void transX( float translation ) {
    for ( Vec3 v : this.vectors ) {
      v.transX( translation );
    }
  }
  
  void transY( float translation ) {
    for ( Vec3 v : this.vectors ) {
      v.transY( translation );
    }
  }
  
  void transZ( float translation ) {
    for ( Vec3 v : this.vectors ) {
      v.transZ( translation );
    }
  }
  
  // - - - - - - - - Rotation - - - - - 
  
  void rotX( float degrees ) {
    for ( Vec3 vector : this.vectors ) {
      vector.rotX( degrees );
    }
  }
  
  void rotY( float degrees ) {
    for ( Vec3 vector : this.vectors ) {
      vector.rotY( degrees );
    }
  }

  void rotLockedY( float degrees, float totalxrotation ) {
    for ( Vec3 vector : this.vectors ) {
      vector.rotLockedY( degrees, totalxrotation );
    }
  }
  
  void rotXCamera( float degrees, Projector p ) {
    for ( Vec3 vector : this.vectors ) {
      vector.rotXCamera( degrees, p );
    }
  }
  
  void rotYCamera( float degrees, float total_x_rotation, Projector p ) {
    for ( Vec3 vector : this.vectors ) {
      vector.rotYCamera( degrees, total_x_rotation, p );
    }
  }
  
  // - - - - - - - - Misc - - - - - -

  void scale( float scalar ) {
    for ( Vec3 v : this.vectors ) {
      v.x *= scalar;
      v.y *= scalar;
      v.z *= scalar;
    }
  }

  void scaleX( float scalar ) {
    for ( Vec3 v : this.vectors ) {
      v.x *= scalar;
    }
  }

  void scaleY( float scalar ) {
    for ( Vec3 v : this.vectors ) {
      v.y *= scalar;
    }
  }

  void scaleZ( float scalar ) {
    for ( Vec3 v : this.vectors ) {
      v.z *= scalar;
    }
  }

  void setEdgeColor( int r, int g, int b ) {
    for ( Edge edge : this.edges ) {
      edge.shade[0] = r;
      edge.shade[1] = g;
      edge.shade[2] = b;
    }
  }

  void setColor( int r, int g, int b ) {
    this.shade = new int[]{ r, g, b };
    for ( Face face : this.faces ) {
      face.shade[0] = r;
      face.shade[1] = g;
      face.shade[2] = b;
    }
  }

  // - - - - - - - - Render - - - - -

  void render( float x_offset, float y_offset, String type, float z ) {

    if ( type == "f" ) {
      noStroke();

      for ( Face f : this.faces ) {
        
        Vec3 p1 = f.vec1;
        Vec3 p2 = f.vec2;
        Vec3 p3 = f.vec3;
        
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
          //f.col = (int) ( dot * 255 );
          fill( f.shade[0] * dot, f.shade[1] * dot, f.shade[2] * dot );
          f.render( x_offset, y_offset, z );
        }

      }
      
    } else if ( type == "e" ) {
      strokeWeight(2);
      for ( Edge e : this.edges ) {
        if ( e.v1.z > z && e.v2.z > z ) {
          e.render( x_offset, y_offset, z );
        }
      }

    } else if ( type == "v" ) {

      for ( Vec3 v : this.vectors ) {
        v.render( x_offset, y_offset );
      }

    }
    
  }
  
}

class Plane extends Shape {

  Plane( int size, float length ) {

    Vec3[][] vectors = new Vec3[size][size];

    // Generate vectors
    for ( int z = 0; z < size; z++ ) {
      for ( int x = 0; x < size; x++ ) {
        vectors[z][x] = new Vec3( x * length, 0, z * length );
      }
    }

    /*
    // WAVES
    for ( int z = 0; z < size; z++ ) {
      for ( int x = 0; x < size; x++ ) {
        float rad = (float) ( 10 * Math.PI / size * z );
        float co = (float) ( Math.cos( rad ) * 5 );
        vectors[z][x].y += co;
      }
    }
    for ( int z = 0; z < size; z++ ) {
      for ( int x = 0; x < size; x++ ) {
        float rad = (float) ( 10 * Math.PI / size * x );
        float co = (float) ( Math.cos( rad ) * 5 );
        vectors[z][x].y += co;
      }
    }*/
    

    // Assign vectors
    this.vectors = new Vec3[size*size];
    int loc;
    for ( int z = 0; z < size; z++ ) {
      for ( int x = 0; x < size; x++ ) {
        loc = x + z * size;
        this.vectors[loc] = vectors[z][x];
      }
    }

    // Assign edges
    ArrayList<Edge> edges = new ArrayList();
    for ( int z = 0; z < vectors.length; z++ ) {
      for ( int x = 1; x < vectors.length; x++ ) {
        edges.add( new Edge( vectors[z][x], vectors[z][x-1], new int[] {255,255,255} ) );
      }
    }
    for ( int x = 0; x < vectors.length; x++ ) {
      for ( int z = 1; z < vectors.length; z++ ) {
        edges.add( new Edge( vectors[z][x], vectors[z-1][x], new int[] {255,255,255} ) );
      }
    }

    this.edges = new Edge[edges.size()];
    for ( int i = 0; i < edges.size(); i++ ) {
      this.edges[i] = edges.get(i);
    }

    // Generate faces
    ArrayList<Face> faces = new ArrayList();

    /* Faces with 4 vectors
    for ( int z = 0; z < size-1; z++ ) {
      for ( int x = 0; x < size-1; x++ ) {
        faces.add( new Face( vectors[z][x], vectors[z][x+1], vectors[z+1][x+1], vectors[z+1][x] ) );
      }
    }
    */

    // Faces with 3 vectors
    float r, g, b;
    for ( int z = 0; z < size-1; z++ ) {
      for ( int x = 0; x < size-1; x++ ) {

        r = (float) x/(size-1)*255;
        g = random(0,1) * 255;
        b = random(0,1) * 255;
        
        Face f1 = new Face( vectors[z][x],   vectors[z][x+1],   vectors[z+1][x] );
        Face f2 = new Face( vectors[z][x+1], vectors[z+1][x+1], vectors[z+1][x] );

        f1.shade[0] = (int) r;
        f2.shade[0] = (int) r;

        f1.shade[1] = (int) g;
        f2.shade[1] = (int) g;

        f1.shade[2] = (int) b;
        f2.shade[2] = (int) b;

        faces.add( f1 );
        faces.add( f2 );
      }
    }

    this.faces = new Face[faces.size()];
    for ( int i = 0; i < faces.size(); i++ ) {
      this.faces[i] = faces.get(i);
    }

  }

}
