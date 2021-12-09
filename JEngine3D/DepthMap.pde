class DepthMap {

	PImage image;
	int height;
	int width;
	int dimentions;

	void readImage( String file ) {
		this.image = loadImage( file );
		this.image.loadPixels();
		this.height = this.image.height;
		this.width = this.image.width;
		this.dimentions = this.height * this.width;
	}
	
	ArrayList getImage() {
		ArrayList<Dot> dots = new ArrayList();
    
		float depth = 50;
		float resolution = 3;
    
		int px = 0;
		int py = 0;
    
		for ( int x = 0; x < this.width; x += resolution ) {
			for ( int y = 0; y < this.height; y += resolution ) {
        
				int loc = x + y * this.width;
        
				int r = (int) red(this.image.pixels[loc]);
				int g = (int) green(this.image.pixels[loc]);
				int b = (int) blue(this.image.pixels[loc]);
        
				// If the pixel is not 100% black, render it
				if ( r + g + b > 75 ) {
					float depth_value = (float) (r+g+b)/(255*3);
					dots.add( new Dot( px - 100, py, - depth_value * depth, 500, new int[]{r,g,b} ) );
				}
				
				py++;
			}
			py = 0;
			px++;
		}

		return dots;
	}

}
