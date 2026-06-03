// Generate walls
Walls = true;

//Generate vertical rails
Vertical_Rails = true;

//Generate horizontal rails
Horizontal_Rails = false;

/* [Vertical Rail ] */
// Height in U
U_Height = 5;

// Generate slot inserts for bolts
Slot_Insert = true;

// Thickness of the bolt nut (0.2mm tolerance will be added)
Nut_Thickness = 5;

// Add 0.2mm sacrificial layer over bolt holes (punch through after printing)
Sacrificial_Layer = true;

/* [Common ] */
// The depth of the acrylic or printed panel you wish to use, 0.5mm will be added to this for tollerances
Panel_Depth = 3;

/* [Horizontal Rail ] */
overall_panel_depth = Panel_Depth + 0.5;
// Handles - the width between the centre of the handle holes. Set to zero for no handles
Handles_Hole_Width = 127.5;

// Total Rack Depth - the total depth of the rack (beam length+ 70mm)
Total_Rack_Depth = 240;

/* [Hidden] */
Nut_Tolerance = 0.2;
M6_nut = 11.6;
M6_bolt_clearance = 7.0;


max_grid_width = Total_Rack_Depth-70;
max_grid_height = U_Height * 44.45;

module slotInsert() {
    difference() {
        union() {
            // Main plate
            cube([ U_Height * 44.45, 16, 2 ]);
            // Extensions filling the 2mm gap, with hex-shaped cutouts for the nuts
            difference() {
                translate([ 0, 0, 2 ]) cube([ U_Height * 44.45, 16, (Nut_Thickness + Nut_Tolerance) / 2 - 2 ]);
                for (i = [0 : 1 : U_Height]) {
                    translate([ 6.35 + (i * 44.45),           7, 2 + ((Nut_Thickness + Nut_Tolerance) / 2 - 2) / 2 ]) rotate([ 0, 0, 90 ]) elongated_hex(M6_nut + Nut_Tolerance, (Nut_Thickness + Nut_Tolerance) / 2 - 2);
                    translate([ 6.35 + 15.875 + (i * 44.45),  7, 2 + ((Nut_Thickness + Nut_Tolerance) / 2 - 2) / 2 ]) rotate([ 0, 0, 90 ]) elongated_hex(M6_nut + Nut_Tolerance, (Nut_Thickness + Nut_Tolerance) / 2 - 2);
                    translate([ 6.35 + 31.75 + (i * 44.45),   7, 2 + ((Nut_Thickness + Nut_Tolerance) / 2 - 2) / 2 ]) rotate([ 0, 0, 90 ]) elongated_hex(M6_nut + Nut_Tolerance, (Nut_Thickness + Nut_Tolerance) / 2 - 2);
                }
            }
        }
        // Bolt clearance holes through everything
        for (i = [0 : 1 : U_Height]) {
            translate([ 6.35 + (i * 44.45),           7, -1 ]) cylinder(h = Sacrificial_Layer ? 2.8 : 3, d = M6_bolt_clearance, $fn = 50);
            translate([ 6.35 + 15.875 + (i * 44.45),  7, -1 ]) cylinder(h = Sacrificial_Layer ? 2.8 : 3, d = M6_bolt_clearance, $fn = 50);
            translate([ 6.35 + 31.75 + (i * 44.45),   7, -1 ]) cylinder(h = Sacrificial_Layer ? 2.8 : 3, d = M6_bolt_clearance, $fn = 50);
        }
    }
}

module elongated_hex(d, h) {
    ext = d * sqrt(3) / 2;
    hull() {
        cylinder(h=h, d=d, center=true, $fn=6);
        translate([ -ext, 0, 0 ]) cylinder(h=h, d=d, center=true, $fn=6);
    }
}

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
        translate([ (length / 2) - (Handles_Hole_Width/2), 13.5, 26.5 ]) elongated_hex(M6_nut + Nut_Tolerance, 12);
        translate([ (length / 2) - (Handles_Hole_Width/2), 13.5, 32.5 ]) cylinder(h = 6, d = M6_bolt_clearance, center = true, $fn = 50);


        translate([ (length / 2) + (Handles_Hole_Width/2), 13.5, 26.5 ]) elongated_hex(M6_nut + Nut_Tolerance, 12);

         translate([ (length / 2) + (Handles_Hole_Width/2), 13.5, 32.5 ]) cylinder(h = 6, d = M6_bolt_clearance, center = true, $fn = 50);
        }
    }
}

module frontPostShape()
{
    difference() {
        
        baseShape(U_Height * 44.45);
        for (i = [0 : 1 : U_Height]) {  
            translate([ 6.35 + (i * 44.45), 7, 31 ]) rotate([ 0, 0, 90 ])
            if (Slot_Insert) elongated_hex(M6_nut + Nut_Tolerance, Nut_Thickness + Nut_Tolerance); else cylinder(h = Nut_Thickness + Nut_Tolerance, d = M6_nut + Nut_Tolerance, center = true, $fn = 6);
            translate([ 6.35 + (i * 44.45), 7, 32.5 ])
            cylinder(h = 50, d = M6_bolt_clearance, center = true, $fn = 50);

            translate([ 6.35 + 15.875 + (i * 44.45), 7, 31 ]) rotate([ 0, 0, 90 ])
            if (Slot_Insert) elongated_hex(M6_nut + Nut_Tolerance, Nut_Thickness + Nut_Tolerance); else cylinder(h = Nut_Thickness + Nut_Tolerance, d = M6_nut + Nut_Tolerance, center = true, $fn = 6);
            translate([ 6.35 + 15.875 + (i * 44.45), 7, 32.5 ])
            cylinder(h = 8, d = M6_bolt_clearance, center = true, $fn = 50);

            translate([ 6.35 + 31.75 + (i * 44.45), 7, 31 ]) rotate([ 0, 0, 90 ])
            if (Slot_Insert) elongated_hex(M6_nut + Nut_Tolerance, Nut_Thickness + Nut_Tolerance); else cylinder(h = Nut_Thickness + Nut_Tolerance, d = M6_nut + Nut_Tolerance, center = true, $fn = 6);
            translate([ 6.35 + 31.75 + (i * 44.45), 7, 32.5 ])
            cylinder(h = 8, d = M6_bolt_clearance, center = true, $fn = 50);
        }
    }
    
}

if (Horizontal_Rails) {
    rotate([ 180, 0, 0 ])
    translate([-(Total_Rack_Depth - 70) / 2, -15, -35])
    depthPostShape(Total_Rack_Depth - 70);
}

if (Vertical_Rails) {
    rotate([ 180, 0, 0 ])
    translate([-(Total_Rack_Depth - 70) / 2, 20, -35])
    frontPostShape();
}

if(Walls) {
    translate([(-max_grid_width-10),20,0])
   
    cube([ max_grid_width + 5, max_grid_height , Panel_Depth ]);

     translate([(10),20,0])
    cube([ max_grid_width + 5, 227, Panel_Depth ]);


}

if (Slot_Insert && Vertical_Rails) {
    rotate([ 180, 0, 0 ])
    translate([-(Total_Rack_Depth - 70) / 2, 20, -35])
    translate([ 0, 0, 29 - (Nut_Thickness + Nut_Tolerance) / 2 ])
    slotInsert();
}

// Credit: https://makerworld.com/en/models/1657249-customisable-posts-for-lab-rax-bolted-version?from=search#profileId-1752845`