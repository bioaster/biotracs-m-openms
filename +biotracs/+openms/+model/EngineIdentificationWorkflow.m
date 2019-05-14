% BIOASTER
%> @file		EngineIdentificationWorkflow.m
%> @class		biotracs.openms.model.EngineIdentificationWorkflow
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef EngineIdentificationWorkflow < biotracs.core.mvc.model.Workflow
    
    properties(SetAccess = protected)
        nbFilesToResize;
    end
    
    methods
        % Constructor
        function this = EngineIdentificationWorkflow( )
            this@biotracs.core.mvc.model.Workflow();
            this.configType = 'biotracs.openms.model.EngineIdentificationWorkflowConfig';
            this.doEngineIdentificationWorkflow();
            
        end
    end
    
    
    
    methods(Access = protected)
        
        
        function doBeforeRun ( this )
            this.doBeforeRun@biotracs.core.mvc.model.Workflow( ) ;
            useXtandem = this.config.getParamValue('UseXTandem');
            useMascot = this.config.getParamValue('UseMascot');
            if contains(useMascot, 'true') && contains(useXtandem, 'true')
                disp('Using XTandem and Mascot Engine for peptides identification')
  
            elseif contains(useMascot, 'true') && contains(useXtandem, 'false')
                disp('Using Mascot engine for peptides identification')
                xtandemId = this.getNode('XtandemIdentification');
                mergeId =  this.getNode('MergeIdentification');
                 mux = this.getNode('MascotXtandemMux');
                xtandemId.setIsPhantom( true );
                mux.setIsPhantom( true ); 
                mergeId.setIsPhantom( true );
             elseif contains(useXtandem, 'true') && contains(useMascot, 'false')
                 disp('Using Xtandem engine for peptides identification')
                 mascotId = this.getNode('MascotIdentification');
                 mux = this.getNode('MascotXtandemMux');
                 mergeId =  this.getNode('MergeIdentification');
                 mascotId.setIsPhantom( true );
                 mux.setIsPhantom( true ); 
                 mergeId.setIsPhantom( true );
             end
            
%             mascotId = this.getNode('MascotIdentification');
%             xtandemId = this.getNode('XtandemIdentification');
%             
%             if  mascotId.isPhantom()
%                 disp('coucou mascot is Phantom')
%                 mux = this.getNode('MascotXtandemMux');
%                 mascot = mux.getInputPort('Resource#1');
%                 mascot.setIsRequired(false);
%                 
%             end
%             if  xtandemId.isPhantom()
%                 disp('coucou xtandem is Phantom')
%                 mux = this.getNode('MascotXtandemMux');
%                 xtandem = mux.getInputPort('Resource#2');
%                 xtandem.setIsRequired(false);
%                 
%             end
            
        end
        
        function this = doEngineIdentificationWorkflow( this )
            this.doCreateMzFileImporter();
            this.doCreateFastaFileImporter();
            this.doMascotIdentificationWorkflow();
            
            this.doXtandemIdentificationWorkflow();
            this.doMascotXtandemMux();
            this.doIdMerge();
            this.doConnectWorkflows();
        end
        
        function [ inputAdapter ] = doCreateMzFileImporter(this)
            inputAdapter = biotracs.core.adapter.model.FileImporter();
            this.addNode( inputAdapter, 'MzFileImporter' );
        end
        
        function [ inputAdapter ] = doCreateFastaFileImporter( this )
            inputAdapter = biotracs.core.adapter.model.FileImporter();
            this.addNode( inputAdapter, 'FastaFileImporter' );
        end
    
        
        function [ mascotIdWorkflow ] = doMascotIdentificationWorkflow(this)
            mascotIdWorkflow = biotracs.openms.model.MascotIdentificationWorkflow();
            this.addNode(mascotIdWorkflow, 'MascotIdentification');
            mascotIdWorkflow.createInputPortInterface( 'MascotAdapterOnline', 'DataFileSet' );
            mascotIdWorkflow.createOutputPortInterface( 'IDPosteriorErrorProbabilityMascotAdapterOnline', 'DataFileSet' );
        end
        
         function [ xtandemIdWorkflow ] = doXtandemIdentificationWorkflow(this)
            xtandemIdWorkflow = biotracs.openms.model.XtandemIdentificationWorkflow();
            this.addNode(xtandemIdWorkflow, 'XtandemIdentification');
            xtandemIdWorkflow.createInputPortInterface( 'XTandemAdapter', 'DataFileSet' );
            xtandemIdWorkflow.createInputPortInterface( 'FastaImporterDemux', 'ResourceSet' );
            xtandemIdWorkflow.createOutputPortInterface( 'IDPosteriorErrorProbabilityXtandem', 'DataFileSet' );
         end
         
         function [ mascotXtandemMux ] = doMascotXtandemMux(this)
             mascotXtandemMux = biotracs.core.adapter.model.Mux();
             mascotXtandemMux.getInput()...
                 .resize(2)...
                 .setIsResizable(false);
             this.addNode( mascotXtandemMux, 'MascotXtandemMux' );
         end
         
         function [ mergeIdWorkflow ] = doIdMerge( this )
           mergeIdWorkflow = biotracs.openms.model.MergeIdentificationWorkflow();
            this.addNode(mergeIdWorkflow, 'MergeIdentification');
            mergeIdWorkflow.createInputPortInterface( 'IDMerger', 'DataFileSet' );
            mergeIdWorkflow.createOutputPortInterface( 'ConsensusID', 'DataFileSet' );
         end
       
        function this = doConnectWorkflows(this)
            mascotIdWorkflow = this.getNode('MascotIdentification');
            xtandemIdWorkflow  = this.getNode('XtandemIdentification');
            mascotXtandemMux = this.getNode('MascotXtandemMux');
            mergeIdWorkflow = this.getNode('MergeIdentification');

            mzFileImporter = this.getNode('MzFileImporter');
            fastaFileImporter = this.getNode('FastaFileImporter');

            
            
            mascotId = this.getNode('MascotIdentification');
            xtandemId = this.getNode('XtandemIdentification');
            
            if  mascotId.isPhantom()
                disp('coucou mascot is Phantom')
                mzFileImporter.getOutputPort('DataFileSet').connectTo( xtandemIdWorkflow.getInputPort('XTandemAdapter:DataFileSet') );
                fastaFileImporter.getOutputPort('DataFileSet').connectTo( xtandemIdWorkflow.getInputPort('FastaImporterDemux:ResourceSet') );
                xtandemIdWorkflow.getOutputPort('IDPosteriorErrorProbabilityXtandem:DataFileSet').connectTo(mergeIdWorkflow.getInputPort('IDMerger:DataFileSet') );
                
            end
            if  xtandemId.isPhantom()
                disp('coucou xtandem is Phantom')
                mzFileImporter.getOutputPort('DataFileSet').connectTo( mascotIdWorkflow.getInputPort('MascotAdapterOnline:DataFileSet') );
                mascotIdWorkflow.getOutputPort('IDPosteriorErrorProbabilityMascotAdapterOnline:DataFileSet').connectTo(mergeIdWorkflow.getInputPort('IDMerger:DataFileSet') );
                
            end
            if ~mascotId.isPhantom() && ~xtandemId.isPhantom()
                disp('No Phantoms are around')
                %connect input file importers
                mzFileImporter.getOutputPort('DataFileSet').connectTo( xtandemIdWorkflow.getInputPort('XTandemAdapter:DataFileSet') );
                fastaFileImporter.getOutputPort('DataFileSet').connectTo( xtandemIdWorkflow.getInputPort('FastaImporterDemux:ResourceSet') );
                mzFileImporter.getOutputPort('DataFileSet').connectTo( mascotIdWorkflow.getInputPort('MascotAdapterOnline:DataFileSet') );
                mascotIdWorkflow.getOutputPort('IDPosteriorErrorProbabilityMascotAdapterOnline:DataFileSet').connectTo( mascotXtandemMux.getInputPort('Resource#1') );
                
                xtandemIdWorkflow.getOutputPort('IDPosteriorErrorProbabilityXtandem:DataFileSet').connectTo( mascotXtandemMux.getInputPort('Resource#2') );
                mascotXtandemMux.getOutputPort('ResourceSet').connectTo(mergeIdWorkflow.getInputPort('IDMerger:DataFileSet') );
            end
        end
        
    end
    
end

