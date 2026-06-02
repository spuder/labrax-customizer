
// Total Rack Depth - the total depth of the rack (beam length+ 70mm)
Total_Rack_Depth = 240;

// Handles - the width between the centre of the handle holes. Set to zero for no handles
Handles_Hole_Width = 127.5;

// Height in U
U_Height = 5;

// Generate walls
Walls = true;



// The depth of the acrylic or printed panel you wish to use, 0.5mm will be added to this for tollerances
Panel_Depth = 3;



overall_panel_depth = Panel_Depth + 0.5;

/* [Hidden] */
M6_nut = 11.6;
M6_bolt_clearance = 7.0;
//Brass Insert Hole Diameter - The hole to create for the brass inserts, can depend on your printer and the type of material in use, as well as the insert type
Brass_Insert_Hole_Diameter = 7.5;

max_grid_width = Total_Rack_Depth-70;
max_grid_height = U_Height * 44.45;

module baseShape(length = 170)
{
   
    union()
    {
        difference()
        {
            // Base part
            cube([ length, 30, 35 ]);

            // Vertical parts and slots
            translate([ -1, -1, -1 ]) cube([ length + 5, 17, 30 ]);

            translate([ -1, 25, -1 ]) cube([ length + 5, overall_panel_depth, 4.5 ]);

 

            translate([ -1, 10, -1 ]) cube([ 21, 13, 25 ]);

            translate([ length - 20, 10, -1 ]) cube([ 21, 13, 25 ]);

            // Circular holes at each end
            translate([ 10, 25, 12.5 ]) rotate([ 90, 0, 0 ]) cylinder(h = 15, d = M6_bolt_clearance, center = true, $fn = 50);

            translate([ 10, 29, 12.5 ]) rotate([ 90, 0, 0 ]) cylinder(h = 4, d = M6_nut, center = true, $fn = 50);

            translate([ length - 10, 25, 12.5 ]) rotate([ 90, 0, 0 ]) cylinder(h = 15, d = M6_bolt_clearance, center = true, $fn = 50);

            translate([ length - 10, 29, 12.5 ]) rotate([ 90, 0, 0 ]) cylinder(h = 4, d = M6_nut, center = true, $fn = 50);

            // External fillet
            difference()
            {
                union()
                {
                    translate([ length/2, 27.5, 32.5 ]) rotate([ 0, 90, 0 ])
                        cylinder(h = length+0.1, d = 5, center = true, $fn = 50);

                    translate([ 0, 27.5, 32.5 ]) cube([ length+1, 5.01, 5.01 ]);
                }
                translate([ (length/2)-0.1, 27.5, 32.5 ]) rotate([ 0, 90, 0 ])
                    cylinder(h = length+1, d = 5.01, center = true, $fn = 50);
            }
        }
        // Internal filler
        translate([ length/2, -14, -6 ])
        {
            difference()
            {
                union()
                {
                    translate([ 0, 27.5, 32.5 ]) rotate([ 0, 90, 0 ])
                        cylinder(h = length, d = 5, center = true, $fn = 50);

                    translate([ -length/2, 27.5, 32.5 ]) cube([ length, 5.01, 5.01 ]);
                }
                translate([ 0, 27.5, 32.5 ]) rotate([ 0, 90, 0 ])
                    cylinder(h = length + 0.1, d = 5.01, center = true, $fn = 50);
            }
        }
    }
        
}


module depthPostShape(length = 170)
{
    difference() {
        
        baseShape(length);
        translate([ -1, -1, +30.25 ]) cube([ length + 5, 4.5, overall_panel_depth ]);
             
        
            
        if (length > Handles_Hole_Width + 20) {
        // Bottom face holes for handles
        translate([ (length / 2) - (Handles_Hole_Width/2), 13.5, 26.5 ]) cylinder(h = 12, d = M6_nut, center = true, $fn = 6);
        translate([ (length / 2) - (Handles_Hole_Width/2), 13.5, 32.5 ]) cylinder(h = 6, d = M6_bolt_clearance, center = true, $fn = 50);


        translate([ (length / 2) + (Handles_Hole_Width/2), 13.5, 26.5 ]) cylinder(h = 12, d = M6_nut, center = true, $fn = 6);

         translate([ (length / 2) + (Handles_Hole_Width/2), 13.5, 32.5 ]) cylinder(h = 6, d = M6_bolt_clearance, center = true, $fn = 50);
        }
    }
}

module frontPostShape()
{
    difference() {
        
        baseShape(U_Height * 44.45);
        for (i = [0 : 1 : U_Height]) {  
            translate([ 6.35 + (i * 44.45), 7, 31 ])             rotate([ 0, 0, 90 ])
            cylinder(h = 4, d = M6_nut, center = true, $fn = 6);
            
             translate([ 6.35 + (i * 44.45), 7, 32.5 ])             
            cylinder(h = 50, d = M6_bolt_clearance, center = true, $fn = 50);

       
            translate([ 6.35 +15.875+ (i * 44.45), 7, 31 ])       rotate([ 0, 0, 90 ])
            cylinder(h = 4, d = M6_nut, center = true, $fn = 6);
            translate([ 6.35 +15.875+ (i * 44.45), 7, 32.5 ])     
            cylinder(h = 8, d = M6_bolt_clearance, center = true, $fn = 50);
            



            translate([ 6.35 + 15.875+ 15.875+(i * 44.45), 7, 31 ]) 
            rotate([ 0, 0, 90 ])
            cylinder(h = 4, d = M6_nut, center = true, $fn = 6);
            translate([ 6.35 + 15.875+ 15.875+(i * 44.45), 7, 32.5 ])
            cylinder (h = 8, d = M6_bolt_clearance, center = true, $fn = 50);
        }
    }
    
}


rotate([ 180, 0, 0 ])
translate([-(Total_Rack_Depth - 70) / 2, -15, -35])
depthPostShape(Total_Rack_Depth - 70);

rotate([ 180, 0, 0 ])
translate([-(Total_Rack_Depth - 70) / 2, 20, -35])
frontPostShape();


if(Walls) {
    translate([(-max_grid_width-10),20,0])
   
    cube([ max_grid_width + 5, max_grid_height , Panel_Depth ]);

     translate([(10),20,0])
    cube([ max_grid_width + 5, 227, Panel_Depth ]);


}

// Credit: https://makerworld.com/en/models/1657249-customisable-posts-for-lab-rax-bolted-version?from=search#profileId-1752845