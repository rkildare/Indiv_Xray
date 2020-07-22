require 'sketchup.rb'

##----STUPID STUPID DUMB ROUTINE----
#I haven't found a way to copy textures from SketchUp's included library directly. 
#So I decided, screw it, I'll save them to a temporary file so I can pass them to my materials.
#All so i can just make a stupid copy of the material and adjust the alpha on the copy instead of the original.

def stupid_routine(mat)
	basename = File.basename(mat.texture.filename)
	filename = File.join(Sketchup.temp_dir, basename)
	mat.texture.write(filename)
	p filename
	return filename
end

##----Make Materials----
def mmat(ent)
	model = Sketchup.active_model
	
	if (ent.parent.instances[0].typename == "Group")
		if(!ent.parent.instances[0].material.nil?)
			flag = true
		end
	end
	#----Front Side----
	#p ent.material.name
	if (ent.material.nil?)
		if(!ent.back_material.nil?)
			ent.material = ent.back_material
		else
			ent.material = fmat(ent)
		end
	end
	if (!ent.material.nil?)
		col = ent.material.name + "_Invis"
		#p model.materials[col].nil?
		if (model.materials[col].nil?)
			mat = model.materials.add(col)
			if (!ent.material.texture.nil?)
				mat.texture = stupid_routine(ent.material)
				mat.texture.size = ent.material.texture.width
			end
			mat.color = ent.material.color
			mat.alpha = 0.6
		else
			mat = model.materials[col]
		end
	end

	#----Back Side----
	if (ent.back_material.nil?)
		ent.back_material = ent.material
	end
	if(!ent.material.nil?)
		bcol = ent.back_material.name + "_Invis"
		if(model.materials[bcol].nil?)
			bmat = model.materials.add(bcol)
			if (!ent.material.texture.nil?)
				bmat.texture = stupid_routine(ent.back_material)
				bmat.texture.size = ent.back_material.texture.width
			end
			bmat.color = ent.back_material.color
			bmat.alpha = 0.6
		else
			bmat = model.materials[bcol]
		end
	end
	#p mat
	#p bmat
	return mat,bmat
end

##----Draw----
def draw(mat,bmat,ent)
	ent.material = mat
	ent.back_material = bmat
end

##----Find Material----
def fmat(f)
	if (f.material.nil?)
		if (f.parent.instances[0].typename == "Group")
			f = f.parent.instances[0]
			material = fmat(f)
			return material
		else
			return nil
		end
	else
		return f.material
	end
end

##----Face Search----
def fsearch(group)
	for ent in group.entities
		if ent.typename == "Face"
			
			mat,bmat = mmat(ent)
			#p mat
			#p bmat
			draw(mat,bmat,ent)
		elsif ent.typename == "Group"
			ent.make_unique
			fsearch(ent)
		end
	end
end


##----Group Search----
def beg(sel)
	groups = [] #Initialize an array to store new groups (to add to the Ind_Xray layer). 
	for obj in sel
		if obj.typename == "Group" #If an object is found to be a group, create a copy of it and store in a variable tempg (temp group).
			tempg = obj.copy #Note: When the copy is created, it places the new group in the exact position of the old one, so no need to reposition it.
			tempg.material = obj.material
			groups << tempg #Store tempg in the group array.
			fsearch(tempg)
		end
	end
	return groups
end ##def beg

##----Main Loop----
def tesa3
	
	model = Sketchup.active_model
	model.start_operation "tesa3" #Tell SU that tesa3 is starting
	ss = model.selection
	#p model.to_s + "main"

	##----Check if selection is empty----
	if ss.empty?
		UI.messagebox("No Selection.")
		return nil
	end

	##Check if Ind_XRay layer already exists. If not, create it. If so, set layer to that layer.
	if (model.layers["Individual_XRay"].nil?)
		layer = model.layers.add "Individual_XRay"
	else
		layer = "Individual_XRay"
	end

	groups = beg(ss)
	for thing in groups
		thing.layer = layer
	end
	
end ##def tesa3

##----UI Stuff Below----
##UI stuff below
#------Make the icon----
icon = "BM\xF6\x06\x00\x00\x00\x00\x00\x006\x00\x00\x00(\x00\x00\x00\x18\x00\x00\x00\x18\x00\x00\x00\x01\x00\x18\x00\x00\x00\x00\x00\xC0\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99"
#-----icon-----

iconloc = File.join(Sketchup.temp_dir,"iconx.bmp")
File.write(iconloc,icon)
toolbar = UI::Toolbar.new "Individual_Xray"
cmd = UI::Command.new("Ind_X") {
  tesa3
}
cmd.small_icon = iconloc
cmd.large_icon = iconloc
cmd.tooltip = "Individual_Xray"
cmd.status_bar_text = "Provides Xray views of individual items."
cmd.menu_text = "Individual_Xray"
toolbar = toolbar.add_item cmd
toolbar.show
File.delete(iconloc)

if( not file_loaded?("Ind_Xray.rb") )###

   UI.menu("Plugins").add_separator
   UI.menu("Plugins").add_item("Individual_Xray") { tesa3 }

end

###
file_loaded("Ind_Xray.rb")###