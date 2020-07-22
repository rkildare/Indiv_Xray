# Indiv_Xray
Sketchup addon for creating "Xray" copies of individual groups.

# Installation
Either install with the add-on manager using the .rbz file or paste the .rb file in your sketchup addons folder directly.

# Instructions
1. Select groups that are to be "Xray'd"
2. Run the addon by either:<br>
</t>-Selecting: Extensions>Indiv_Xray.<br>
</t>-Selecting the "Indiv_Xray" toolbar icon.
3. This creates semi-transparent groups in the exact locations of the existing groups. All "Xray" groups are placed in a layer titled "Individual_Xray".
  
# Notes:
- <b>Does not work on components. It will skip them all together.</b><br>
Components are a little weird in how they should be properly handled. Using this current method for groups on components will not work. I am trying to think of a workaround without being too complex.
- <b>Does not work on individual surfaces unless they are turned into groups beforehand.</b><br>
This is due to the way that sketchup handles ungrouped surfaces, if a surface is created in the same position as another, there is still only one selectable surface.
- <b>This extension will create it's own icon.</b>
- <b>This extension works by creating copies of materials and is also capable of handling materials with textures (even sketchup's included materials!!!).</b>

# Possible future features
- Support for components and surfaces (see above).

# Disclamer
<b> Use at your own risk. I am brand new to Ruby and pretty new to SketchUp for that matter and I am learning the weird quirks of each. With that being said, I have tested it a bit and it seems to work fine. Also, everything *should* be fully reversable with undo.</b>
