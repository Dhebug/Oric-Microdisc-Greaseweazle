//
// OpenSCAD file describing a back plate replacement for 3" Oric Microdisc drive units, includes:
// - PCB holder with three holes designed to host a GreaseWeazle F7 Lightning Plus
// - Holes on the back plate, one for the USB connector and one for the 12v power
//
thickness = 1.6;        // Total thickness of the back plate (mm)
height = 62.2;          // Height of the back plate (mm)
bottom_width = 118.3;   // Width at the bottom (mm)
mid_width = 119.2;      // Width at 15mm height (mm)
top_width = 114;        // Width at the top (mm)
mid_height = 15.0;      // Height of the widest section (mm)

// PCB support frame parameters
frame_offset_y = 2.2;   // Distance from bottom of back plate (mm)
frame_offset_x = 21.0;  // Distance from left side (mm)
frame_width = 64.0;     // Width of the frame along back plate (mm)
frame_depth = 64.0;     // Depth perpendicular to back plate (mm)
frame_thickness = 3.0;  // Thickness of the frame (mm)
ridge_thickness = 2.0;  // Thickness of the ridges on top
ridge_width = 5.0;      // Width of each ridge
ridge_offset_x = 5.0;   // Offset from frame edges for ridge placement
standoff_height = 6.0;  // Height of motherboard screw stands
pcb_thickness = 1.5;    // Thickness of the PCB

// Hole parameters
hole_radius = 3.3 / 2;        // Radius of holes (3.3mm diameter)
bulge_radius = 3.5;           // Radius for bulges (7 mm diameter)
hole1_x = 30.6;               // Center of first hole (30.6 mm from frame's left edge)
hole1_z = thickness + 2.0;    // 2 mm from front edge (back plate inner surface)
hole2_x = 2.0;                // 2 mm from left edge of frame
hole2_z = thickness + 45.2;   // 45.2 mm from front panel
hole3_x = frame_width - 2.0;  // 2 mm from right edge of frame
hole3_z = thickness + 45.2;   // 45.2 mm from front panel

// Connector hole parameters
usb_hole_x = frame_offset_x + 49.0;  // 49 mm from PCB left edge (21.0 + 49.0)
usb_hole_width = 12.1;               // USB connector width (mm)
usb_hole_height = 10.6;              // USB connector height (mm)

power_hole_x = frame_offset_x + 35.7;  // 35.7 mm from PCB left edge (21.0 + 35.7)
power_hole_width = 8.8;                // Power connector width (mm)
power_hole_height = 11.2;              // Power connector height (mm)

hole_y_offset = frame_offset_y + frame_thickness + standoff_height + pcb_thickness; // Start at top of PCB (12.7 mm)

// Back plate with holes for the 12v power and usb connectors
difference() 
{
    // Outer shape
    linear_extrude(height = thickness) 
    polygon(points=[
        [0, 0],                                                      // Bottom-left corner
        [bottom_width, 0],                                           // Bottom-right corner
        [bottom_width + (mid_width - bottom_width) / 2, mid_height], // Mid-right
        [bottom_width - (bottom_width - top_width) / 2, height],     // Top-right
        [(bottom_width - top_width) / 2, height],                    // Top-left
        [(bottom_width - mid_width) / 2, mid_height]                 // Mid-left
    ]);
    
    // Subtract USB connector hole
    translate([usb_hole_x, hole_y_offset, 0]) 
    cube([usb_hole_width, usb_hole_height, thickness]);
    
    // Subtract Power connector hole
    translate([power_hole_x, hole_y_offset, 0]) 
    cube([power_hole_width, power_hole_height, thickness]);
}

// PCB support frame with holes and ridges
translate([frame_offset_x, frame_offset_y, thickness]) 
difference() 
{
    // PCB support frame
    union() 
    {
        cube([frame_width, frame_thickness, frame_depth]);
        add_holes(bulge_radius);

        // Add ridges on top of the PCB support frame
        translate([ridge_offset_x, frame_thickness, 0]) 
        cube([ridge_width, ridge_thickness, frame_depth]);
        
        translate([frame_width - ridge_offset_x - ridge_width, frame_thickness, 0]) 
        cube([ridge_width, ridge_thickness, frame_depth]);        
    }           
    add_holes(hole_radius);            
}


module add_holes(radius)
{
    // Hole 1: Center, 2 mm from front
    translate([hole1_x, frame_thickness, hole1_z]) 
    rotate([90, 0, 0]) 
    cylinder(h = frame_thickness, r = radius, $fn = 50);

    // Hole 2: Left edge, 45.2 mm from front
    translate([hole2_x, frame_thickness, hole2_z]) 
    rotate([90, 0, 0]) 
    cylinder(h = frame_thickness, r = radius, $fn = 50);

    // Hole 3: Right edge, 45.2 mm from front
    translate([hole3_x, frame_thickness, hole3_z]) 
    rotate([90, 0, 0]) 
    cylinder(h = frame_thickness, r = radius, $fn = 50);
}

