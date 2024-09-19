// Parameters
inner_height = 50; // Inner height of the box
inner_width = 50;  // Inner width of the box
inner_depth = 50;  // Inner depth of the box
wall_thickness = 2; // Thickness of the outer wall
lid_height = 20; // Height of the lid
lid_box_overlap = 10; // Overlap height between lid and box
lid_wall_thickness = 2; // Thickness of the lid wall
printer_tolerance = 0.5; // Tolerance for the printer

// Outer dimensions
outer_height = inner_height + wall_thickness * 2;
outer_width = inner_width + wall_thickness * 2;
outer_depth = inner_depth + wall_thickness * 2;

// Create the outer box
module box() {
    difference() {
        // Full outer box
        cube([outer_width, outer_depth, outer_height], center = true);

        // Subtract the lid height minus the overlap from the box
        translate([0, 0, (outer_height - (lid_height - lid_box_overlap)) / 2])
            cube([outer_width, outer_depth, lid_height - lid_box_overlap], center = true);
        
        // Subtract inner space for the inner box
        translate([0, 0, 0])
            cube([inner_width, inner_depth, inner_height], center = true);

        // Remove the **outer** portion of the wall for the lid overlap region
        translate([0, 0, (outer_height - lid_height - lid_box_overlap) / 2])
            difference() {
                // Cut a larger cube (matching the external wall size)
                cube([outer_width, outer_depth, lid_box_overlap], center = true);

                // Subtract the part of the inner box plus **half** of the wall thickness
                translate([0, 0, 0])
                    cube([inner_width + wall_thickness - printer_tolerance/2, inner_depth + wall_thickness - printer_tolerance/2, lid_box_overlap], center = true);
            }
    }
}

// Create the sliding lid
module sliding_lid() {
    difference() {
        // Full outer box
        cube([outer_width, outer_depth, lid_height + wall_thickness], center = true);
        
        // Subtract inner space for the inner box leaving the wall_thickness at the top, but open at the bottom
        translate([0, 0, -wall_thickness])
            cube([inner_width, inner_depth, lid_height + wall_thickness], center = true);

        translate([0, 0,  -lid_height / 2 + lid_box_overlap / 2 - wall_thickness / 2])
            cube([outer_width - wall_thickness + printer_tolerance/2, outer_depth - wall_thickness + printer_tolerance/2, lid_box_overlap], center = true);
    }
}

// Position the box and lid
translate([0, 0, lid_height / 2 + outer_height / 2 + printer_tolerance])
sliding_lid();

box();
