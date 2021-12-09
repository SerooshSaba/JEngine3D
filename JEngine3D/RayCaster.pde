class RayCaster {

    int n;
    ArrayList<Pixel> pixels = new ArrayList();

    void setPixel( Pixel pixel ) {
        this.pixels.add( pixel );
    }

    void render( float xoffset, int size ) {
        
        noStroke();
        
        this.n = (int) Math.sqrt( pixels.size() );

        if ( this.pixels.size() != 0 ) {
            float step_len = size / this.n;
            
            for ( int x = 0; x < this.n; x++ ) {
                for ( int y = 0; y < this.n; y++ ) {

                    int loc = (this.n-x-1) + y * n;
                    Pixel pixel = this.pixels.get(loc);

                    fill( pixel.r, pixel.g, pixel.b );
                    square( xoffset + x * step_len, y * step_len, step_len );

                }
            }

        } else {
            fill(255,255,255);
            rect( xoffset, 0, size, size );
        }
    }

}
