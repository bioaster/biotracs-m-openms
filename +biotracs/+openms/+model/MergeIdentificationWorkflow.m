% BIOASTER
%> @file		MergeIdentificationWorkflow.m
%> @class		biotracs.openms.model.MergeIdentificationWorkflow
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef MergeIdentificationWorkflow < biotracs.core.mvc.model.Workflow
    
    properties(SetAccess = protected)
    end
    
    methods
        % Constructor
        function this = MergeIdentificationWorkflow( )
            this@biotracs.core.mvc.model.Workflow();
            this.doMergeIdentificationWorkflow();
        end
    end
    
    methods(Access = protected)
        
        function this = doMergeIdentificationWorkflow( this )
            %Add FileImporter 'mzXML'
            mzFileImporterXT = biotracs.core.adapter.model.FileImporter();
            this.addNode( mzFileImporterXT, 'MzFileImporterXT' );

            mzFileImporterMascot = biotracs.core.adapter.model.FileImporter();
            this.addNode( mzFileImporterMascot, 'MzFileImporterMascot' );
            
            %Add Demux
            mascotXtandemMux = biotracs.core.adapter.model.Mux();
            mascotXtandemMux.getInput()...
                .resize(2)...
                .setIsResizable(false);
            this.addNode( mascotXtandemMux, 'MascotXtandemMux' );

            mascotXtandemMux.getInput().setPortNameByIndex(1, 'XTandemDataFileSet');
            mascotXtandemMux.getInput().setPortNameByIndex(2, 'MascotDataFileSet');

            %Add IdMerger
            idMerger = biotracs.openms.model.IDMerger();
            this.addNode( idMerger, 'IDMerger' );
            
            %Add ConsensusId
            consensusId = biotracs.openms.model.ConsensusID();
            this.addNode( consensusId, 'ConsensusID' );

            mzFileImporterXT.getOutputPort('DataFileSet').connectTo( mascotXtandemMux.getInputPort('XTandemDataFileSet'));
            mzFileImporterMascot.getOutputPort('DataFileSet').connectTo( mascotXtandemMux.getInputPort('MascotDataFileSet'));
            mascotXtandemMux.getOutputPort('ResourceSet').connectTo( idMerger.getInputPort('DataFileSet'));
            idMerger.getOutputPort('DataFileSet').connectTo(consensusId.getInputPort('DataFileSet'));
        end
        
        function doBeforeRun( this, varargin )
            hasOnlyOneInputPortData = ~(this.getInputPort('MascotXtandemMux:XTandemDataFileSet').isRequired() && ...
                    this.getInputPort('MascotXtandemMux:MascotDataFileSet').isRequired());
                
            this.setIsPhantom(hasOnlyOneInputPortData);
        end
        
    end
    
end

