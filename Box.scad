// Parameters
inner_height = 50; // Inner height of the box
inner_width = 60;  // Inner width of the box
inner_depth = 80;  // Inner depth of the box
wall_thickness = 2; // Thickness of the outer wall
lid_height = 25; // Height of the lid cut based on the inner box
lid_box_overlap = 10; // Overlap height between lid and box

printer_tolerance = 0.15; // Tolerance for the printer

// Outer dimensions
outer_height = inner_height + wall_thickness * 2;
outer_width = inner_width + wall_thickness * 2;
outer_depth = inner_depth + wall_thickness * 2;

chamfer_size=wall_thickness - wall_thickness * .2 ; // Size of the chamfer

module box() {
    
    difference() {
        translate([0, 0, outer_height / 2  - lid_height / 2  ])
            cube([outer_width, outer_depth, outer_height - lid_height], center = true);

        translate([0, 0, inner_height/2 + wall_thickness])
            cube([inner_width, inner_depth, inner_height], center = true);

        // Bottom Front Chamfer
        translate([-outer_width/2, outer_depth/2, -(chamfer_size*2 * sin(45)) / 2])
            rotate([45, 0, 0])
            cube([outer_width, chamfer_size, chamfer_size]);

        // Bottom Back Chamfer
        translate([-outer_width/2, -outer_depth/2, -(chamfer_size*2 * sin(45)) / 2])
            rotate([45, 0, 0])
            cube([outer_width, chamfer_size, chamfer_size]);

        // Bottom Left Chamfer
        translate([outer_width/2, -outer_depth/2, -(chamfer_size*2 * sin(45)) / 2])
            rotate([0, -45, 0])
            cube([chamfer_size, outer_depth, chamfer_size]);

        // Bottom Right Chamfer
        translate([-outer_width/2, -outer_depth/2, -(chamfer_size*2 * sin(45)) / 2])
            rotate([0, -45, 0])
            cube([chamfer_size, outer_depth, chamfer_size]);

        // Right Front Chamfer
        translate([outer_width/2, -outer_depth/2 - (chamfer_size*2 * sin(45)) / 2, 0])
            rotate([0, 0, 45])
            cube([chamfer_size, chamfer_size, outer_depth]);

        // Left Front Chamfer
        translate([-outer_width/2, -outer_depth/2 - (chamfer_size*2 * sin(45)) / 2, 0])
            rotate([0, 0, 45])
            cube([chamfer_size, chamfer_size, outer_depth]);

        // Right Back Chamfer
        translate([outer_width/2, outer_depth/2 + (chamfer_size*2 * sin(45)) / 2, 0])
            rotate([0, 0, 225])
            cube([chamfer_size, chamfer_size, outer_depth]);

        // Left Back Chamfer
        translate([-outer_width/2, outer_depth/2 + (chamfer_size*2 * sin(45)) / 2, 0])
            rotate([0, 0, 225])
            cube([chamfer_size, chamfer_size, outer_depth]);
        
    }

    difference() {
        translate([0, 0, outer_height - lid_height + lid_box_overlap / 2])
            cube([outer_width - wall_thickness - printer_tolerance/2, outer_depth - wall_thickness - printer_tolerance/2, lid_box_overlap], center = true);

        translate([0, 0, inner_height/2 + wall_thickness])
            cube([inner_width, inner_depth, inner_height], center = true);
    }
    
}

module sliding_lid() {

    translate([outer_width + 5, 0, lid_height /2])

        difference() {
            difference() {
                cube([outer_width, outer_depth, lid_height], center = true);       

                // Bottom Front Chamfer
                translate([-outer_width/2, outer_depth/2, -lid_height/2 -(chamfer_size*2 * sin(45)) / 2])
                    rotate([45, 0, 0])
                    cube([outer_width, chamfer_size, chamfer_size]);
                
                // Bottom Back Chamfer
                translate([-outer_width/2, -outer_depth/2, -lid_height/2 -(chamfer_size*2 * sin(45)) / 2])
                    rotate([45, 0, 0])
                    cube([outer_width, chamfer_size, chamfer_size]);

                // Bottom Left Chamfer
                translate([outer_width/2, -outer_depth/2, -lid_height/2 -(chamfer_size*2 * sin(45)) / 2])
                    rotate([0, -45, 0])
                    cube([chamfer_size, outer_depth, chamfer_size]);

                // Bottom Right Chamfer
                translate([-outer_width/2, -outer_depth/2, -lid_height/2 -(chamfer_size*2 * sin(45)) / 2])
                    rotate([0, -45, 0])
                    cube([chamfer_size, outer_depth, chamfer_size]);

                // Right Front Chamfer
                translate([outer_width/2, -outer_depth/2 - (chamfer_size*2 * sin(45)) / 2, -lid_height/2])
                    rotate([0, 0, 45])
                    cube([chamfer_size, chamfer_size, outer_depth]);

                // Left Front Chamfer
                translate([-outer_width/2, -outer_depth/2 - (chamfer_size*2 * sin(45)) / 2, -lid_height/2])
                    rotate([0, 0, 45])
                    cube([chamfer_size, chamfer_size, outer_depth]);

                // Right Back Chamfer
                translate([outer_width/2, outer_depth/2 + (chamfer_size*2 * sin(45)) / 2, -lid_height/2])
                    rotate([0, 0, 225])
                    cube([chamfer_size, chamfer_size, outer_depth]);

                // Left Back Chamfer
                translate([-outer_width/2, outer_depth/2 + (chamfer_size*2 * sin(45)) / 2, -lid_height/2])
                    rotate([0, 0, 225])
                    cube([chamfer_size, chamfer_size, outer_depth]);
            }

            translate([0, 0, wall_thickness])
                cube([inner_width, inner_depth, lid_height], center = true);
            
            translate([0, 0, lid_height/2 - lid_box_overlap/2])
                cube([inner_width + wall_thickness + printer_tolerance/2, inner_depth + wall_thickness + printer_tolerance/2, lid_box_overlap], center = true);
        }
        
}

sliding_lid();

box();
