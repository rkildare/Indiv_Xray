require 'sketchup.rb'
require 'extensions.rb'

module Rkildare
    module IndXray
        unless file_loaded?(__FILE__)
            ex = SketchupExtension.new('Individual Xray', 'Ind_Xray/main')
            ex.description = 'Xray view creater for individual groups.'
            ex.version = '1.0d'
            ex.creator = 'rkildare'
            Sketchup.register_extension(ex,true)
            file_loaded(__FILE__)
        end
    end
end