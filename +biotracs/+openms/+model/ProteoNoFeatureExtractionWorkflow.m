% BIOASTER
%> @file		ProteoNoFeatureExtractionWorkflow.m
%> @class		biotracs.openms.model.ProteoNoFeatureExtractionWorkflow
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2017

classdef ProteoNoFeatureExtractionWorkflow <biotracs.core.mvc.model.Workflow
    
    properties(SetAccess = protected)
    end
    
    methods
        % Constructor
        function this = ProteoNoFeatureExtractionWorkflow( )
            this@biotracs.core.mvc.model.Workflow();
            this.doBuildProteoWorkflow();
        end
    end
    
    methods(Access = protected)
        function this = doBuildProteoWorkflow( this )
            this.doCreateMzFileImporter();
            this.doCreateConvertedFileImporter();
            this.doCreateFastaFileImporter();
            this.doPeptideIdentificationWorkflow();
            this.doFeatureMappingWorkflow();
            this.doFeatureLinkingWorkflow();
            this.doProteinQuantifyingWorkflow();
            this.doConnectWorkflows();
        end
        
        function [ inputAdapter ] = doCreateMzFileImporter(this)
            inputAdapter = biotracs.core.adapter.model.FileImporter();
            this.addNode( inputAdapter, 'MzFileImporter' );
        end
        
        function [ inputAdapter ] = doCreateConvertedFileImporter(this)
            inputAdapter = biotracs.core.adapter.model.FileImporter();
            this.addNode( inputAdapter, 'ConvertedFileImporter' );
        end
        
        function [ inputAdapter ] = doCreateFastaFileImporter( this )
            inputAdapter = biotracs.core.adapter.model.FileImporter();
            this.addNode( inputAdapter, 'FastaFileImporter' );
        end
         
        function [ peptideIdentificationWorkflow ] = doPeptideIdentificationWorkflow(this)
            peptideIdentificationWorkflow = biotracs.openms.model.PeptideIdentificationWorkflow();
            this.addNode(peptideIdentificationWorkflow, 'PeptideIdentification');
            peptideIdentificationWorkflow.createInputPortInterface( 'XTandemAdapter', 'DataFileSet' );
            peptideIdentificationWorkflow.createInputPortInterface( 'MascotAdapterOnline', 'DataFileSet' );
            peptideIdentificationWorkflow.createInputPortInterface( 'FastaImporterDemux', 'ResourceSet' );
            peptideIdentificationWorkflow.createOutputPortInterface( 'IDMergerPepIndex', 'DataFileSet' );
            peptideIdentificationWorkflow.createOutputPortInterface( 'IDFilter', 'DataFileSet' );
            peptideIdentificationWorkflow.createOutputPortInterface( 'FidoAdapter', 'DataFileSet' );
        end
        
        
        
        function [ featuresMappingWorkflow ] = doFeatureMappingWorkflow(this)
            featuresMappingWorkflow = biotracs.openms.model.ProteoFeatureMappingWorkflow();
            this.addNode(featuresMappingWorkflow, 'FeatureMapping');
            featuresMappingWorkflow.createInputPortInterface( 'IDMapper', 'FeatureFileSet' );
            featuresMappingWorkflow.createInputPortInterface( 'IDMapper', 'IdFileSet' );
            featuresMappingWorkflow.createOutputPortInterface( 'IDMapper', 'DataFileSet' );
        end
        
        function [ featuresLinkingWorkflow ] = doFeatureLinkingWorkflow(this)
            featuresLinkingWorkflow = biotracs.openms.model.ProteoFeatureLinkingWorkflow();
            this.addNode(featuresLinkingWorkflow, 'FeatureLinking');
            featuresLinkingWorkflow.createInputPortInterface( 'MapAlignerPoseClustering', 'DataFileSet' );
            featuresLinkingWorkflow.createOutputPortInterface( 'FeatureLinkerUnlabeledQT', 'DataFileSet' );
        end
        
        function [ proteinQuantifyingWorkflow ] = doProteinQuantifyingWorkflow(this)
            proteinQuantifyingWorkflow = biotracs.openms.model.ProteinQuantifyingWorkflow();
            this.addNode(proteinQuantifyingWorkflow, 'ProteinQuantifying');
            proteinQuantifyingWorkflow.createInputPortInterface( 'ProteinQuantifier', 'GroupProteinsFileSet' );
            proteinQuantifyingWorkflow.createInputPortInterface( 'ProteinQuantifier', 'FeatureFileSet' );
            proteinQuantifyingWorkflow.createOutputPortInterface( 'ProteinQuantifier', 'ProteinAbundanceFileSet' );
            proteinQuantifyingWorkflow.createOutputPortInterface( 'ProteinQuantifier', 'PeptideAbundanceFileSet' );
        end
        
        function this = doConnectWorkflows(this)
            convertedFileImport = this.getNode('ConvertedFileImporter');
            peptideIdentificationWorkflow = this.getNode('PeptideIdentification');
            featuresMappingWorkflow  = this.getNode('FeatureMapping');
            featuresLinkingWorkflow = this.getNode('FeatureLinking');
            proteinQuantifyingWorkflow = this.getNode('ProteinQuantifying');
            mzFileImporter = this.getNode('MzFileImporter');
            fastaFileImporter = this.getNode('FastaFileImporter');
            
            %connect input file importers
             fastaFileImporter.getOutputPort('DataFileSet').connectTo( peptideIdentificationWorkflow.getInputPort('FastaImporterDemux:ResourceSet') );
            
            convertedFileImport.getOutputPort('DataFileSet').connectTo( peptideIdentificationWorkflow.getInputPort('MascotAdapterOnline:DataFileSet') );
            convertedFileImport.getOutputPort('DataFileSet').connectTo( peptideIdentificationWorkflow.getInputPort('XTandemAdapter:DataFileSet') );
            
            peptideIdentificationWorkflow.getOutputPort('IDFilter:DataFileSet').connectTo( featuresMappingWorkflow.getInputPort('IDMapper:IdFileSet') );
            mzFileImporter.getOutputPort('DataFileSet').connectTo( featuresMappingWorkflow.getInputPort('IDMapper:FeatureFileSet') );
           
            featuresMappingWorkflow.getOutputPort('IDMapper:DataFileSet').connectTo( featuresLinkingWorkflow.getInputPort('MapAlignerPoseClustering:DataFileSet') );
            peptideIdentificationWorkflow.getOutputPort('FidoAdapter:DataFileSet').connectTo( proteinQuantifyingWorkflow.getInputPort('ProteinQuantifier:GroupProteinsFileSet') );
            featuresLinkingWorkflow.getOutputPort('FeatureLinkerUnlabeledQT:DataFileSet').connectTo( proteinQuantifyingWorkflow.getInputPort('ProteinQuantifier:FeatureFileSet') );
      
        
        
        end
    end
    
    methods(Access = protected)
    end
end