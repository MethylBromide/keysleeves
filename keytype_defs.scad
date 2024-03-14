/*
    keytype_defs defines an "object" of the type supported by the obj function (in objects.scad). This syntax lists key-value pairs in a flat list, alternating names and values, e.g. ["width",14,"height",3]
    
 	The object defined here contains definitions of the different known key types for the keysleeves.scad script. 

	Parameters for a key type use Z-coordinates which are relative to the bottom of the SVG file import of the key outline, and X-coordinates relative to the left edge of that import. All measurements in mm.

	The KEYTYPES structure is a hierarchical object -- each value is itself an object. The keys are the human-readable key type names selected in the Configurator, and the values are an object defining the parameters of that key type.
	
	Those parameters are:
		filename: SVG filename, with no folder path and without the ".svg" suffix.
		bottom: Z position where key sleeve should begin.
		top: If a number, Z position of top of key sleeve. If an array, Z-coordinates defining a non-flat top of the key sleeve.
		width: width of key.
		depth (optional): thickness of key head, if not the usual 1.8mm.
		text-vpos: amount by which to adjust the vertical position of the label text.
		wedges: Either a list of [x, z, width] values, or a list of lists like this, defining the center positions of triangular wedges meant to fit into holes in the key top to hold the sleeve on.
        
*/
KEYTYPES =
    [
    "KwikSet #66",
        ["filename", "kwikset-3-holes",
         "bottom", 3.47,
         "top", 14.8,
         "width", 22,
         "wedges", [[5.4,13.85,3.6], [16.6,13.85,3.6]]
        ],
    "HY-KO KW1",
        ["filename", "hy-ko-KW1",
         "bottom", 3,
         "top", 19.62,
         "width", 22.5,
         "wedges", [11.25,18.8,5]
        ],
    "MinuteKey - plain",
        ["filename", "minutekey-plain",
         "bottom", .56,
         "top", [11,17.2,17.2,11],
         "width", 22.2,
         "text-vpos", -1.8,
         "wedges", [11.1,16.29,2.5]
        ],
    "MinuteKey - cutout",
        ["filename", "minutekey-cutout",
         "bottom", 6.7,
         "top", 16.8,
         "width", 22.2,
         "wedges", [11.1,15.11,2.5]
        ],
    "Schlage #95",
        ["filename", "schlage-95",
         "bottom", 5.32,
         "top", [16,18.5,22.25,22.25,18.5,16],
         "width", 26.2,
         "depth", 2.4,
         "wedges", [13.1,21.4, 4]
        ],
    "Hillman #95",
        ["filename", "hillman-95",
         "bottom", 9,
         "top", [17,20,21.2,21.2,20,17],
         "width", 25,
         "wedges", [12.5,20.3, 4]
        ],
    "Ace KW1",
        ["filename", "ace-kw1",
         "bottom", 4,
         "top", [12,18.9,18.9,12],
         "width", 22.5,
         "text-vpos", -1.8,
         "wedges", [11.25,18.1, 4]
        ],
    "ILCO FA3",
        ["filename", "ilco-fa3",
         "bottom", 6.5,
         "top", [16,17,18,19,20,21,22.7,22.7,22.7,21.3,21.3,22.7,22.7,22.7,21,20,19,18,17,16],
         "width", 25.64,
         "text-vpos", -1.8,
         "wedges", [[9.2,21.9,2], [16.44,21.9,2]]
        ],
    "Unknown #1",
        ["filename","unknownkey1",
         "bottom", 6,
         "top", 20.45,
         "width", 22.3,
         "wedges", [11.15,19.6,5.5]]
    ];