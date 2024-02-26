/*
Parameterized Key Sleeve script

By Tyler Tork
Twitter: @tylertorkfictioneer
Email: tyler@tylertork.com
Website: torknado.com/3d

Creative Commons Attribution-ShareAlike 4.0 International License
    https://creativecommons.org/licenses/by-sa/4.0/legalcode
*/

// parameters for a key type are:
//  0: SVG filename.
//  1: cut line for bottom of sleeve.
//  2: cut line for top of sleeve, or a list of y-coordinates for a not-straight top.
//  3: width of key, or [width,depth] for thicker/thinner keys.
//  4-n: [x,y,width] to position wedges inside the sleeve to lock into holes in the key.
choices = [
    ["kwikset-3-holes", 4.47, 14.47, 22, [5.4,13.85,3.6], [16.6,13.85,3.6]],
    ["hy-ko-KW1", 3, 19.37, 22.5, [11.25,18.8,5]],
    ["minutekey-plain", 0, 16.88, 22.2, [11.1,16.29,2.5]],
    ["schlage-95", 9, [17,20,22.8,22.8,20,17], [26.2,2.4], [13.1,22.2, 4]],
    ["hillman-95", 9, [17,20,21.0,21.0,20,17], 25, [12.5,20.4, 4]]
];
key_style = 0;
label = "demo";
font = "Arial";
// Height of label characters (mm)
letter_height = 4;
// Shift label up this far (mm)
raise_text = 0;
// positive to emboss, negative to engrave label.
letter_emboss = -.5;

module textlines(texts, size=4, halign="center", font="", lineheight=1.4) {
    lines = is_list(texts) ? texts : [texts];
    for (i=[0:len(lines)-1]) {
        translate([0,-i*size*lineheight,0]) text( lines[i], font=font, size=size,halign=halign,font=font);
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
    textlines(tex, 4);
}



if(key_style < 0 || key_style >= len(choices)) {
    nope(["Key style may range", str("from 0 to ", len(choices)-1)]);
} else {
    parms = choices[key_style];
    filename = str(parms[0], ".svg");
    top = parms[2];
    keywidth = is_list(parms[3]) ? parms[3][0] : parms[3];
    keydepth = is_list(parms[3]) ? parms[3][1] : 2;
    textpos = is_list(top) ? ((min(top)+max(top))/2) : (top-2);
    difference() {
        // main body of key sleeve - 1mm border around key shape.
        color("#0000ff40") linear_extrude(2+keydepth, convexity=0) minkowski(1.15) {
            fill() import(filename);
            circle(1);
        }
        // interior hollow to accommodate key.
        color("white") translate([0,0,1]) linear_extrude(keydepth, convexity=0) minkowski(1) {
            fill() import(filename);
            circle(.2);
        }
        // trim top and bottom of sleeve to specified y-coordinates.
        translate([-2,-2.999,-.5]) cube([30,3+parms[1],3+keydepth]);
        if(is_list(top)) {
            s_wid = keywidth + 2.02;
            lim = len(top)-1;
            points = concat([for(i = [0:lim]) [i/lim*s_wid - 1.01, top[i]]], [[s_wid-1.01,50],[-1.01,50]]);
            translate([0, 0, -.5]) linear_extrude(height=3+keydepth) polygon(points);
        } else {
            translate([-2,top,-.5]) cube([30,30,3+keydepth]);
        }
        if (label != "" && letter_emboss < 0) {
           // text on both sides (if engraved).
            translate([keywidth/2, textpos-letter_height+raise_text, 2.001+keydepth+letter_emboss])
            linear_extrude(height=-letter_emboss)
            text(label, size=letter_height, halign="center", font=font);
            
            translate([keywidth/2, textpos-letter_height+raise_text, -.001])
            linear_extrude(height=-letter_emboss)
            rotate([0,180,0])
            text(label, size=letter_height, halign="center", font=font);
        }
    }
    // wedges to lock into holes in key
    if (!is_undef(parms[4])) {
        for (i = [4:len(parms)-1]) {
            point = parms[i];
            translate([point[0],point[1],1]) rotate([45,0,0]) cube([point[2], .8, .8], center=true);
            translate([point[0],point[1],1+keydepth]) rotate([45,0,0]) cube([point[2], .8, .8], center=true);
        }
    }
    // text on both sides (if embossed).
    if (label != "" && letter_emboss > 0) {
        translate([keywidth/2, textpos-letter_height+raise_text, 1.999 + keydepth])
        linear_extrude(height=letter_emboss)
        text(label, size=letter_height, halign="center", font=font);
        
        translate([keywidth/2, textpos-letter_height +raise_text, .001-letter_emboss])
        linear_extrude(height=letter_emboss)
        rotate([0,180,0])
        text(label, size=letter_height, halign="center", font=font);
    }
    // show ghost key tops and filename for user reference
    %translate([-28,0,1]) import(filename);
    %translate([0,0,1.05]) linear_extrude(height=keydepth-.1) import(filename);
    %translate([0, -7, 1]) text(parms[0], 5, halign="center");
}