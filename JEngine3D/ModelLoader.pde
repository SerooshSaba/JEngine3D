class ModelLoader {

  Shape load( String filename ) {
        
    Shape shape = new Shape();
    ArrayList<Vec3> vectors = new ArrayList();
    ArrayList<Edge> edges = new ArrayList();
    ArrayList<Face> faces = new ArrayList();
    
    // Read file
    String[] lines = loadStrings( filename );

    // If a line has a "v " in it, then its a vector
    for ( int i = 0; i < lines.length; i++ ) {
      String line = lines[i];
      if ( line.indexOf("v ") != -1 ) {
        String[] splitted = line.split(" ");
        float x = Float.parseFloat(splitted[1]);
        float y = Float.parseFloat(splitted[2]);
        float z = Float.parseFloat(splitted[3]);
        vectors.add( new Vec3( x, y, z ) );
      }
    }
    // Make arraylist into an array    
    shape.vectors = vectors.toArray(new Vec3[vectors.size()]);        
    
    // If a line has a "f " in it, then its a face.
    for ( int i = 0; i < lines.length; i++ ) {
      String line = lines[i];
      if ( line.indexOf("f ") != -1 ) {
        String[] splitted = line.split(" ");
        // If there are three vectors in the edge
        if ( splitted.length == 4 ) {
          int i1 = Integer.parseInt(splitted[1]) - 1;
          int i2 = Integer.parseInt(splitted[2]) - 1;
          int i3 = Integer.parseInt(splitted[3]) - 1;
          faces.add( new Face( shape.vectors[i1], shape.vectors[i2], shape.vectors[i3] ) );
        }
        // If there are four vectors in the edge
        else {
          int i1 = Integer.parseInt(splitted[1]) - 1;
          int i2 = Integer.parseInt(splitted[2]) - 1;
          int i3 = Integer.parseInt(splitted[3]) - 1;
          int i4 = Integer.parseInt(splitted[4]) - 1;
          faces.add( new Face( shape.vectors[i1], shape.vectors[i2], shape.vectors[i3], shape.vectors[i4] ) );
        }
      }
    }
    shape.faces = faces.toArray(new Face[faces.size()]);        
    
    
    // Create Edges from faces
    for ( int i = 0; i < lines.length; i++ ) {
      String line = lines[i];
      if ( line.indexOf("f ") != -1 ) {
        String[] splitted = line.split(" ");
        // If there are three vectors in the edge
        if ( splitted.length == 4 ) {
          int i1 = Integer.parseInt(splitted[1]) - 1;
          int i2 = Integer.parseInt(splitted[2]) - 1;
          int i3 = Integer.parseInt(splitted[3]) - 1;
          edges.add( new Edge( shape.vectors[i1], shape.vectors[i2] ) );
          edges.add( new Edge( shape.vectors[i2], shape.vectors[i3] ) );
          edges.add( new Edge( shape.vectors[i3], shape.vectors[i1] ) );
        }
        // If there are four vectors in the edge
        else {
          int i1 = Integer.parseInt(splitted[1]) - 1;
          int i2 = Integer.parseInt(splitted[2]) - 1;
          int i3 = Integer.parseInt(splitted[3]) - 1;
          int i4 = Integer.parseInt(splitted[4]) - 1;
          edges.add( new Edge( shape.vectors[i1], shape.vectors[i2] ) );
          edges.add( new Edge( shape.vectors[i2], shape.vectors[i3] ) );
          edges.add( new Edge( shape.vectors[i3], shape.vectors[i4] ) );
          edges.add( new Edge( shape.vectors[i4], shape.vectors[i1] ) );
        }
      }
    }
    // Make arraylist into an array    
    shape.edges = edges.toArray(new Edge[edges.size()]);        
    
    return shape;
  }
  
}
