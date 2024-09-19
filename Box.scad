// Parameters
inner_height = 20; // Inner height of the box
inner_width = 20;  // Inner width of the box
inner_depth = 20;  // Inner depth of the box
wall_thickness = 2; // Thickness of the outer wall
lid_height = 8; // Height of the lid
lid_box_overlap = 6; // Overlap height between lid and box
printer_tolerance = 0.15; // Tolerance for the printer

// Outer dimensions
outer_height = inner_height + wall_thickness * 2;
outer_width = inner_width + wall_thickness * 2;
outer_depth = inner_depth + wall_thickness * 2;

module box() {
    
    difference() {
        translate([0, 0, outer_height / 2  - lid_height / 2  ])
            cube([outer_width, outer_depth, outer_height - lid_height], center = true);

        translate([0, 0, inner_height/2 + wall_thickness])
            cube([inner_width, inner_depth, inner_height], center = true);
    }

    difference() {
        translate([0, 0, outer_height - lid_height + lid_box_overlap / 2])
            cube([outer_width - wall_thickness - printer_tolerance/2, outer_depth - wall_thickness - printer_tolerance/2, lid_box_overlap], center = true);

        translate([0, 0, inner_height/2 + wall_thickness])
            cube([inner_width, inner_depth, inner_height], center = true);
    }
    
}

module sliding_lid() {

    translate([outer_width + 5, 0, lid_height /2 + wall_thickness /2])

        difference() {
            cube([outer_width, outer_depth, lid_height + wall_thickness], center = true);            

            translate([0, 0, wall_thickness])
                cube([inner_width, inner_depth, lid_height + wall_thickness], center = true);
            
            translate([0, 0, lid_height/2 - lid_box_overlap/2 + wall_thickness/2])
                #cube([inner_width + wall_thickness + printer_tolerance/2, inner_depth + wall_thickness + printer_tolerance/2, lid_box_overlap], center = true);
        }
        
}

sliding_lid();

box();
