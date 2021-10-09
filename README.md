# Indiv_Xray
Sketchup addon for creating "Xray" copies of individual groups/components.

<img src="./SOLID-ROOF.PNG">
<img src="./INVIS_ROOF.PNG">

# Installation
Install with the add-on manager using the .rbz file.

# Instructions
1. Select objects that are to be "Xray'd"
2. Run the addon by either:<br>
</t>-Selecting: Extensions>Indiv_Xray.<br>
</t>-Selecting the "Indiv_Xray" toolbar icon.
3. This creates semi-transparent objects in the exact locations of the existing objects. All "Xray" objects are placed in a layer titled "Individual_Xray".
  
# Notes:
- <b>Does not work on individual surfaces unless they are turned into groups beforehand.</b><br>
This is due to the way that sketchup handles ungrouped surfaces, if a surface is created in the same position as another, there is still only one selectable surface.
- <b>This extension will create it's own icon.</b>
- <b>This extension works by creating copies of materials and is also capable of handling materials with textures (even sketchup's included materials!!!).</b>

# Possible future features
- Support for surfaces (see above).

# Disclamer
<b> Use at your own risk. With that being said, I have tested it a bit and it seems to work fine. Also, everything *should* be fully reversible with undo.</b>
