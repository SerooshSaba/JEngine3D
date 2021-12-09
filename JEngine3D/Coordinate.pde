class Coordinate extends Shape {
  
	Coordinate () {
		ArrayList<Vec3> vectors = new ArrayList();
    	ArrayList<Edge> edges = new ArrayList();
		Vec3 v1 = new Vec3( 0,   0, 0 );
		Vec3 v2 = new Vec3( 100, 0, 0 ); // X
		Vec3 v3 = new Vec3( 0, 100, 0 ); // Y
		Vec3 v4 = new Vec3( 0, 0, 100 ); // Z
		this.vectors = new Vec3[]{ v1, v2, v3, v4 };
		edges.add( new Edge( v1, v2, new int[]{ 255, 0, 0 } ) );
		edges.add( new Edge( v1, v3, new int[]{ 0, 255, 0 } ) );
		edges.add( new Edge( v1, v4, new int[]{ 0, 0, 255 } ) );
		this.edges = edges.toArray(new Edge[edges.size()]);
	}

	float[] getX() {
		float speed = 1000;
		return new float[]{ this.vectors[1].x / speed, this.vectors[1].y / speed, this.vectors[1].z / speed };
	}

	@Override
	void render( float x_offset, float y_offset, String type, float z ) {
		strokeWeight(3);
		textSize(17.5);
		for ( int i = 0; i < this.edges.length; i++ ) {
			this.edges[i].render( x_offset - 350, y_offset + 350, z );
		}
		fill(255,0,0);
		text("x", this.edges[0].v2.x + x_offset - 350, this.edges[0].v2.y + y_offset + 350 );        
		fill(0,255,0);
		text("y", this.edges[1].v2.x + x_offset - 350, this.edges[1].v2.y + y_offset + 350 );
		fill(0,0,255);
		text("z", this.edges[2].v2.x + x_offset - 350, this.edges[2].v2.y + y_offset + 350 );
	}
  
}
