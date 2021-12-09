class ImageReader {

    PImage im1;
    PImage im2;
    int dim;
    
    void read( String im1, String im2 ) {
        this.im1 = loadImage(im1);
        this.im2 = loadImage(im2);
        this.im1.loadPixels();
        this.im2.loadPixels();
        // Check dimention compatability
        if ( ( this.im1.width != this.im2.width ) || ( this.im2.height != this.im2.height ) ) {
            println( "The images are incompatible" );
            System.exit(0);
        }
        this.dim = this.im1.height * this.im1.width;
    }

    ArrayList convert() {

        ArrayList<Dot> dots = new ArrayList();

        // For hver horisontal linje i bilde1
        for ( int y = 0; y < this.im1.height; y++ ) {
            for ( int x = 0; x < this.im1.width; x++ ) {

				int loc = x + y * this.im1.width;

                // rgb values for pixel in image1
				int r_1 = (int) red(this.im1.pixels[loc]) + 1;
				int g_1 = (int) green(this.im1.pixels[loc]) + 1;
				int b_1 = (int) blue(this.im1.pixels[loc]) + 1;

                // Find the same pixel in the same y-level pixelstrip in image2
                // Find the corresponding pixel in image2
                int best_offset = 0;
                float best_match_perc = 0;

                for ( int im_x = 0; im_x < this.im2.width; im_x++ ) {

                    int loc2 = im_x + y * this.im2.width;
                    
                    // rgb values for pixel in image2
                    int r_2 = (int) red(this.im2.pixels[loc2]) + 1;
                    int g_2 = (int) green(this.im2.pixels[loc2]) + 1;
                    int b_2 = (int) blue(this.im2.pixels[loc2]) + 1;

                    // Check for match
                    float r_match = 0;
                    float g_match = 0;
                    float b_match = 0;

                    if ( r_1 > r_2 ) {
                        r_match = r_2 / r_1;
                    } else {
                        r_match = r_1 / r_2;
                    }

                    if ( g_1 > g_2 ) {
                        g_match = g_2 / g_1;
                    } else {
                        g_match = g_1 / g_2;
                    }

                    if ( b_1 > b_2 ) {
                        b_match = b_2 / b_1;
                    } else {
                        b_match = b_1 / b_2;
                    }

                    float match_perc = ( r_match + g_match + b_match ) / 3;

                    if ( match_perc > best_match_perc ) {
                        best_match_perc = match_perc;
                        best_offset = im_x;
                    }

                }

                println( best_match_perc, best_offset );
                if ( best_match_perc != 0 ) {
                    //if ( best_offset > 0 ) {
                        dots.add( new Dot( x, y, - 500 + ( x - best_offset ) / 5, 1000, new int[]{ r_1, g_1, b_1 } ) );
                    //}
                }

            }
        }
        
        return dots;
    }

}
