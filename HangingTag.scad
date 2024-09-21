// Variables
width = 100;
height = 40;
base_depth = 1;
border_width = 2;
border_height = .8;
text_margin = 0;
font_size_main = 6;  // Font size for the main text
font_size_sub = 4;    // Font size for the sub-text
vertical_spacing = 10; // Space between main text and sub-text
offset_up = 12;       // Amount to move text up
hole_diameter = 5;    // Diameter of the hole
hole_offset = 5;      // Distance from the top left corner to the center of the hole
border_thickness = .8; // Thickness of the border above the base

// Text Variables
main_text = "Gold Nugget Tangerine";
sub_text = "Sweet & Easy To Peel";

$fn = 60;

// Tag Shape
module tag() {
    difference() {
        // Base Plate
        linear_extrude(height=base_depth) {
            offset(r=2)  // Rounded edges
                square([width, height], center=false);
        }
        
        // Border (Cut-Out)
        translate([border_width + text_margin, border_width + text_margin, -2]) {
            linear_extrude(height=border_height + 1) {
                offset(r=1)  // Rounded corners on border
                    square([width - 2 * border_width - 2 * text_margin, height - 2 * border_width - 2 * text_margin], center=false);
            }
        }

        // Hole
        translate([hole_offset, height - hole_offset, base_depth / 2]) {
            cylinder(r=hole_diameter / 2, h=base_depth + 1, center=true);
        }
    }
}

// Border Module
module border() {
    difference() {
        // Outer Border
        translate([0, 0, base_depth]) {
            linear_extrude(height=border_thickness) {
                offset(r=0)  // Rounded edges
                    square([width, height], center=false);
            }
        }
        
        // Inner Cut-Out
        translate([border_width, border_width, base_depth]) {
            linear_extrude(height=border_thickness + 1) {
                offset(r=1)  // Rounded corners
                    square([width - 2 * border_width, height - 2 * border_width], center=false);
            }
        }
    }
}

// Text
module text_on_tag(main_text, sub_text) {
    // Compute text height
    main_text_height = font_size_main + 2;  // Add some spacing
    sub_text_height = font_size_sub + 2;    // Add some spacing
    
    // Calculate total vertical space needed
    total_text_height = main_text_height + sub_text_height + vertical_spacing;
    
    // Vertical position for centering and adjustment
    vertical_center = (height - total_text_height) / 2 + offset_up;

    // Centered Main Text
    translate([width / 2, vertical_center + main_text_height / 2, 0]) {  // Keep the text at the original height
        linear_extrude(height=base_depth + border_thickness) {  // Extrude downward through the base depth
            text(main_text, size=font_size_main, valign="center", halign="center");
        }
    }
    
    // Centered Sub Text
    translate([width / 2, vertical_center + main_text_height / 2 - vertical_spacing - sub_text_height / 2, 0]) {  // Keep the text at the original height
        linear_extrude(height=base_depth + border_thickness) {  // Extrude downward through the base depth
            text(sub_text, size=font_size_sub, valign="center", halign="center");
        }
    }
}

// Combine Tag and Text
module complete_tag(main_text, sub_text) {
    tag();
    border();
    text_on_tag(main_text, sub_text);
}

// Example Usage
complete_tag(main_text, sub_text);
