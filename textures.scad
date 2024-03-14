$fa = 1;
$fs = 0.4;
/* texture_stamp

    By Tyler Tork
    Twitter: @tylertorkfictioneer
    Email: tyler@tylertork.com
    Website: tylertork.com/3d

    Creative Commons - Attribution - Non-Commercial
    International License
*/

/*
    texture_stamp(type, diameter, depth)
    where type is one of "bumps", "horizontal", "vertical", "circles", "dots", "pips", "zigzag"
    creates an object centered on the origin, with a downward-facing textured surface you can use to stamp onto a flat face of another object via the difference operation. The stamp will be at least a circle of the specified diameter (more often a square of that dimension), and the texture pattern will have the specified depth. 
*/
module texture_stamp(type="circles", diameter=40, depth=.5) {
    rad = diameter/2;
    if (type == "circles") {
        tmp = concat([for(i = [0:diameter]) [i/2, i%2 == 0 ? -depth : 0]], [[diameter/2,1], [0,1]]);
        rotate_extrude() polygon(tmp);
    } else if (type=="vertical") {
        tmp = concat([for(i = [0:diameter*2]) [i/2, i%2 == 0 ? -depth : 0]], [[diameter,1], [0,1]]);
        translate([-diameter/2, 0, 0]) rotate([90,0,0]) linear_extrude(diameter, center=true) polygon(tmp);
    } else if (type=="horizontal") {
        rotate([0,0,90]) texture_stamp("vertical", depth=depth, diameter=diameter);
    } else if (type == "bumps") {
        tmp = concat([for(i = [0:diameter]) [i-rad, i%2 != 0 ? -depth : depth/2 ]], [[rad,1], [-rad,1]]);
        rotate([90,0,0])
        union() {
            linear_extrude(height=diameter, center=true) polygon(tmp);
            rotate([0,90,0]) linear_extrude(height=diameter, center=true) polygon(tmp);
        }
    } else if (type == "bigbumps") {
        tmp = concat([for(i = [0:rad]) [2*i-rad, i%2 != 0 ? -depth : depth/2 ]], [[rad,1], [-rad,1]]);
        rotate([90,0,0])
        union() {
            linear_extrude(height=diameter, center=true) polygon(tmp);
            rotate([0,90,0]) linear_extrude(height=diameter, center=true) polygon(tmp);
        }
    } else if (type == "pips") {
        spacing = 5;
        hd = .5+depth/2;
        points = [[hd, 0], [0, hd], [-hd, 0], [0,-hd]];
        translate([-diameter/2,-diameter/2,-depth])
        difference() {
            cube([diameter, diameter, 1+depth]);
            for (x = [spacing/3:spacing:diameter],
             y = [spacing/3:spacing:diameter],
             d = [0, spacing/2])
                translate([x+d,y+d,-depth]) linear_extrude(height=depth+1,scale=.1) polygon(points);
        }
    } else if (type == "dots") {
        spacing = 4;
        dotsize = 2;
        rd = spacing*cos(30);
        rc = spacing*sin(30);
        translate([-diameter/2,-diameter/2,-depth])
        difference() {
            cube([diameter, diameter, 1+depth]);
            for(x=[dotsize:spacing:diameter+dotsize], y=[2:rd*2:diameter+rd]) {
                translate([x, y, -depth]) cylinder(1, dotsize/2+.5, dotsize/2);
                translate([x+rc, y+rd, -depth]) cylinder(1, dotsize/2+.5, dotsize/2);
            }
        }
    } else if (type == "zigzag") {
        period = 6;
        spacing = 5;
        width = 2;
        seglen = width+period/sqrt(2);
        skwar = [seglen,width];
        scale=[(seglen+depth)/seglen,(width+depth)/width];
        translate([-diameter/2,-diameter/2,0])
        union() {
            for(x=[period/4:period:diameter+period/4-.01],
                y=[spacing/4:spacing:diameter+spacing/2]) {
                translate([x,y,.01-depth]) rotate([0,0,45]) linear_extrude(height=depth+.01,scale=scale) square(skwar, center=true);
                translate([x+period/2,y,.001-depth]) rotate([0,0,-45]) linear_extrude(height=depth,scale=scale) square(skwar, center=true);
            }
        }
    }
}

module texture_samples() {
types = ["bumps", "bigbumps", "horizontal", "vertical", "dots", "pips","zigzag"];
for (i=[0:len(types)-1]) {
translate([45*i,0,0]) rotate([180,0,0]) texture_stamp(types[i]);
difference() {
    translate([45*i-12.5,45,0]) cube([25,25,3]);
    translate([45*i,57.50,3]) texture_stamp(types[i]);
}
}
}
texture_samples();
