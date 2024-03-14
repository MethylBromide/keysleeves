/*
Parameterized Key Sleeve script

By Tyler Tork
Twitter: @tylertorkfictioneer
Email: tyler@tylertork.com
Website: tylertork.com/3d

Creative Commons - Attribution - Non-Commercial 4.0
 International License
 https://creativecommons.org/licenses/by-nc/4.0/
*/

use <objects.scad>
use <textures.scad>
key_style = "KwikSet #66"; // [ KwikSet #66: Kwikset #66 - 3 holes, HY-KO KW1, MinuteKey - plain, MinuteKey - cutout, Schlage #95, Hillman #95, Ace KW1, ILCO FA3, Unknown #1 ]
On_front = "L"; //[L:text label, B:Braille, T:texture]
On_back = "S"; // [ S: same as front, L:text label, B:Braille, T:texture ]
//if "On front" is text or Braille
Label_front = "DEMO"; //8
//if "On back" is text or Braille
Label_back = ""; //8
Texture = "dots"; // [ horizontal: horizontal lines, vertical: vertical lines, dots, bumps, zigzag, pips, blank ]

/* [Label settings] */
Font = "Arial Black, Gadget, sans-serif";
// Height of label characters (mm)
letter_height = 4.3; //[2:.1:7]
// Reposition text vertically (mm)
text_position = 0; //[-4:.1:4]
// positive for raised lettering, negative for engraved (mm)
letter_emboss = -.5; // [-1:.05:.5]
/* [Braille settings] */
Braille_font = "DejaVu Sans,Segoe UI Symbol,Apple Symbols";
Braille_Height = 6.15; //[2:.05:7]
// Reposition Braille vertically (mm)
Braille_position = 0; //[-4:.1:4]

/* [Hidden] */
$fa = 1;
$fs = 0.4;
UNIBRAILLE = "⠼⠫⠩⠯⠄⠷⠾⠡⠬⠠⠤⠨⠌⠴⠂⠆⠒⠲⠢⠖⠶⠦⠔⠱⠰⠣⠿⠜⠹⠈⠁⠃⠉⠙⠑⠋⠛⠓⠊⠚⠅⠇⠍⠝⠕⠏⠟⠗⠎⠞⠥⠧⠺⠭⠽⠵⠪⠳⠻⠘⠸";
UNIASC =     "#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\]^_";

// Concatenate a vector=v of strings to a prefix string=s.
function cat(s, v) =
  len(v) == 0 ? s :
  len(v) == 1 ? str(s, v[0]) :
  cat(str(s, v[0]), [for(i=[1:len(v)-1]) v[i]]);
  
function toBraille(s) = cat("",[for(c = s) let(x = search(ord("a") <= ord(c) && ord(c) <= ord("z") ? chr(ord(c) - (ord("a")-ord("A"))) : c, UNIASC)) len(x) == 0 ? " " : UNIBRAILLE[x[0]]]);

include <keytype_defs.scad>

module textlines(texts, size=4, halign="center", font="", lineheight=1.4) {
    lines = is_list(texts) ? texts : [texts];
    delta_y = ((len(lines)-1)*size*lineheight - size)/2;
    for (i=[0:len(lines)-1]) {
        translate([0,delta_y-i*size*lineheight,0]) text( lines[i], font=Font, size=size,halign=halign);
    }
}

module nope(tex) {
    color("darkred") union() {
        difference() {
            translate([0, 0, -2]) cylinder(1, r=15);
            translate([0,0,-3]) cylinder(3, r=11);
        }
        translate([0, 0, -1.5]) rotate([0, 0, 45]) cube([27, 4, 1], center=true);
    }
    textlines(tex, size=4);
    echo(texlines);
}

/*
    Import an SVG file of a specified width and merge it with its mirror image. If fill is true we also fill interior holes.
*/
module flip_import(filename, width, fill=false) {
    union() {
        if (fill) { fill() import(filename); } else { import(filename); };
        
        translate([width,0,0]) scale([-1,1,1])
            if (fill) { fill() import(filename); } else { import(filename); };
    }
}

/* stampSide: create an object to add decoration to a flat side of a key sleeve.

    parms: list containing [type, labeltext] where
        type = "E" to emboss text,
               "L" for engraved label,
               "B" for Braille text,
               "T" for texture
        labeltext is what text we want.
    subtracting: if true, the returned object will be subtracted from the sleeve, else added.
    
    The resulting object faces upward, is centered at the XY origin, and should be translated to apply to the surface along the z=0 plane.
*/
module stampSide(parms, keywidth, subtracting = true) {
    type = parms[0];
    if (subtracting) {
        if (type == "L") {
            rotate([0,180,0])
                translate([0,text_position,letter_emboss])
                linear_extrude(height=.01-letter_emboss)
                text(parms[1], size=letter_height, font=Font, halign="center", valign="center");
        } else if (type == "T") {
            rotate([0,180,0])
            texture_stamp(Texture, (keywidth + 3), 0.3);
        }
    } else { // adding
        if (type == "B") {
            translate([0, Braille_position, -.02])
            linear_extrude(height=0.5)
            text(toBraille(parms[1]), size=Braille_Height, font=Braille_font, halign="center", valign="center");
        } else if (type == "E") {
            translate([0,text_position,-.001])
                linear_extrude(height=letter_emboss)
                text(parms[1], size=letter_height, font=Font, halign="center", valign="center");
        }
    }
}

parms = obj(KEYTYPES,key_style);
if (is_undef(parms)) {
    nope(str("Unknown key type: ", key_style));
} else {
    thick = 0.8; // sleeve front/back thickness
    filename = str(obj(parms, "filename"), ".svg");
    bottom = obj(parms,"bottom");
    top = obj(parms,"top");
    keywidth = obj(parms, "width");
    keydepth = obj(parms, "depth", 1.8) + .2;
    sleevedepth = thick + keydepth + thick;
    textpos = bottom + (max(top) - bottom)/2 + obj(parms,"text-vpos",0);
    wedges = obj(parms, "wedges");

    front =
        [
            (On_front == "L" && (Label_front == "" || letter_emboss == 0))
             ? ""
             : (On_front == "L" && letter_emboss > 0)
                ? "E"
                : On_front,
            Label_front
        ];
    back =
        On_back == "S" 
        ? front
        : [
            On_back == "L" && (Label_back == "" || letter_emboss == 0)
            ? ""
            : (On_back == "L" && letter_emboss > 0)
                ? "E"
                : On_back,
            Label_back
          ];
    rotate([90, 0, 0])
    {
        difference() {
            // main body of key sleeve - 1mm border around key shape.
            color("#0000ff40") linear_extrude(sleevedepth, convexity=0) offset(r=1) {
                flip_import(filename, width=keywidth, fill=true);
            }
            
            // interior hollow to accommodate key.
            color("white") translate([0,0,thick]) linear_extrude(keydepth, convexity=0) offset(r=.2) {
                flip_import(filename, width=keywidth, fill=true);
    //            circle(.2);
            }
            
            // trim bottom of sleeve to specified bottom height.
            translate([-2,-3,-1]) cube([30,3+bottom,2+sleevedepth]);
            
            // trim top of sleeve to specified y-coordinate or set of points.
            if(is_list(top)) {
                s_wid = keywidth + 2.02;
                lim = len(top)-1;
                points = [
                    for(i = [0:lim]) [i/lim*s_wid - 1.01, top[i]],
                    [s_wid-1.01,50],
                    [-1.01,50]
                ];
                translate([0, 0, -1]) linear_extrude(height=2+sleevedepth) polygon(points);
            } else {
                translate([-2,top,-1]) cube([30,30,2+sleevedepth]);
            }
            
            /* if whatever appears on the flat sides is engraved, do that now */
            translate([keywidth/2, textpos, sleevedepth])
                rotate([0,180,0])
                stampSide(front, keywidth, true);
            translate([keywidth/2, textpos, 0])
                stampSide(back, keywidth, true);
        } // end difference

        // wedges to lock into holes in key
        if (!is_undef(wedges)) {
            wedgesarr = is_list(wedges[0])?wedges:[wedges];
            for (point = wedgesarr) {
                translate([point[0]-point[2]/2,point[1]-.5,thick])
                    rotate([90,0,90])
                    linear_extrude(height=point[2])
                    polygon([[0,0],[.4,1],[1.3,0], [1.3,-.01],[0,-.01]]);
            }
        }
        // if what appears on the sides is embossed, do that.
        translate([keywidth/2,textpos,sleevedepth])
            stampSide(front, keywidth, false);
        translate([keywidth/2,textpos,0])
            rotate([0,180,0])
            stampSide(back, keywidth, false);

        // show ghost key tops and filename for user reference
        %translate([-28,0,thick]) linear_extrude(height=keydepth-.2, convexity=20) import(filename);
        %translate([0,0, thick+.1]) linear_extrude(height=keydepth-.2, convexity=20) flip_import(filename, width=keywidth);
        %translate([0, -7, 1]) linear_extrude(height=0.01) text(key_style, 5, halign="center");
//stampSide(back, keywidth, back[0]=="L" || back[0]=="T");
    }
}
