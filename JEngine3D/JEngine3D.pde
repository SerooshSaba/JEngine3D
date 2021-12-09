ArrayList<Node> nodes = new ArrayList();
ArrayList<Shape> shapes = new ArrayList();
ArrayList<Dot> dots = new ArrayList();
ArrayList<Ray> rays = new ArrayList();
ArrayList<Attractor> attractors = new ArrayList();

Projector p;
Mouse mouse = new Mouse();

ModelLoader ml = new ModelLoader();
InputHandler inputHandler = new InputHandler( shapes, dots, attractors, nodes, rays );
Coordinate coord = new Coordinate();
RayCaster raycaster = new RayCaster();

int frame = 0;
float SumXRotation = 0;
float SumYRotation = 0;
float start_point = 0;

Fluid FLUID;

// - - - - - - - - - - - - - - SETUP - - - - - - - - - - - - -
void setup() {
  frameRate(500);
  size(1000,1000);
  smooth(0);
  
  /*
  for ( int x = 0; x < 4; x++ ) {
    for ( int z = 0; z < 4; z++ ) {
      Shape sphere = ml.load("models/sphere.obj");
      sphere.type = "sphere";
      sphere.scale( 50 );
      sphere.transX( x * 55 );
      sphere.transY( 0 );
      sphere.transZ( z * 55 );
      if ( x % 2 == 0 ) {
        sphere.setColor(255,0,0);
      } else {
        sphere.setColor(0,0,255);
      }
      shapes.add(sphere);
    }
  }
  */
  
  Fluid fluid = new Fluid(50,25);
  FLUID = fluid;
  fluid.transY(250);
  shapes.add(fluid);

  /*
  Box box = new Box();
  box.scale(750);
  box.transX(-250);
  box.transY(50);
  box.transZ(-250);
  box.setColor(0,255,0);
  shapes.add(box);
  */

  /*
  attractors.add( new Attractor( 33.33, 50, -300, new int[]{ 255, 0, 0 } ) );
  attractors.add( new Attractor( 66.66, 50, -300, new int[]{ 0, 0, 255 } ) );
  float displacement = 0.5;

  for ( float x = 50; x < 75; x += displacement ) {
    for ( float y = 25; y < 75; y += displacement ) {
      for ( float z = -300; z < -290; z += displacement ) {
        
        float x_position = x + displacement/2;
        float y_position = y + displacement/2;
        float z_position = z + displacement/2;

        Node temp = new Node( x_position, y_position, z_position, 0, 0, 0, 0, new int[]{ 0, 0, 0 } );
        
        while ( temp.Speed() > 1 || temp.distanceToClosestAttractor(attractors) > 1 ) {
          for ( Attractor a : attractors ) {
            temp.attract_attractor(a);
          }
          temp.move();
        }
        
        int[] shade = temp.ClosestAttractorColor(attractors);

        Dot dot = new Dot( x_position, y_position, z_position, 200, shade );
        if ( dot.shade[0] == 255 )
          dots.add(dot);

      }
    }
  }
  */

  /*
  for ( int x = 0; x < 300; x += 15 ) {
    for ( int y = 0; y < 300; y += 15 ) {
      nodes.add( new Node( x, y, -400, 2000, 0.01, 0, 0, new int[]{ 200, 0, 0 } ) );
    }
  }
  */

  /*
  ArrayList<Boolean> duplicate_counter = new ArrayList();
  Shape first = ml.load( "models/cube.obj" );
  first.scale(100);
  first.setColor(255,255,255);
  duplicate_counter.add( false );
  shapes.add( first );
  float scale_change = 0.4;
  
  for ( int i = 0; i < 3; i++ ) {
    for ( int j = shapes.size() - 1; j >= 0; j-- ) {
      if ( duplicate_counter.get(j) == false ) {

        duplicate_counter.set( j, true );

        float scale = (float) Math.abs( shapes.get(j).vectors[0].x - shapes.get(j).vectors[4].x );
        float x = shapes.get(j).vectors[0].x;
        float y = shapes.get(j).vectors[0].y;
        float z = shapes.get(j).vectors[0].z;
  
        // Close left bottom
        Shape newcube = ml.load( "models/cube.obj" );
        newcube.scale( scale*scale_change );
        newcube.transX( x - scale*scale_change );
        newcube.transY( y + scale );
        newcube.transZ( z - scale*scale_change );

        newcube.setColor(255,255,255);
        shapes.add(newcube);
        duplicate_counter.add( false );

        // Close right bottom
        newcube = ml.load( "models/cube.obj" );
        newcube.scale( scale*scale_change );
        newcube.transX( x + scale );
        newcube.transY( y + scale );
        newcube.transZ( z - scale*scale_change );

        newcube.setColor(255,255,255);
        shapes.add(newcube);
        duplicate_counter.add( false );
        

        // Close right top
        newcube = ml.load( "models/cube.obj" );
        newcube.scale( scale*scale_change );
        newcube.transX( x + scale );
        newcube.transY( y - scale*scale_change );
        newcube.transZ( z - scale*scale_change );

        newcube.setColor(255,255,255);
        shapes.add(newcube);
        duplicate_counter.add( false );

        // Close left top
        newcube = ml.load( "models/cube.obj" );
        newcube.scale( scale*scale_change );
        newcube.transX( x - scale*scale_change );
        newcube.transY( y - scale*scale_change );
        newcube.transZ( z - scale*scale_change );

        newcube.setColor(255,255,255);
        shapes.add(newcube);
        duplicate_counter.add( false );
        

        // Far left bottom
        newcube = ml.load( "models/cube.obj" );
        newcube.scale( scale*scale_change );
        newcube.transX( x - scale*scale_change );
        newcube.transY( y + scale );
        newcube.transZ( z + scale );

        newcube.setColor(255,255,255);
        shapes.add(newcube);
        duplicate_counter.add( false );

        // Close right bottom
        newcube = ml.load( "models/cube.obj" );
        newcube.scale( scale*scale_change );
        newcube.transX( x + scale );
        newcube.transY( y + scale );
        newcube.transZ( z + scale );

        newcube.setColor(255,255,255);
        shapes.add(newcube);
        duplicate_counter.add( false );
        
        // Close right top
        newcube = ml.load( "models/cube.obj" );
        newcube.scale( scale*scale_change );
        newcube.transX( x + scale );
        newcube.transY( y - scale*scale_change );
        newcube.transZ( z + scale );

        newcube.setColor(255,255,255);
        shapes.add(newcube);
        duplicate_counter.add( false );

        // Close left top
        newcube = ml.load( "models/cube.obj" );
        newcube.scale( scale*scale_change );
        newcube.transX( x - scale*scale_change );
        newcube.transY( y - scale*scale_change );
        newcube.transZ( z + scale );

        newcube.setColor(255,255,255);
        shapes.add(newcube);
        duplicate_counter.add( false );

      }
    }
    

    int deleted = 0;
    // Delete cubes that are inside other cubes
    for ( int j = 0; j < shapes.size(); j++ ) {
      for ( int k = 0; k < shapes.size(); k++ ) {
        if ( j != k ) {
          
          Shape c1 = this.shapes.get(j);
          Shape c2 = this.shapes.get(k);

          float c1x = c1.vectors[0].x;
          float c1y = c1.vectors[0].y;
          float c1z = c1.vectors[0].z;

          float c2x = c2.vectors[0].x;
          float c2y = c2.vectors[0].y;
          float c2z = c2.vectors[0].z;

          float c1_scale = (float) Math.abs( shapes.get(j).vectors[0].x - shapes.get(j).vectors[4].x );
          float c2_scale = (float) Math.abs( shapes.get(k).vectors[0].x - shapes.get(k).vectors[4].x );

          float margin = 1;
          Boolean inside = false;

          if ( ( c1x > c2x - margin && c1x + c1_scale < c2x + c2_scale + margin ) || ( c2x > c1x - margin && c2x + c2_scale < c1x + c1_scale + margin ) ) {
            if ( ( c1y > c2y - margin && c1y + c1_scale < c2y + c2_scale + margin ) || ( c2y > c1y - margin && c2y + c2_scale < c1y + c1_scale + margin ) ) {
              if ( ( c1z > c2z - margin && c1z + c1_scale < c2z + c2_scale + margin  ) || ( c2z > c1z - margin && c2z + c2_scale < c1z + c1_scale + margin ) ) {
                inside = true;
              }
            }
          }

          // If one is inside the other, then we need to delete the smallest one
          if ( inside ) {
            if ( c1_scale > c2_scale ) {
              this.shapes.remove(k);
              deleted++;
            } else {
              this.shapes.remove(j);
              deleted++;
            }
          }

        }
      }      
    }

  }
  */

  /*
  for ( int i = 0; i < 6; i++ ) {
    for ( int j = shapes.size() - 1; j >= 0; j-- ) {
      if ( duplicate_counter.get(j) == false ) {

        duplicate_counter.set( j, true );

        float scale = (float) Math.abs( shapes.get(j).vectors[0].x - shapes.get(j).vectors[4].x );
        float x = shapes.get(j).vectors[0].x;
        float y = shapes.get(j).vectors[0].y;
        float z = shapes.get(j).vectors[0].z;

        // Close
        Shape newcube = ml.load( "models/cube.obj" );
        newcube.scale( scale*scale_change );
        newcube.transX( x + (scale * scale_change)/2 );
        newcube.transY( y + scale * 1/3 );
        newcube.transZ( z - scale*scale_change );
        shapes.add(newcube);
        duplicate_counter.add( false );
        
        if ( scale < 600 ) {
        
          // Left
          newcube = ml.load( "models/cube.obj" );
          newcube.scale( scale*scale_change );
          newcube.transX( x - scale * scale_change );
          newcube.transY( y + scale * 1/3 );
          newcube.transZ( z + scale * 1/3 );
          shapes.add(newcube);
          duplicate_counter.add( false );
  
          // Right
          newcube = ml.load( "models/cube.obj" );
          newcube.scale( scale*scale_change );
          newcube.transX( x + scale );
          newcube.transY( y + scale * 1/3 );
          newcube.transZ( z + scale * 1/3 );
          shapes.add(newcube);
          duplicate_counter.add( false );
  
          // Top
          newcube = ml.load( "models/cube.obj" );
          newcube.scale( scale*scale_change );
          newcube.transX( x + (scale * scale_change)/2 );
          newcube.transY( y - scale * scale_change );
          newcube.transZ( z + scale * 1/3 );
          shapes.add(newcube);
          duplicate_counter.add( false );
        }

        
        // Bottom
        //newcube = ml.load( "models/cube.obj" );
        //newcube.scale( scale*scale_change );
        //newcube.transX( x + scale * 1/3 );
        //newcube.transY( y + scale );
        //newcube.transZ( z + scale * 1/3 );
        //shapes.add(newcube);
        //duplicate_counter.add( false );

    
      }
    }
    

    
    int deleted = 0;
    // Delete cubes that are inside other cubes
    for ( int j = 0; j < shapes.size(); j++ ) {
      for ( int k = 0; k < shapes.size(); k++ ) {
        if ( j != k ) {
          
          Shape c1 = this.shapes.get(j);
          Shape c2 = this.shapes.get(k);

          float c1x = c1.vectors[0].x;
          float c1y = c1.vectors[0].y;
          float c1z = c1.vectors[0].z;

          float c2x = c2.vectors[0].x;
          float c2y = c2.vectors[0].y;
          float c2z = c2.vectors[0].z;

          float c1_scale = (float) Math.abs( shapes.get(j).vectors[0].x - shapes.get(j).vectors[4].x );
          float c2_scale = (float) Math.abs( shapes.get(k).vectors[0].x - shapes.get(k).vectors[4].x );

          float margin = 1;

          Boolean inside = false;

          if ( ( c1x > c2x - margin && c1x + c1_scale < c2x + c2_scale + margin ) || ( c2x > c1x - margin && c2x + c2_scale < c1x + c1_scale + margin ) ) {
            if ( ( c1y > c2y - margin && c1y + c1_scale < c2y + c2_scale + margin ) || ( c2y > c1y - margin && c2y + c2_scale < c1y + c1_scale + margin ) ) {
              if ( ( c1z > c2z - margin && c1z + c1_scale < c2z + c2_scale + margin  ) || ( c2z > c1z - margin && c2z + c2_scale < c1z + c1_scale + margin ) ) {
                inside = true;
              }  
            }
          }

          // If one is inside the other, then we need to delete the smallest one
          if ( inside ) {
            if ( c1_scale > c2_scale ) {
              this.shapes.remove(k);
              deleted++;
            } else {
              this.shapes.remove(j);
              deleted++;
            }
          }

        }
      }      
    }
  
  }
  */

  /*
  Box box = new Box();
  box.scale(1000);
  box.transX( -500 );
  box.transY( 0 );
  box.transZ( -450 );
  shapes.add( box );

  for ( int x = -50 - 300; x < 50 - 300; x += 10 ) {
    for ( int y = -25; y > -150; y -= 10 ) {
      for ( int z = -325; z < -275; z += 10 ) {
        nodes.add( new Node( x, y, z, 1750, 0, 0,0, new int[]{200,200,255} ) );
      }
    }
  }
  */

  /* Random Walker
  int x = 0;
  int y = 0;
  int z = 0;
  int step_size = 10;
  int walks = 2500;
  for ( int i = 0; i < walks; i++ ) {
    float x_r = random(0,100);
    float y_r = random(0,100);
    float z_r = random(0,100);
    if ( x_r < 33.33 ) {
      x -= step_size;
    } 
    else if ( x_r > 66.66 ) {
      x += step_size;
    }
    if ( y_r < 33.33 ) {
      y -= step_size;
    } 
    else if ( y_r > 66.66 ) {
      y += step_size;
    }
    if ( z_r < 33.33 ) {
      z -= step_size;
    } 
    else if ( z_r > 66.66 ) {
      z += step_size;
    }
    dots.add( new Dot( x, y, z, 4000, new int[]{ 255, 50, 50 } ) );
  }
  for ( int i = 0; i < walks; i++ ) {
    float x_r = random(0,100);
    float y_r = random(0,100);
    float z_r = random(0,100);
    if ( x_r < 33.33 ) {
      x -= step_size;
    } 
    else if ( x_r > 66.66 ) {
      x += step_size;
    }
    if ( y_r < 33.33 ) {
      y -= step_size;
    } 
    else if ( y_r > 66.66 ) {
      y += step_size;
    }
    if ( z_r < 33.33 ) {
      z -= step_size;
    } 
    else if ( z_r > 66.66 ) {
      z += step_size;
    }
    dots.add( new Dot( x, y, z, 4000, new int[]{ 50, 50, 255 } ) );
  }
  */

  /*
  Shape plane = new Plane( 25, 75 );
  plane.setColor(255,0,0);
  plane.transY(150);
  for ( int i = 0; i < plane.vectors.length; i++ ) {
    plane.vectors[i].y += random(-10,10);
  }
  shapes.add(plane);
  */

  /*
  ModelLoader ml = new ModelLoader();
  Shape sh = ml.load("models/sphere.obj");
  sh.setColor(255,255,255);
  sh.scale(100);
  shapes.add( sh );
  
  sh = ml.load("models/sphere.obj");
  sh.setColor(255,255,255);
  sh.scale(100);
  sh.transX(-230);
  sh.transZ(510);
  shapes.add( sh );
  
  sh = ml.load("models/sphere.obj");
  sh.setColor(255,255,255);
  sh.scale(100);
  sh.transX(50);
  sh.transZ(480);
  shapes.add( sh );
  */

  p = new Projector( shapes, dots, nodes, rays );
}

void draw() {
  
  // WAVES !!!!!!!!!!!!
  /*
  for ( int j = 0; j < 625; j += 25 ) {

    float scale = (float) j / 625;
    float rad = start_point + 7 * (float) Math.PI * scale;
    float cos = (float) Math.cos(rad);
    
    cos *= 50;

    for ( int i = 0; i < 25; i++ ) {
      shapes.get(0).vectors[i+j].y = cos;
    }
  }

  start_point += 0.01;
  */
  // - - - - - - - - - - -

  noStroke();
  fill(0);
  rect(0,0,1000,1000);
  
  if ( frame % 2 == 0 ) {
    mouse.updateMouse();
  }
  // KEYBOARD
  if (keyPressed) {
    inputHandler.handleKeypress();
  }

  // MOUSE
  if ( mousePressed ) {
    
    float[] MouseMovement = mouse.drag();
    SumXRotation += MouseMovement[1];
    SumYRotation += MouseMovement[0];

    if ( dots.size() != 0 ) {
      for ( Dot dot : dots ) {
        dot.position.rotXCamera( -MouseMovement[1], p );
        dot.position.rotYCamera( MouseMovement[0], SumXRotation, p );
      }
    }
    if ( attractors.size() != 0 ) {
      for ( Attractor attractor : attractors ) {
        attractor.position.rotXCamera( -MouseMovement[1], p );
        attractor.position.rotYCamera( MouseMovement[0], SumXRotation, p );
      }
    }
    if ( nodes.size() != 0 ) {
      for ( Node node : nodes ) {
        node.position.rotXCamera( -MouseMovement[1], p );
        node.position.rotYCamera( MouseMovement[0], SumXRotation, p );
        node.dir.rotX( -MouseMovement[1] );
        node.dir.rotLockedY( MouseMovement[0], SumXRotation ); 
      }
    }
    if ( rays.size() != 0 ) {
      for ( Ray ray : rays ) {
        // Rotate position
        for ( Vec3 vector : ray.vectors ) {
          vector.rotXCamera( -MouseMovement[1], p );
          vector.rotYCamera( MouseMovement[0], SumXRotation, p );
        }
        // Rotate directional vectors
        ray.dir.rotX( -MouseMovement[1] );
        ray.dir.rotLockedY( MouseMovement[0], SumXRotation );
      }
    }
    if ( shapes.size() != 0 ) {
      for ( Shape shape : shapes ) {
        shape.rotXCamera( -MouseMovement[1], p );
        shape.rotYCamera( MouseMovement[0], SumXRotation, p );
      }
    } 
    coord.rotX( -MouseMovement[1] );
    coord.rotLockedY( MouseMovement[0], SumXRotation );
    
  }

  //p.projectFaces( frame );
  p.projectShapes( "e" );
  //p.projectDots( frame );
  //p.projectNodes( frame );
  p.project( coord, "e" );
  //p.projectRay(rays);
  //p.projectAttractors( attractors );

  /* RAYTRACING
  if ( mouseButton == RIGHT && frame % 10 == 0 ) {

    rays.clear();
    raycaster.pixels.clear();
    
    float angle_offset = 45; 
    int resolution = 11;
    int rays_on_each_size = (resolution-1)/2;
    float y_angle_offset = - angle_offset;
    float y_angle_adder = (float) Math.abs(y_angle_offset/rays_on_each_size);
    Ray temp_ray;

    for ( int y = 0; y < resolution; y++ ) {

      float x_angle_offset = - angle_offset;
      float x_angle_adder = (float) Math.abs(x_angle_offset/rays_on_each_size);

      for ( int x = 0; x < resolution; x++ ) {
        temp_ray = new Ray(0,0,p.z);
        temp_ray.dir.rotLockedY( x_angle_offset, 0 );
        temp_ray.dir.rotX( y_angle_offset );
        x_angle_offset += x_angle_adder;
        rays.add(temp_ray);
      }

      y_angle_offset += y_angle_adder;
    }

    for ( Ray ray : rays ) {
      ray.dir.rotLockedY( -SumYRotation, SumXRotation );
      ray.dir.rotX( SumXRotation );
    }
    for ( Shape shape : shapes ) {
      shape.rotYCamera( -SumYRotation, SumXRotation, p );
      shape.rotXCamera( SumXRotation, p );
    }

    for ( Ray ray : rays ) {
      raycaster.setPixel( ray.cast(shapes) );
    }

    for ( Ray ray : rays ) {
      for ( Vec3 vector : ray.vectors ) {
        vector.rotYCamera( SumYRotation, 0, p );
        vector.rotXCamera( -SumXRotation, p );      
      }
    }
    
    for ( Shape shape : shapes ) {
      shape.rotYCamera( SumYRotation, 0, p );
      shape.rotXCamera( -SumXRotation, p );
    }

  }
  */
  //raycaster.render( 2000, 1000 );

  // Realign axis
  /*
  for ( Node node : nodes ) {
    node.position.rotYCamera( -SumYRotation, SumXRotation, p );
    node.position.rotXCamera( SumXRotation, p );
    node.dir.rotLockedY( -SumYRotation, SumXRotation ); 
    node.dir.rotX( SumXRotation );
  }
  for ( Shape shape : shapes ) {
    shape.rotYCamera( -SumYRotation, SumXRotation, p );
    shape.rotXCamera( SumXRotation, p );
  }*/

  /*
  for ( Attractor at : attractors ) {
    at.position.rotYCamera( -SumYRotation, SumXRotation, p );
    at.position.rotXCamera( SumXRotation, p );
  }
  for ( Node n : nodes ) {
    for ( Attractor a : attractors ) {
      n.attract_attractor( a );
    }
    n.move();
  }
  */

  /*
  for ( int i = 0; i < nodes.size(); i++ ) {
    for ( int n = 0; n < nodes.size(); n++ ) {
      if ( i != n ) {
        nodes.get(i).behaveAsLiquid( nodes.get(n) );
      }
    }
    nodes.get(i).moveLiquid( shapes );
  }
  
  // Unalign axis back to original state for rendering
  for ( Node node : nodes ) {
    node.position.rotYCamera( SumYRotation, 0, p );
    node.position.rotXCamera( -SumXRotation, p );
    node.dir.rotLockedY( SumYRotation, 0 ); 
    node.dir.rotX( -SumXRotation );
  }
  for ( Shape shape : shapes ) {
    shape.rotYCamera( SumYRotation, 0, p );
    shape.rotXCamera( -SumXRotation, p );
  }
  */

  /*
  for ( Attractor at : attractors ) {
    at.position.rotYCamera( SumYRotation, 0, p );
    at.position.rotXCamera( -SumXRotation, p );
  }
  */

  /*
  if ( mousePressed == true && mouseButton == RIGHT ) {
    if ( frame % 10 == 0 )
      nodes.add( new Node( 0, 0, p.z + 50, 1750, 0, 0, 2, new int[]{255,0,0} ) );
  }
  */

  // WAVES
  FLUID.simulate(1);

  for ( Shape shape : shapes ) {
    shape.rotYCamera( -SumYRotation, SumXRotation, p );
    shape.rotXCamera( SumXRotation, p );
  }

  FLUID.changeMesh();

  // Back
  for ( Shape shape : shapes ) {
    shape.rotYCamera( SumYRotation, 0, p );
    shape.rotXCamera( -SumXRotation, p );
  }

  //p.projectShapes( "e" );
  p.projectFaces( frame );

  for ( Shape shape : shapes ) {
    shape.rotYCamera( -SumYRotation, SumXRotation, p );
    shape.rotXCamera( SumXRotation, p );
  }

  FLUID.revertMesh();

  for ( Shape shape : shapes ) {
    shape.rotYCamera( SumYRotation, 0, p );
    shape.rotXCamera( -SumXRotation, p );
  }

  /*
  FLUID.grid.grid[10][20].force = 0.5;
  FLUID.grid.grid[10][20].rotation_trajection = 0;
  FLUID.grid.grid[10][20].x = 0;
  FLUID.grid.grid[10][20].y = -1;

  FLUID.grid.grid[20][5].force = 0.5;
  FLUID.grid.grid[20][5].rotation_trajection = 0;
  FLUID.grid.grid[20][5].x = -1;
  FLUID.grid.grid[20][5].y = 0;
  */


  // Crosshair
  /*
  noFill();
  stroke(0,255,0);
  strokeWeight(0.5);
  line( 500 - 5, 500, 500 + 5, 500 );
  line( 500, 500 - 5, 500, 500 + 5 );
  */
  
  //println( frameRate );
  frame++;
}
