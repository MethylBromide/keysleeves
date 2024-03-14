# keysleeve.scad

This script for OpenSCAD uses user-selected parameters to create 3D models of key sleeves. A key sleeve is a wrapper that slides onto the head of the key from the shaft end, identifying the key by color and customizable label text. It uses the holes in the key head to clip securely into place. I consider this better than a wrapper that goes onto the key from the top (such as you can buy in a hardward store) because it doesn't interfere with putting and keeping the key on a key ring.

**Note**: Currently requires version _Development snapshot_ because it uses the new 'fill' method.

The script uses support files which are SVG images of the outlines of the supported key heads. It can be extended to support more key types by adding SVG files and some coded parameters describing the key and specifying the shape of the sleeve.

The sleeve will require some flexibility to slide onto the key. Resin prints might be too brittle -- FDM suggested.

## Using the script

The script allows for customization of several parameters:

- For each side of the key, you may select whether you want standard text, Braille text, a textured surface that can be identified by touch, or nothing.
- The label text can be different on the two sides.
- You can specify a font, font size, and adjust the vertical position of the characters.
- A separate size and positioning adjustment are available for Braille (you normally want it much larger than regular text).
- For regular text, you can choose whether to emboss or engrave, and by how much.

## Extending the script - adding key styles

To add to the list of key types supported by this script, you need two things:

- An SVG file containing a precise outline of the key head.
- A list of numeric parameters with measurements of the key, what part of the key needs to be covered, and where you want to add protrusions on the inside of the sleeve to fit into holes in the key. The keytype_defs.scad file contains these definitions and further documentation on how to enter them.

### The SVG file

The purpose of this vector image is twofold -- to define the shape of the key head, which the sleeve is to enclose; and to give the user a visual match for the key they want to make a sleeve for, to aid in selecting a value for the key_style parameter.

The best way to create this image is to photograph or scan the key, then trace the outline in a vector editor such as Inkscape. Avoid bright reflections that would fool the trace bitmap function (or just trace the outline manually). You might tape the key to a piece of thin paper and hold it up in front of the sun to get just the shadow of the key -- shape without reflective highlights. Photograph it from some distance and as straight-on as you can, to avoid distortion.

Clean up any loops or pointy corners on the edges of the traced shape, which can cause rendering errors. Try to simplify the outline and reduce the number of control points.

If there's text on the key head that identifies the manufacturer or model number of the key, add that text within the body of the key head at approximately the right position. Then convert the text to vectors and make it part of the same path as the key outline. It's not so important that the interior shapes be simple, because they don't occur in the rendered version -- they're only visible as a "ghost image" during customization for the user to confirm they selected the right key type.

It's not important functionally how much of the shaft of the key is included, but the custom is "just a little", and for aesthetic reasons that shouldn't vary much.

The image should be scaled to the exact size of the key head, and that one path should be the only thing in the SVG file. Use mm units.

The SVG file, after import, is rotated to be upright in the XZ plane, since that's how these sleeves will normally be 3D-printed. The key descriptions below specify coordinates based on that assumption, so they are mostly (x,z) coordinates.

### Key description parameters

Please consult the keytype_defs.scad source file comments for examples and instructions for entering key description data.
