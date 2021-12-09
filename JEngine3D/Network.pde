class Network extends Shape {
    
    Network() {
        ArrayList<Vec3> vectors = new ArrayList();
        ArrayList<Edge> edges = new ArrayList();

        float scale = 100;
        float edge_creation_limit = 30;

        float x, y, z, vector_lenght, offset;
        
        // Create vectors
        for ( int i = 0; i < 200; i++ ) {
            // Create direction vector
            x = random( -100, 100 ) / 100;
            y = random( -100, 100 ) / 100;
            z = random( -100, 100 ) / 100;
            vector_lenght = (float) Math.sqrt( x*x + y*y + z*z );
            // Normalize
            x /= vector_lenght;
            y /= vector_lenght;
            z /= vector_lenght;
            offset = random( 0, scale );
            vectors.add( new Vec3( x * offset, y * offset, z * offset ) );
        }
        double xd, yd, zd, distance;
        // Create edges
        for ( int i = 0; i < vectors.size(); i++ ) {
            for ( int j = 0; j < vectors.size(); j++ ) {
                if ( i != j ) {
                    xd = Math.abs( vectors.get(i).x - vectors.get(j).x );
                    yd = Math.abs( vectors.get(i).y - vectors.get(j).y );
                    zd = Math.abs( vectors.get(i).z - vectors.get(j).z );
                    distance = Math.sqrt( xd*xd + yd*yd + zd*zd );
                    if ( distance < edge_creation_limit ) {
                        edges.add( new Edge( vectors.get(i), vectors.get(j) ) );
                    }
                }
            }
        }

        this.vectors = vectors.toArray(new Vec3[vectors.size()]);
        this.edges = edges.toArray(new Edge[edges.size()]);
    }

    @Override
    void render( float x_offset, float y_offset, String type, float z ) {
        strokeWeight(1);
        textSize(17.5);
        for ( int i = 0; i < this.edges.length; i++ ) {
            this.edges[i].render( x_offset, y_offset, z );
        }
    }

}
