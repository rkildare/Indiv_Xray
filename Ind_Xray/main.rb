require 'sketchup.rb'

module Rkildare
  module IndXray

    def self.stupid_routine(obj)
      basename = File.basename(obj.texture.filename)
      filename = File.join(Sketchup.temp_dir, basename)
      obj.texture.write(filename)
      return filename
    end


    def self.mmat(obj)
      model = Sketchup.active_model
      if !obj.nil?
        col = obj.name + "_Invis"
        if model.materials[col].nil?
          mat = model.materials.add(col)
          if !obj.texture.nil?
            file = stupid_routine(obj)
            mat.texture = file
            File.delete(file)#Clean-up
            mat.texture.size = obj.texture.width
          end
          mat.color = obj.color
          mat.alpha = 0.6
        else
          mat = model.materials[col]
        end
        return mat
      else
        return nil
      end
    end


    def self.search(obj)
      for ent in obj.entities
        if ent.is_a?(Sketchup::Face)
          ent.material = mmat(ent.material)
          ent.back_material = mmat(ent.back_material)
        elsif ent.is_a?(Sketchup::Group)
          ent.make_unique()
          ent.material = mmat(ent.material)
          search(ent)
        end
      end
    end


    def self.btmat(obj)
      if obj.material.nil?
        if !obj.parent.is_a?(Sketchup::Model)
          obj = obj.parent.instances[0]
          material = btmat(obj)
          return material
        else
          return nil
        end
      else
        return obj.material
      end
    end


    def self.beg(sel,model)
      groups = []
      for obj in sel
        if obj.is_a?(Sketchup::Group) or obj.is_a?(Sketchup::ComponentInstance)
          if obj.is_a?(Sketchup::ComponentInstance)
            trans = obj.transformation
            comat = obj.material
            obj = obj.definition
            newcom = model.active_entities.add_instance(obj,trans).make_unique
            newcom.material = comat
            tempg = newcom.definition
            newcom.material = mmat(btmat(newcom))
            groups << newcom
          else
            tempg = obj.copy
            tempg.material = mmat(btmat(obj))
            groups << tempg
          end
          search(tempg)
        end
      end
      return groups
    end


    def self.iXray
      model = Sketchup.active_model
      ss = model.selection
      
      if ss.empty?	## May remove this section. 
        UI.messagebox("No Selection")
        return nil
      end	## End may remove this section.

      model.start_operation 'Ind_Xray', true

      if model.layers["Individual_XRay"].nil?
        layer = model.layers.add "Individual_XRay"
      else
        layer = "Individual_XRay"
      end

      groups = beg(ss,model)
      for thing in groups
        thing.layer = layer
      end
      model.commit_operation
    end 

    ##UI stuff below
    #------Make the icon----
    icon = "BM\xF6\x06\x00\x00\x00\x00\x00\x006\x00\x00\x00(\x00\x00\x00\x18\x00\x00\x00\x18\x00\x00\x00\x01\x00\x18\x00\x00\x00\x00\x00\xC0\x06\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xBE\x92p\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xFF\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xE8\xA2\x00\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99\xEA\xD9\x99"
    #-----icon-----

    iconloc = File.join(Sketchup.temp_dir,"iconx.bmp")
    File.write(iconloc,icon)

    if not file_loaded?("Ind_Xray.rb") 
      
      toolbar = UI::Toolbar.new "Ind_Xray"
      cmd = UI::Command.new("Ind_Xray") { self.iXray }
      cmd.small_icon = iconloc
      cmd.large_icon = iconloc
      cmd.tooltip = "Individual_Xray"
      cmd.status_bar_text = "Provides Xray views of individual items."
      cmd.menu_text = "Individual_Xray"
      cmd.set_validation_proc{
        if Sketchup.active_model.selection.empty?
          MF_GRAYED | MF_DISABLED
        else
          MF_ENABLED
        end
      }
      toolbar = toolbar.add_item(cmd)
      toolbar.show()

      File.delete(iconloc)#Clean-up
      
      UI.menu("Plugins").add_separator
      UI.menu("Plugins").add_item("Individual_Xray") { self.iXray }
      file_loaded(__FILE__)
    end

  end # module IndXray
end # module Rkildare