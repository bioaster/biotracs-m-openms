% BIOASTER
%> @file		ProteinQuantifyingWorkflow.m
%> @class		biotracs.openms.model.ProteinQuantifyingWorkflow
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef ProteinQuantifyingWorkflow < biotracs.core.mvc.model.Workflow
    
    properties(SetAccess = protected)
    end
    
    methods
        
        % Constructor
        function this = ProteinQuantifyingWorkflow( )
            this@biotracs.core.mvc.model.Workflow();
            this.doProteinQuantifyingWorkflow();
        end
        
    end
    
    methods(Access = protected)
        
        function this = doProteinQuantifyingWorkflow( this )
            %Add FileImporter 'mzXML'
            fidoFileImporter = biotracs.core.adapter.model.FileImporter();
            this.addNode( fidoFileImporter, 'FidoFileImporter' );    

            %Add FileImporter 'mzXML'
            inputPeptidesAdapter = biotracs.core.adapter.model.FileImporter();
            this.addNode( inputPeptidesAdapter, 'ListOfPeptidesImporter' );
           
            %Add ProteinQuantifier
            proteinQuantifier = biotracs.openms.model.ProteinQuantifier();
            this.addNode( proteinQuantifier, 'ProteinQuantifier' );

            fidoFileImporter.getOutputPort('DataFileSet').connectTo(proteinQuantifier.getInputPort('GroupProteinsFileSet'));
            inputPeptidesAdapter.getOutputPort('DataFileSet').connectTo(proteinQuantifier.getInputPort('FeatureFileSet'));
        end
        
    end
    
end

