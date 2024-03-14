/*
    objects.scad
    by Tyler Tork
    Supports a way of defining complex structures via arrays of alternating names and values, e.g.
    
    [
        "width", 40,
        "depth", 20.03,
        "supports", [12.3, 16, 20.8],
        ...
    ]
    
    This allows for more readable/maintainable definition of complex constellations of parameters.
    The values may also be "objects", allowing for a hierarchical structure.
    
    License: Creative Commons - Attribution
*/

/* function obj searches the "object" for a key value and returns the corresponding data item, or the specified default if key is not found.

    e.g. obj(["pitch", 32, "yaw", 7], "yaw") returns 7.
 */
function obj(data, name, default) =
    let
    (
        b=[for(ro=[0:2:len(data)-1]) if (data[ro] == name) data[ro+1]]
    )
    is_undef(b[0]) ? default : b[0] ;