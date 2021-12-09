class Ray {

    // For ray rendering
    Vec3[] vectors;
    Edge[] edges;

    // Position and direction
    Vec3 position;
    Vec3 dir = new Vec3( 0, 0, 1 );

    // Ray color
    float r = 255;
    float g = 255;
    float b = 255;

    // Scatter length
    int max_steps = 500;
    float step_length = 5;

    Ray( float x, float y, float z ) {
        this.position = new Vec3( x, y, z );
    }

    Pixel cast( ArrayList<Shape> obsticles ) {

        ArrayList<Vec3> hits = new ArrayList();
        hits.add( this.position );
        
        float traveled_distance = 0;

        int step_reducer = 0;
        
        float box_x, box_y, box_z, size;
        float ray_x, ray_y, ray_z;
        double xd, yd, zd;
        float jump_back_x, jump_back_y, jump_back_z;

        // Loop ray trough its path
        for ( int i = 0; i < this.max_steps; i++ ) {
            
            if ( hits.size() == 3 )
                break;

            ray_x = hits.get(hits.size()-1).x + this.dir.x * this.step_length * ( i - step_reducer );
            ray_y = hits.get(hits.size()-1).y + this.dir.y * this.step_length * ( i - step_reducer );
            ray_z = hits.get(hits.size()-1).z + this.dir.z * this.step_length * ( i - step_reducer );

            // Check for box ray interaction
            for ( Shape obsticle : obsticles ) {
                
                if ( obsticle.type == "sphere" ) {
                    
                    // Sphere size and position
                    float radius = Math.abs(obsticle.vectors[0].y - obsticle.vectors[6].y) / 2;
                    float centerX = obsticle.vectors[0].x;
                    float centerY = obsticle.vectors[0].y - radius;
                    float centerZ = obsticle.vectors[0].z;

                    // Distance from center
                    xd = Math.abs( ray_x - centerX );
                    yd = Math.abs( ray_y - centerY );
                    zd = Math.abs( ray_z - centerZ );
                    float distance = (float) Math.sqrt( xd*xd + yd*yd + zd*zd );
                    
                    // Hit detection
                    if ( distance < radius ) {
                        
                        // Reduce step
                        step_reducer = i;

                        // Refine position
                        float inside_radius_diff = radius - distance;
                        ray_x -= this.dir.x * this.step_length;
                        ray_y -= this.dir.y * this.step_length;
                        ray_z -= this.dir.z * this.step_length;
                        xd = Math.abs( ray_x - centerX );
                        yd = Math.abs( ray_y - centerY );
                        zd = Math.abs( ray_z - centerZ );
                        float outside_radius_diff = (float) Math.sqrt( xd*xd + yd*yd + zd*zd ) - radius;
                        float ratio = outside_radius_diff / ( outside_radius_diff + inside_radius_diff );
                        ray_x += this.dir.x * this.step_length * ratio;
                        ray_y += this.dir.y * this.step_length * ratio;
                        ray_z += this.dir.z * this.step_length * ratio;

                        // Reflect ray
                        float xDir = ray_x - centerX;
                        float yDir = ray_y - centerY;
                        float zDir = ray_z - centerZ;
                        float len = (float) Math.sqrt( xDir*xDir + yDir*yDir + zDir*zDir );
                        xDir /= len;
                        yDir /= len;
                        zDir /= len;
                        this.dir.x += xDir;
                        this.dir.y += yDir;
                        this.dir.z += zDir;

                        // Create vector in the hit arraylist
                        Vec3 hit_position = new Vec3( ray_x, ray_y, ray_z );
                        hits.add( hit_position );

                        // Get color of surface
                        if ( this.r == 255 & this.g == 255 && this.b == 255 ) {
                            this.r = obsticle.shade[0];
                            this.g = obsticle.shade[1];
                            this.b = obsticle.shade[2];
                        } else {
                            this.r = this.r * 0.5 + obsticle.shade[0] * 0.5;
                            this.g = this.g * 0.5 + obsticle.shade[1] * 0.5;
                            this.b = this.b * 0.5 + obsticle.shade[2] * 0.5;
                        }

                    }

                }

                else if ( obsticle.type == "box" ) {

                    // Box position and dimentions
                    box_x = obsticle.vectors[0].x;
                    box_y = obsticle.vectors[0].y;
                    box_z = obsticle.vectors[0].z;
                    size = Math.abs( box_x - obsticle.vectors[1].x );
                    
                    // Check for interaction
                    if ( ray_x > box_x && ray_x < box_x + size ) { 
                        if ( ray_y > box_y && ray_y < box_y + size ) { 
                            if ( ray_z > box_z && ray_z < box_z + size ) { 

                                // If we got a hit
                                // Set the step reducer
                                step_reducer = i;
                                
                                // Find what plane was hit and deflect the ray
                                jump_back_x = ray_x - this.dir.x * this.step_length;
                                jump_back_y = ray_y - this.dir.y * this.step_length;
                                jump_back_z = ray_z - this.dir.z * this.step_length;
                                
                                if ( jump_back_x < box_x || jump_back_x > box_x + size ) {
                                    this.dir.x *= -1;
                                }

                                else if ( jump_back_y < box_y || jump_back_y > box_y + size ) {
                                    this.dir.y *= -1;
                                }

                                else if ( jump_back_z < box_z || jump_back_z > box_z + size ) {
                                    this.dir.z *= -1;
                                }

                                // Create vector in the hit arraylist
                                Vec3 hit_position = new Vec3( ray_x, ray_y, ray_z );
                                hits.add( hit_position );
                                
                                // Get color of surface
                                if ( this.r == 255 & this.g == 255 && this.b == 255 ) {
                                    this.r = obsticle.shade[0];
                                    this.g = obsticle.shade[1];
                                    this.b = obsticle.shade[2];
                                } else {
                                    this.r = this.r * 0.5 + obsticle.shade[0] * 0.5;
                                    this.g = this.g * 0.5 + obsticle.shade[1] * 0.5;
                                    this.b = this.b * 0.5 + obsticle.shade[2] * 0.5;
                                }

                            }
                        }
                    }
                }
            }
            
            // If the loop runs out
            if ( i + 1 == this.max_steps ) {
                Vec3 hit_position = new Vec3( ray_x, ray_y, ray_z );
                hits.add( hit_position );
            }

        }

        // Calculate total distance traveled
        if ( hits.size() == 2 ) {
            traveled_distance = this.max_steps * this.step_length;
        } else {
            for ( int i = 1; i < hits.size() - 1; i++ ) {
                float xdf = Math.abs( hits.get(i-1).x - hits.get(i).x );
                float ydf = Math.abs( hits.get(i-1).y - hits.get(i).y );
                float zdf = Math.abs( hits.get(i-1).z - hits.get(i).z );
                traveled_distance += (float) Math.sqrt( xdf*xdf + ydf*ydf + zdf*zdf );
            }
        }

        // Set vectors
        this.vectors = new Vec3[hits.size()];
        for ( int i = 0; i < hits.size(); i++ ) {
            this.vectors[i] = hits.get(i);
        }

        // Create edges from the hit vectors
        this.edges = new Edge[hits.size()-1];        
        for ( int i = 1; i < hits.size(); i++ ) {
            this.edges[i-1] = new Edge( hits.get(i-1), hits.get(i) );
        }

        float shader = 1;// 1 - traveled_distance/this.max_steps*this.step_length;
        return new Pixel( this.r * shader, this.g * shader, this.b * shader );
    }

    void render( float x, float y, float z ) {
        strokeWeight(1);
        for ( Edge edge : this.edges )
            edge.render( x, y, z );
    }

}
