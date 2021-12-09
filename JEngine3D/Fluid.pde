class Fluid extends Plane {

    int N;
    Grid grid;

    Fluid( int size, float length ) {
        super( size, length );
        grid = new Grid( size + 2 );
        this.N = size;
        this.setColor(255,255,255);
    }

    class Grid {
        Vector grid[][];
        int N;
        Grid( int n ) {
            this.N = n;
            this.grid = new Vector[n][n];
            int i, j;
            for ( i = 0; i < n; i++ ) {
                for ( j = 0; j < n; j++ ) {
                    float angle, scale;
                    angle = random( 0, 360 );
                    scale = random( 0.1, 0.5 );
                    this.grid[i][j] = new Vector(angle,scale);
                    //this.grid[i][j] = new Vector(0,0);
                }
            }
        }

        class Vector {
            public static final float SCALAR_DECAY = 1;
            public static final float FRICTION = 0.96;
            float x;
            float y;
            float force;
            float rotation_trajection = 0;

            Vector( float angle, float force ) {
                double rad = Math.PI/180*angle;
                this.x = (float) Math.cos(rad);
                this.y = (float) Math.sin(rad);
                this.force = force;
            }

            void free() {
                // Rotate with rotation trajectory
                float radians = (float) (Math.PI/180)*this.rotation_trajection;
                float nx = (float) (this.x * Math.cos(radians) - this.y * Math.sin(radians));
                float ny = (float) (this.x * Math.sin(radians) + this.y * Math.cos(radians));
                this.x = nx;
                this.y = ny;
                this.rotation_trajection *= this.FRICTION; // Apply friction to the angle trajectory
                this.force *= this.SCALAR_DECAY; // Decay the scalar
            }

            double angle() { // 0 -> 6.28
                double angle = Math.atan2(this.y,this.x);
                double mapped_angle = 0;
                // On the lower positive half of the circle 
                if ( angle > 0 ) {
                    mapped_angle = Math.atan2(this.y,this.x);
                }
                // On the upper negative side of the circle
                else {
                    double M_PI = Math.PI;
                    mapped_angle = M_PI + ( M_PI + Math.atan2(this.y,this.x) );
                }
                return mapped_angle;
            }

            void influence( Vector other ) {
                if ( this.force > 0.0005 ) {
                    // Calculate force difference for angle influence ( Exponential )

                    float force_multiplier;
                    if ( other.force != 0 ) {
                        force_multiplier = (float) /*Math.pow(*/this.force/other.force/*,2)*/; // + if this >= other force
                    }
                    else {
                        force_multiplier = (float) /*Math.pow(*/this.force/*,2)*/; // + if this >= other force
                    }

                    double angle_diff = similarity(other); // 0 = angle copy, 1 = opposite angle
                    double side_ratio = angle_diff;
                    if ( angle_diff > 0.5 )
                        side_ratio = ( 1 - angle_diff );
                    side_ratio = side_ratio / 0.5; // 0 - 1 - 0 => 0 - 90deg

                    // Rotation transfer
                    double TWO_PI = 2 * Math.PI;
                    double this_angle  = this.angle();
                    double other_angle = other.angle();
                    double right_travel, left_travel;

                    if ( other.force > 0.0025 ) {
                        if ( other_angle > this_angle ) {
                            // Calculate right travel
                            right_travel = other_angle - this_angle;
                            left_travel  = TWO_PI - other_angle + this_angle;
                            if ( right_travel < left_travel ) {
                                other.rotation_trajection -= (float) 1/20 * side_ratio * force_multiplier;
                            } else {
                                other.rotation_trajection += (float) 1/20 * side_ratio * force_multiplier;  
                            }
                        } else {
                            right_travel = other_angle + ( TWO_PI - this_angle );
                            left_travel  = this_angle - other_angle;
                            if ( right_travel < left_travel ) {
                                other.rotation_trajection -= (float) 1/20 * side_ratio * force_multiplier;
                            } else {
                                other.rotation_trajection += (float) 1/20 * side_ratio * force_multiplier;  
                            }
                        }
                    } else {
                        other.x = this.x;
                        other.y = this.y;
                    }
                    
                    // Similar angle vector force transfer
                    if ( angle_diff < 0.5 ) {
                        float growth_ratio = 1-(float)angle_diff*2;
                        float force_transfer_amount = this.force * 1/250 * growth_ratio;

                        if ( this.force > 0 ) {
                            this.force -= force_transfer_amount;
                            other.force += force_transfer_amount;
                        }

                    // Opposite angle vector force transer
                    } else {
                        float shrink_ratio = ((float)angle_diff-0.5)/0.5;
                        float force_transfer_amount = this.force * 1/250 * shrink_ratio;

                        if ( this.force > 0 && other.force > 0 ) {
                            this.force -= force_transfer_amount;
                            other.force -= force_transfer_amount;   
                        }
                    }

                }
            }

            double similarity(Vector other) { // 1 = no angle diff, 0 = opposite
                double M_PI = Math.PI;
                double this_angle = this.angle();
                double other_angle = other.angle();
                double angle_diff_rad = 0;
                if ( this_angle > other_angle ) {
                    angle_diff_rad = this_angle - other_angle;
                    if ( angle_diff_rad > M_PI ) {
                        angle_diff_rad = other_angle + ( 2*M_PI - this_angle );
                    }
                }
                else {
                    angle_diff_rad = other_angle - this_angle;
                    if ( angle_diff_rad > M_PI ) {
                        angle_diff_rad = this_angle + ( 2*M_PI - other_angle );
                    }
                }
                return angle_diff_rad/M_PI;
            }

            double length() {
                return Math.sqrt(this.x*this.x + this.y*this.y);
            }

            void rotate(float angle) {
                this.rotation_trajection += angle;
            }

        }

        int[] VectorDirectionToIndeces( Vector vector ) {
            float step_size = (float) (Math.PI*2)/8; 
            float positions[] = new float[]{0,0,0,0,0,0,0,0};
            for ( int i = 0; i < positions.length; i++ )
                positions[i] = step_size * i;
            int index = 0;
            float distance = Float.MAX_VALUE;
            for ( int i = 0; i < positions.length; i++ ) {
                float diff = Math.abs( (float) vector.angle() - positions[i] );
                if ( diff < distance ) {
                    distance = diff;
                    index = i;
                }
            }
            int vals[] = new int[3];
            if ( index == 0 ) {
                vals = new int[]{ 7, 0, 1 };
            } else if ( index == 7 ) {
                vals = new int[]{ 6, 7, 0 };
            } else {
                vals = new int[]{ index - 1, index, index + 1 };
            }
            return vals;
        }

        void run() {
            int n = this.grid.length;
            int i, j;
            for ( i = 1; i < n - 1; i++ ) {
                for ( j = 1; j < n - 1; j++ ) {
                    int[] indeces = this.VectorDirectionToIndeces(this.grid[i][j]);
                    for ( int index : indeces ) {

                        if ( index == 0 ) {
                            grid[i][j].influence( grid[i+1][j] );
                        }
                        else if ( index == 1 ) {
                            grid[i][j].influence( grid[i+1][j+1] );
                        }
                        else if ( index == 2 ) {
                            grid[i][j].influence( grid[i][j+1] );
                        }
                        else if ( index == 3 ) {
                            grid[i][j].influence( grid[i-1][j+1] );
                        }
                        else if ( index == 4 ) {
                            grid[i][j].influence( grid[i-1][j] );
                        }
                        else if ( index == 5 ) {
                            grid[i][j].influence( grid[i-1][j-1] );
                        }
                        else if ( index == 6 ) {
                            grid[i][j].influence( grid[i][j-1] );
                        }
                        else if ( index == 7 ) {
                            grid[i][j].influence( grid[i+1][j-1] );
                        }

                    }
                }
            }
        }

        void setVectorsFree() {
            int n = this.grid.length;
            int i, j;
            for ( i = 0; i < n; i++ ) {
                for ( j = 0; j < n; j++ ) {
                    grid[i][j].free();
                }
            }
        }
        
        void renderSquares() {
            noStroke();
            float step_size = 250 / this.N;
            int i, j;
            for ( i = 0; i < this.N; i++ ) {
                for ( j = 0; j < this.N; j++ ) {
                    float scale = this.grid[i][j].force;
                    if ( scale > 0 ) {
                        float f_val = (scale/0.2)*255;
                        fill(f_val);
                        rect( i * step_size, j * step_size, step_size + 1, step_size + 1 );
                    } 
                }
            }
        }
        
    }

    void simulate( int frames ) {
        for ( int i = 0; i < frames; i++ ) {
            grid.setVectorsFree();
            grid.run();
        }
    }

    void changeMesh() {
        int i, j, index;
        for ( i = 1; i < N - 1; i++ ) {
            for ( j = 1; j < N - 1; j++ ) {
                float force = (float) grid.grid[i][j].force * 200;
                this.vectors[ i + N * j ].y -= force ;
            }
        }
    }

    void revertMesh() {
        int i, j, index;
        for ( i = 1; i < N - 1; i++ ) {
            for ( j = 1; j < N - 1; j++ ) {
                float force = (float) grid.grid[i][j].force * 200;
                this.vectors[ i + N * j ].y += force;
            }
        }
    }

    @Override
    void render( float x_offset, float y_offset, String type, float z ) {
        // Render
        strokeWeight(1);
        for ( Edge e : this.edges ) {
            if ( e.v1.z > z && e.v2.z > z ) {
                e.render( x_offset, y_offset, z );
            }
        }
        this.grid.renderSquares();
    }
    
}
