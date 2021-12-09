class Box extends Shape {

  Box() {
    
    this.type = "box";

    ArrayList<Edge> edges = new ArrayList();
    ArrayList<Face> faces = new ArrayList();
    
    Vec3 v1 = new Vec3( 0, 0, 0 );
    Vec3 v2 = new Vec3( 1, 0, 0 );
    Vec3 v3 = new Vec3( 1, 1, 0 );
    Vec3 v4 = new Vec3( 0, 1, 0 );
    
    Vec3 v5 = new Vec3( 0, 0, 1 );
    Vec3 v6 = new Vec3( 1, 0, 1 );
    Vec3 v7 = new Vec3( 1, 1, 1 );
    Vec3 v8 = new Vec3( 0, 1, 1 );

    this.vectors = new Vec3[]{ v1, v2, v3, v4, v5, v6, v7, v8 };
    
    edges.add( new Edge( v1, v2 ) );
    edges.add( new Edge( v2, v3 ) );
    edges.add( new Edge( v3, v4 ) );
    edges.add( new Edge( v1, v4 ) );
    
    edges.add( new Edge( v5, v6 ) );
    edges.add( new Edge( v6, v7 ) );
    edges.add( new Edge( v7, v8 ) );
    edges.add( new Edge( v5, v8 ) );
    
    edges.add( new Edge( v1, v5 ) );
    edges.add( new Edge( v2, v6 ) );
    edges.add( new Edge( v3, v7 ) );
    edges.add( new Edge( v4, v8 ) );
    
    this.edges = edges.toArray(new Edge[edges.size()]);
    
    faces.add( new Face( v4, v3, v2, v1 ) );
    faces.add( new Face( v5, v6, v7, v8 ) );
    faces.add( new Face( v1, v2, v6, v5 ) );
    faces.add( new Face( v8, v7, v3, v4 ) );
    faces.add( new Face( v3, v7, v6, v2 ) );
    faces.add( new Face( v1, v5, v8, v4 ) );

    this.faces = faces.toArray(new Face[faces.size()]);
  }

  
}
