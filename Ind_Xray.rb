require 'sketchup.rb'

###

def tesa2

model = Sketchup.active_model
model.start_operation "tesa2" #Tell SU that tesa2 is starting
ss = model.selection

if ss.empty? 
  UI.messagebox("No Selection.")
  return nil
end

if(model.layers["Individual_XRay"].nil?)
  layer = model.layers.add "Individual_XRay"
else
  layer = "Individual_XRay"
end

g2 = []
for obj in ss
  if obj.typename == "Group"
    temp = obj.copy
    g2 << temp
    for ent in temp.entities
      if ent.typename == "Face"

##This may cause problems, maybe remove
        if (ent.material.nil?)
	  if (!obj.material.nil?)
	    ent.material = obj.material
	  end
	end
##
	col = ent.material.name + "_invis"
	if (model.materials[col].nil?)
	  mat = model.materials.add(col)
	  
	  if (!ent.material.texture.nil?)
	    #This next section is BS and the only way to copy base textures
	    basename = File.basename(ent.material.texture.filename)
	    filename = File.join(Sketchup.temp_dir, basename)
	    ent.material.texture.write(filename)
	    #end BS section

	    mat.texture = filename
	    mat.texture.size = ent.material.texture.width
	  end
	  mat.color = ent.material.color
	  mat.alpha = 0.6
	end
	if (ent.back_material.nil?)
	  ent.back_material = ent.material
	end
	bcol = ent.back_material.name + "_invis"
	if (model.materials[bcol].nil?)
	  bmat = model.materials.add(bcol)

	  if (!ent.material.texture.nil?)
	    #This next section is BS and the only way to copy base textures
	    basename = File.basename(ent.back_material.texture.filename)
	    filename = File.join(Sketchup.temp_dir, basename)
	    ent.back_material.texture.write(filename)
	    #end BS section

	    bmat.texture = filename
	    bmat.texture.size = ent.back_material.texture.width
	  end
	  bmat.color = ent.back_material.color
	  bmat.alpha = 0.6
	end
	ent.material = model.materials[col]
	ent.back_material = model.materials[bcol]
      end
    end
  end
end


for thing in g2
  thing.layer = layer
end

end ##end of def



##UI stuff below
toolbar = UI::Toolbar.new "Individual_Xray"
# This toolbar icon simply displays Hello World on the screen
cmd = UI::Command.new("Ind_X") {
  tesa2
}
cmd.small_icon = "BOOP.bmp"
cmd.large_icon = "BOOP.bmp"
cmd.tooltip = "Individual_Xray"
cmd.status_bar_text = "Provides Xray views of individual items."
cmd.menu_text = "Individual_Xray"
toolbar = toolbar.add_item cmd
toolbar.show

if( not file_loaded?("Ind_Xray.rb") )###

   UI.menu("Plugins").add_separator
   UI.menu("Plugins").add_item("Individual_Xray") { tesa2 }

end

###
file_loaded("Ind_Xray.rb")###