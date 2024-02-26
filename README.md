# keysleeve.scad

This script for OpenSCAD uses user-selected parameters to create 3D models of key sleeves. A key sleeve is a short piece that slides onto the head of the key, identifying the key by color and customizable label text.

The script requires support files which are SVG images of the outlines of the supported key heads. It can be extended to support more key types by adding SVG files and some coded parameters describing the key and specifying the shape of the sleeve.

The sleeve will require some flexibility to slide onto the key. Resin prints might be too brittle -- FDM suggested.

## Using the script

The script allows for customization of the following parameters:

- key_style: Integer value ranging from 0 to the number of supported key styles-1. This is an index into the "choices" array which contains sets of further parameters defining the key.
- label: text you want to appear on the sleeve. May be blank, but in that case why are you here?
- font: what font you would like for the label. Simple, sans-serif fonts will work best for 3D printing.
- letter_height: Height of label characters (mm).
- raise_text: If you don't like the positioning of the label, use this measurement in mm to affect its y-axis position, positive to move "up" toward the key top.
raise_text = 0;
- letter_emboss: in mm, positive to emboss label, negative to engrave it. The default is to engrave because this is easier for FDM printers.

## Extending the script - adding key styles

To add to the list of key types supported by this script, you need two things:

- An SVG file containing a precise outline of the key head.
- A list of numeric parameters with measurements of the key, what part of the key needs to be covered, and where you want to add protrusions on the inside of the sleeve to fit into holes in the key.

### The SVG file

The purpose of this vector image is twofold -- to define the shape of the key head, which the sleeve is to enclose; and to give the user a visual match for the key they want to make a sleeve for, to aid in selecting a value for the key_style parameter.

The best way to create this image is to photograph or scan the key, then trace the outline in a vector editor such as Inkscape. Avoid bright reflections that would fool the trace bitmap function (or just trace the outline manually). You might tape the key to a piece of thin paper and hold it up in front of the sun to get just the shadow of the key -- shape without reflective highlights. Photograph it from some distance and as straight-on as you can, to avoid distortion.

Clean up any sharp corners on the edges of the traced shape, which can cause rendering errors.

If there's text on the key head that identifies the manufacturer or model number of the key, by all means add that text within the body of the key head at approximately the right position. Then convert the text to vectors and make it part of the same path as the key outline.

It's not important functionally how much of the shaft of the key is included, but the custom is "just a little", and for aesthetic reasons that shouldn't vary much.

The image should be scaled to the exact size of the key head, and that one path should be the only thing in the SVG file. Use mm units.

### Key description parameters

You must add an entry to the **choices** list describing the key and the sleeve you want to create. Use a caliper to take the dimensions of the key head -- width and depth. Most keys are about 1.8mm thick, and that's the script's default. If yours is much different there's a way to supply that information. The sleeve is designed to fit pretty snugly, so if the width is wrong there will be a problem.

The parameters for a key type are a list of values as follows (all coordinates in mm):

0. SVG filename, without the SVG file extension. The file is assumed to be in the same folder as the script.
1. Y coordinate of cut line for bottom of sleeve. This distance is measured from the bottom of the key outline in the SVG.
2. Either the Y coordinate for the cut line for top of sleeve, or a list of y-coordinates. If a list, the X coordinates are calculated as evenly spaced across the sleeve.
3. width of key, or `[width,depth]` for thicker/thinner keys. The depth will be the depth of the hollow for the key head, so include an extra .2mm or so to accommodate imprecise printing.
4. (and above) `[x_center,y_center,width]` to position a wedge inside the sleeve to lock into holes in the key.
