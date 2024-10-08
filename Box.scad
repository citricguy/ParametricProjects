/* ********************************************************************* *\
    This box is designed to be dimensionally accurate on the interior.

    The outer dimensions are determined by the inner dimensions, 
    your printer's tolerance settings, and wall thickness.

    You can opt for a loosely fitting lid or a sliding lid with snaps. 
    Alternatively, use a tight-fitting lid without snaps for smaller 
    printer tolerances.

    Keeping the wall thickness thin allows the snaps to function properly, 
    as the base can flex slightly for easy fitting and release. If the wall 
    thickness is too thick, the snaps may not operate effectively, and a 
    friction fit should be used instead.

    Note that the snap settings may not work if the lid is too thick, as 
    they are designed for thinner lids. Also, if the overlap is too small
    the snaps may not work as intended and could break your print.
\* ********************************************************************* */

// Parameters
inner_height = 60; // Inner height of the box
inner_width = 60;  // Inner width of the box
inner_depth = 60;  // Inner depth of the box

printer_tolerance = 0.4; // This will be added to any dimension needing accuracy. Adjust as needed. (Tight .15, Normal .35, Loose .5)

wall_thickness = 3; // Thickness of the outer wall
lid_height = 20; // Height of the lid cut based on the inner box
lid_box_overlap = 10; // Overlap height between lid and box

enable_snaps = 1; // Set to 1 to enable snaps, 0 to disable
side_snap_height = 3; // Height of the side snap
side_snap_width = 3; // Width of the side snap (Distance between the midpoints of the circular edges of the snap)

apply_chamfer = 1; // Set to 1 to apply chamfer, 0 to disable


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

    if (enable_snaps) {
        difference() {
            rotate([0, 90, 0])
            translate([-outer_height + lid_height - side_snap_height/2 - lid_box_overlap/3, 0, -outer_width/2])
                linear_extrude(height = outer_width)
                    hull() {
                        translate([0, side_snap_width - printer_tolerance/2, 0]) circle(d=side_snap_height - printer_tolerance/2, $fn=50);
                        translate([0, -side_snap_width + printer_tolerance/2, 0]) circle(d=side_snap_height - printer_tolerance/2, $fn=50);
                    }
                    
            translate([0, 0, adjusted_inner_height / 2 + wall_thickness])
                cube([adjusted_inner_width, adjusted_inner_depth, adjusted_inner_height], center = true);

            // Right Bottom Snap Chamfer
            translate([outer_width/2,0,outer_height - lid_height + side_snap_height/2 + lid_box_overlap/3 - side_snap_height/3])
                rotate([0, 45, 0])
                cube([1, 100, 10], center = true);

            // Right Top Snap Chamfer
            translate([outer_width/2,0,outer_height - lid_height + side_snap_height/2 + lid_box_overlap/3 + side_snap_height/3])
                rotate([0, -45, 0])
                cube([1, 100, 10], center = true);

            // Left Bottom Snap Chamfer
            translate([-outer_width/2,0,outer_height - lid_height + side_snap_height/2 + lid_box_overlap/3 - side_snap_height/3])
                rotate([0, -45, 0])
                cube([1, 100, 10], center = true);

            // Left Top Snap Chamfer
            translate([-outer_width/2,0,outer_height - lid_height + side_snap_height/2 + lid_box_overlap/3 + side_snap_height/3])
                rotate([0, 45, 0])
                cube([1, 100, 10], center = true);
        }
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

            if (enable_snaps) {
                rotate([0, 90, 0])
                    translate([-lid_height/2 +side_snap_height/2 + lid_box_overlap/3, 0, -outer_width/2])
                        linear_extrude(height = outer_width)
                            hull() {
                                translate([0, side_snap_width + printer_tolerance/2, 0]) circle(d=side_snap_height + printer_tolerance/2, $fn=50);
                                translate([0, -side_snap_width - printer_tolerance/2, 0]) circle(d=side_snap_height + printer_tolerance/2, $fn=50);
                            }
            }
            
        }
}

sliding_lid();
box();
