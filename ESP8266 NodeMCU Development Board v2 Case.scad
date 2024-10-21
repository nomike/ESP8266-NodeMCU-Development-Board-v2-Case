$fn=64;


// box
epsilon = 0.001;        // prevent z-fighting

board_width = 31.5;
board_length = 58.0;
board_height = 4.4;

shell_thickness = 2;
support_corner_width = 7;
screw_hole_diameter = 2.9;
screw_hole_offset = 2.5;
bottom_clearance = 20;


// USB cutout
usb_cutout_width = 9;
usb_cutout_height = 5;
usb_cutout_z_offset = 1.8;

// cable cutout

cable_cutout_width = 15;
cable_cutout_height = 5;
cable_cutout_z_offset = 2;

component_distance = 1;

// lid
lid_height = 1;
lid_inner_height = 2;
lid_latch_radius = .5;
lid_latch_corner_offset = 5;
lid_shell_thickness = 1;

logo_width = 23;
logo_aspect_ratio = 0.56;
logo_length = logo_width * logo_aspect_ratio;


module box() {
    difference() {
        cube([board_width + 2 * shell_thickness, board_length + 2 * shell_thickness, bottom_clearance + board_height + 2 * shell_thickness + lid_inner_height]);
        translate([shell_thickness, shell_thickness, shell_thickness]) cube([board_width, board_length, bottom_clearance + board_height + shell_thickness + lid_inner_height + epsilon]);
        // lid latches
        translate([shell_thickness, shell_thickness + lid_latch_corner_offset, shell_thickness + bottom_clearance + board_height + shell_thickness + lid_inner_height / 2]) sphere(r=lid_latch_radius);
        translate([shell_thickness + board_width, shell_thickness + lid_latch_corner_offset, shell_thickness + bottom_clearance + board_height + shell_thickness + lid_inner_height / 2]) sphere(r=lid_latch_radius);
        translate([shell_thickness, shell_thickness + board_length - lid_latch_corner_offset, shell_thickness + bottom_clearance + board_height + shell_thickness + lid_inner_height / 2]) sphere(r=lid_latch_radius);
        translate([shell_thickness + board_width, shell_thickness + board_length - lid_latch_corner_offset, shell_thickness + bottom_clearance + board_height + shell_thickness + lid_inner_height / 2]) sphere(r=lid_latch_radius);
    }

}

module support_corner() {
    difference() {
        translate([-epsilon, -epsilon, shell_thickness - epsilon]) cube([support_corner_width, support_corner_width, bottom_clearance]);
        translate([support_corner_width / 2, support_corner_width / 2, shell_thickness  - epsilon]) cylinder(r=screw_hole_diameter / 2, h=bottom_clearance + epsilon * 2);
    }
}

module usb_cutout() {
    translate([shell_thickness + (board_width - usb_cutout_width) / 2,  -epsilon, bottom_clearance + usb_cutout_z_offset]) cube([usb_cutout_width, shell_thickness + 2 * epsilon, usb_cutout_height]);
}

module cable_cutout() {
    translate([shell_thickness + (board_width - cable_cutout_width) / 2, -epsilon, shell_thickness + cable_cutout_z_offset]) cube([cable_cutout_width, shell_thickness + 2 * epsilon, cable_cutout_height]);
}

module bottom() {
    union(){
        difference() {
            box();
            usb_cutout();
            cable_cutout();
        }
        translate([shell_thickness, shell_thickness, 0]) union() {
            support_corner();
            translate([board_width - support_corner_width, 0, 0]) support_corner();
            translate([0, board_length - support_corner_width, 0]) support_corner();
            translate([board_width - support_corner_width, board_length - support_corner_width, 0]) support_corner();
        }
    }
}

//TODO: Check z-axis
module lid() {
    translate([shell_thickness, shell_thickness, 0]) difference() {
        union() {
            translate([-shell_thickness, -shell_thickness, 0]) cube([board_width + 2 * shell_thickness, board_length + 2 * shell_thickness, lid_height]);
            translate([0, 0, lid_height - 2 * epsilon]) cube([board_width, board_length, lid_inner_height]);
            // latches
            translate([0, lid_latch_corner_offset, lid_height + lid_inner_height / 2]) sphere(r=lid_latch_radius);
            translate([board_width, lid_latch_corner_offset, lid_height + lid_inner_height / 2]) sphere(r=lid_latch_radius);
            translate([0, board_length - lid_latch_corner_offset, lid_height + lid_inner_height / 2]) sphere(r=lid_latch_radius);
            translate([board_width, board_length - lid_latch_corner_offset, lid_height + lid_inner_height / 2]) sphere(r=lid_latch_radius);
        }
        translate([lid_shell_thickness, lid_shell_thickness, lid_height]) cube([board_width - 2 * lid_shell_thickness, board_length - 2 * lid_shell_thickness, lid_inner_height + epsilon]);
    }
}

bottom();
translate([shell_thickness + board_width + 2 * shell_thickness + component_distance, 0, 0]) difference() {
    lid();
    translate([shell_thickness + (board_width - logo_width) / 2, shell_thickness + (board_length - logo_length) / 2, 0 - lid_height - epsilon])
        linear_extrude(lid_height + lid_inner_height + 2 * epsilon)
            resize([logo_width, logo_length, 0])
                // mirror([1, 0, 0])
                    import("logo.svg");
}
