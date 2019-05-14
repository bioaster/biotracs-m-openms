% BIOASTER
%> @file		Controller.m
%> @class		biotracs.openms.controller.Controller
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef Controller < biotracs.core.mvc.controller.Controller
    
    properties(SetAccess = protected)
    end
    
    methods

        % Constructor
        function this = Controller( )
            this@biotracs.core.mvc.controller.Controller();  
            
            metaboWorkflow = biotracs.openms.model.MetaboWorkflow();
            this.add( metaboWorkflow, 'MetaboWorkflow' );
            
            proteoWorkflow = biotracs.openms.model.ProteoWorkflow();
            this.add( proteoWorkflow, 'ProteoWorkflow' );
            
            proteoMgfWorkflow = biotracs.openms.model.ProteoMgfWorkflow();
            this.add( proteoMgfWorkflow, 'ProteoMgfWorkflow' );
            
            proteoMascotWorkflow = biotracs.openms.model.ProteoMascotWorkflow();
            this.add( proteoMascotWorkflow, 'ProteoMascotWorkflow' );
            
            proteoMascotMgfWorkflow = biotracs.openms.model.ProteoMascotMgfWorkflow();
            this.add( proteoMascotMgfWorkflow, 'ProteoMascotMgfWorkflow' );
            
            proteoNoFeatureExtractionWorkflow = biotracs.openms.model.ProteoNoFeatureExtractionWorkflow();
            this.add( proteoNoFeatureExtractionWorkflow, 'ProteoNoFeatureExtractionWorkflow' );
          
            proteoMascotMgfNoFeatureExtractionWorkflow = biotracs.openms.model.ProteoMascotMgfNoFeatureExtractionWorkflow();
            this.add( proteoMascotMgfNoFeatureExtractionWorkflow, 'ProteoMascotMgfNoFeatureExtractionWorkflow' );
       
        end

    end

    methods(Access = protected)
  
        
    end
end

