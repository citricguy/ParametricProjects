/* ********************************************************************* *\
    This box is ment to be dimentionally accurate on the interior.

    The outer dimensions are calculated based on the inner dimensions, 
    your printers tolerance setting and wall thickness.
\* ********************************************************************* */

// Parameters
inner_height = 30; // Inner height of the box
inner_width = 30;  // Inner width of the box
inner_depth = 30;  // Inner depth of the box

wall_thickness = 2; // Thickness of the outer wall
lid_height = 5; // Height of the lid cut based on the inner box
lid_box_overlap = 3; // Overlap height between lid and box
apply_chamfer = 1; // Set to 1 to apply chamfer, 0 to disable
printer_tolerance = 0.18; // Tolerance for the printer

// Adjusted inner dimensions accounting for printer tolerance
adjusted_inner_height = inner_height + printer_tolerance;
adjusted_inner_width = inner_width + printer_tolerance;
adjusted_inner_depth = inner_depth + printer_tolerance;

// Outer dimensions
outer_height = adjusted_inner_height + wall_thickness * 2;
outer_width = adjusted_inner_width + wall_thickness * 2;
outer_depth = adjusted_inner_depth + wall_thickness * 2;

chamfer_size = wall_thickness - wall_thickness * .2; // Size of the chamfer

module box() {
    
    difference() {
        translate([0, 0, outer_height / 2 - lid_height / 2])
            cube([outer_width, outer_depth, outer_height - lid_height], center = true);

        translate([0, 0, adjusted_inner_height / 2 + wall_thickness])
            cube([adjusted_inner_width, adjusted_inner_depth, adjusted_inner_height], center = true);

        if (apply_chamfer) {
            // Bottom Front Chamfer
            translate([-outer_width / 2, outer_depth / 2, -(chamfer_size * 2 * sin(45)) / 2])
                rotate([45, 0, 0])
                cube([outer_width, chamfer_size, chamfer_size]);

            // Bottom Back Chamfer
            translate([-outer_width / 2, -outer_depth / 2, -(chamfer_size * 2 * sin(45)) / 2])
                rotate([45, 0, 0])
                cube([outer_width, chamfer_size, chamfer_size]);

            // Bottom Left Chamfer
            translate([outer_width / 2, -outer_depth / 2, -(chamfer_size * 2 * sin(45)) / 2])
                rotate([0, -45, 0])
                cube([chamfer_size, outer_depth, chamfer_size]);

            // Bottom Right Chamfer
            translate([-outer_width / 2, -outer_depth / 2, -(chamfer_size * 2 * sin(45)) / 2])
                rotate([0, -45, 0])
                cube([chamfer_size, outer_depth, chamfer_size]);

            // Right Front Chamfer
            translate([outer_width / 2, -outer_depth / 2 - (chamfer_size * 2 * sin(45)) / 2, 0])
                rotate([0, 0, 45])
                cube([chamfer_size, chamfer_size, outer_depth]);

            // Left Front Chamfer
            translate([-outer_width / 2, -outer_depth / 2 - (chamfer_size * 2 * sin(45)) / 2, 0])
                rotate([0, 0, 45])
                cube([chamfer_size, chamfer_size, outer_depth]);

            // Right Back Chamfer
            translate([outer_width / 2, outer_depth / 2 + (chamfer_size * 2 * sin(45)) / 2, 0])
                rotate([0, 0, 225])
                cube([chamfer_size, chamfer_size, outer_depth]);

            // Left Back Chamfer
            translate([-outer_width / 2, outer_depth / 2 + (chamfer_size * 2 * sin(45)) / 2, 0])
                rotate([0, 0, 225])
                cube([chamfer_size, chamfer_size, outer_depth]);
        }
    }

    difference() {
        translate([0, 0, outer_height - lid_height + lid_box_overlap / 2])
            cube([outer_width - wall_thickness - printer_tolerance / 2, outer_depth - wall_thickness - printer_tolerance / 2, lid_box_overlap], center = true);

        translate([0, 0, adjusted_inner_height / 2 + wall_thickness])
            cube([adjusted_inner_width, adjusted_inner_depth, adjusted_inner_height], center = true);
    }
}

module sliding_lid() {
    translate([outer_width + 5, 0, lid_height / 2])
        difference() {
            difference() {
                cube([outer_width, outer_depth, lid_height], center = true);

                if (apply_chamfer) {
                    // Bottom Front Chamfer
                    translate([-outer_width / 2, outer_depth / 2, -lid_height / 2 - (chamfer_size * 2 * sin(45)) / 2])
                        rotate([45, 0, 0])
                        cube([outer_width, chamfer_size, chamfer_size]);

                    // Bottom Back Chamfer
                    translate([-outer_width / 2, -outer_depth / 2, -lid_height / 2 - (chamfer_size * 2 * sin(45)) / 2])
                        rotate([45, 0, 0])
                        cube([outer_width, chamfer_size, chamfer_size]);

                    // Bottom Left Chamfer
                    translate([outer_width / 2, -outer_depth / 2, -lid_height / 2 - (chamfer_size * 2 * sin(45)) / 2])
                        rotate([0, -45, 0])
                        cube([chamfer_size, outer_depth, chamfer_size]);

                    // Bottom Right Chamfer
                    translate([-outer_width / 2, -outer_depth / 2, -lid_height / 2 - (chamfer_size * 2 * sin(45)) / 2])
                        rotate([0, -45, 0])
                        cube([chamfer_size, outer_depth, chamfer_size]);

                    // Right Front Chamfer
                    translate([outer_width / 2, -outer_depth / 2 - (chamfer_size * 2 * sin(45)) / 2, -lid_height / 2])
                        rotate([0, 0, 45])
                        cube([chamfer_size, chamfer_size, outer_depth]);

                    // Left Front Chamfer
                    translate([-outer_width / 2, -outer_depth / 2 - (chamfer_size * 2 * sin(45)) / 2, -lid_height / 2])
                        rotate([0, 0, 45])
                        cube([chamfer_size, chamfer_size, outer_depth]);

                    // Right Back Chamfer
                    translate([outer_width / 2, outer_depth / 2 + (chamfer_size * 2 * sin(45)) / 2, -lid_height / 2])
                        rotate([0, 0, 225])
                        cube([chamfer_size, chamfer_size, outer_depth]);

                    // Left Back Chamfer
                    translate([-outer_width / 2, outer_depth / 2 + (chamfer_size * 2 * sin(45)) / 2, -lid_height / 2])
                        rotate([0, 0, 225])
                        cube([chamfer_size, chamfer_size, outer_depth]);
                }
            }

            translate([0, 0, wall_thickness])
                cube([adjusted_inner_width, adjusted_inner_depth, lid_height], center = true);
            
            translate([0, 0, lid_height / 2 - lid_box_overlap / 2])
                cube([adjusted_inner_width + wall_thickness + printer_tolerance / 2, adjusted_inner_depth + wall_thickness + printer_tolerance / 2, lid_box_overlap], center = true);
        }
}

sliding_lid();
box();
