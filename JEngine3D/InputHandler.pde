class InputHandler {

    float userSpeed = 3;

    ArrayList<Face> faces;

    ArrayList<Shape> shapes;
    ArrayList<Dot> dots;
    ArrayList<Attractor> attractors;
    ArrayList<Node> nodes;
    ArrayList<Ray> rays;

    public InputHandler( ArrayList<Shape> shapes, ArrayList<Dot> dots, ArrayList<Attractor> attractors, ArrayList<Node> nodes, ArrayList<Ray> rays ) {
        this.shapes = shapes;
        this.dots = dots;
        this.attractors = attractors;
        this.nodes = nodes;
        this.rays = rays;
    }

    void handleKeypress() {

        // Dots
        if ( dots.size() != 0 ) {

            if ( key == 'w' ) {
                for ( int i = 0; i < dots.size(); i++ ) {
                    dots.get(i).position.transZ(-userSpeed);
                }
            }
            else if ( key == 'a' ) {
                for ( int i = 0; i < dots.size(); i++ ) {
                    dots.get(i).position.transX(userSpeed);
                }
            }
            else if ( key == 's' ) {
                for ( int i = 0; i < dots.size(); i++ ) {
                    dots.get(i).position.transZ(userSpeed);
                }
            }
            else if ( key == 'd' ) {
                for ( int i = 0; i < dots.size(); i++ ) {
                    dots.get(i).position.transX(-userSpeed);
                }
            }
            // Ascend Decent
            else if ( key == 'e' ) {
                for ( int i = 0; i < dots.size(); i++ ) {
                dots.get(i).position.transY(userSpeed);
                }
            }
            else if ( key == 'q' ) {
                for ( int i = 0; i < dots.size(); i++ ) {
                dots.get(i).position.transY(-userSpeed);
                }
            }
        }

        // Attractor
        if ( attractors.size() != 0 ) {

            if ( key == 'w' ) {
                for ( int i = 0; i < attractors.size(); i++ ) {
                    attractors.get(i).position.transZ(-userSpeed);
                }
            }
            else if ( key == 'a' ) {
                for ( int i = 0; i < attractors.size(); i++ ) {
                    attractors.get(i).position.transX(userSpeed);
                }
            }
            else if ( key == 's' ) {
                for ( int i = 0; i < attractors.size(); i++ ) {
                    attractors.get(i).position.transZ(userSpeed);
                }
            }
            else if ( key == 'd' ) {
                for ( int i = 0; i < attractors.size(); i++ ) {
                    attractors.get(i).position.transX(-userSpeed);
                }
            }
            // Ascend Decent
            else if ( key == 'e' ) {
                for ( int i = 0; i < attractors.size(); i++ ) {
                    attractors.get(i).position.transY(userSpeed);
                }
            }
            else if ( key == 'q' ) {
                for ( int i = 0; i < attractors.size(); i++ ) {
                    attractors.get(i).position.transY(-userSpeed);
                }
            }
        }
        
        // SHAPES
        if ( shapes.size() != 0 ) {

            if ( key == 'w' ) {
                for ( int i = 0; i < shapes.size(); i++ ) {
                    shapes.get(i).transZ(-userSpeed);
                }
            }
            else if ( key == 'a' ) {
                for ( int i = 0; i < shapes.size(); i++ ) {
                    shapes.get(i).transX(userSpeed);
                }
            }
            else if ( key == 's' ) {
                for ( int i = 0; i < shapes.size(); i++ ) {
                    shapes.get(i).transZ(userSpeed);
                }
            }
            else if ( key == 'd' ) {
                for ( int i = 0; i < shapes.size(); i++ ) {
                    shapes.get(i).transX(-userSpeed);
                }
            }

            // Ascend Decent
            else if ( key == 'e' ) {
                for ( int i = 0; i < shapes.size(); i++ ) {
                shapes.get(i).transY(userSpeed);
                }
            }
            else if ( key == 'q' ) {
                for ( int i = 0; i < shapes.size(); i++ ) {
                shapes.get(i).transY(-userSpeed);
                }
            }
        }
        
        // Nodes
        if ( nodes.size() != 0 ) {

            if ( key == 'w' ) {
                for ( int i = 0; i < nodes.size(); i++ ) {
                    nodes.get(i).position.transZ(-userSpeed);
                }
            }
            else if ( key == 'a' ) {
                for ( int i = 0; i < nodes.size(); i++ ) {
                    nodes.get(i).position.transX(userSpeed);
                }
            }
            else if ( key == 's' ) {
                for ( int i = 0; i < nodes.size(); i++ ) {
                    nodes.get(i).position.transZ(userSpeed);
                }
            }
            else if ( key == 'd' ) {
                for ( int i = 0; i < nodes.size(); i++ ) {
                    nodes.get(i).position.transX(-userSpeed);
                }
            }
            // Ascend Decent
            else if ( key == 'e' ) {
                for ( int i = 0; i < nodes.size(); i++ ) {
                nodes.get(i).position.transY(userSpeed);
                }
            }
            else if ( key == 'q' ) {
                for ( int i = 0; i < nodes.size(); i++ ) {
                nodes.get(i).position.transY(-userSpeed);
                }
            }
        }

        // Rays
        if ( rays.size() != 0 ) {
            if ( key == 'w' ) {
                for ( int i = 0; i < rays.size(); i++ ) {
                    for ( Vec3 vector : rays.get(i).vectors )
                        vector.transZ(-userSpeed);
                }
            }
            else if ( key == 'a' ) {
                for ( int i = 0; i < rays.size(); i++ ) {
                    for ( Vec3 vector : rays.get(i).vectors )
                        vector.transX(userSpeed);
                }
            }
            else if ( key == 's' ) {
                for ( int i = 0; i < rays.size(); i++ ) {
                    for ( Vec3 vector : rays.get(i).vectors )
                        vector.transZ(userSpeed);
                }
            }
            else if ( key == 'd' ) {
                for ( int i = 0; i < rays.size(); i++ ) {
                    for ( Vec3 vector : rays.get(i).vectors )
                        vector.transX(-userSpeed);
                }
            }
            // Ascend Decent
            else if ( key == 'e' ) {
                for ( int i = 0; i < rays.size(); i++ ) {
                    for ( Vec3 vector : rays.get(i).vectors )
                        vector.transY(userSpeed);
                }
            }
            else if ( key == 'q' ) {
                for ( int i = 0; i < rays.size(); i++ ) {
                    for ( Vec3 vector : rays.get(i).vectors )
                        vector.transY(-userSpeed);
                }
            }
        }
        
        
        // Projector z-depth adjustment
        if ( key == ',' ) {
            p.z += 5;
            println(p.z);
        }
        else if ( key == '.' ) {
            p.z -= 5;
            println(p.z);
        }

    }

}