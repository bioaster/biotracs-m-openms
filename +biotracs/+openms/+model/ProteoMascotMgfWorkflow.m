% BIOASTER
%> @file		ProteoMascotMgfWorkflow.m
%> @class		biotracs.openms.model.ProteoMascotWorkflow
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016

classdef ProteoMascotMgfWorkflow <biotracs.core.mvc.model.Workflow
    
    properties(SetAccess = protected)
    end
    
    methods
        % Constructor
        function this = ProteoMascotMgfWorkflow( )
            this@biotracs.core.mvc.model.Workflow();
            this.doBuildProteoWorkflow();
        end
    end
    
    methods(Access = protected)
        function this = doBuildProteoWorkflow( this )
            this.doCreateMzFileImporter();
            this.doCreateMgfFileImporter();
            this.doCreateFastaFileImporter();
            this.doFileConvertingWorkflow();
            this.doMgfFileConvertingWorkflow();
            this.doPeptideIdentificationWorkflow();
            this.doFeatureExtractionWorkflow();
            this.doFeatureMappingWorkflow();
            this.doFeatureLinkingWorkflow();
            this.doProteinQuantifyingWorkflow();
            this.doConnectWorkflows();
        end
        
        function [ inputAdapter ] = doCreateMzFileImporter(this)
            inputAdapter = biotracs.core.adapter.model.FileImporter();
            this.addNode( inputAdapter, 'MzFileImporter' );
        end
        
        function [ inputAdapter ] = doCreateMgfFileImporter(this)
            inputAdapter = biotracs.core.adapter.model.FileImporter();
            this.addNode( inputAdapter, 'MgfFileImporter' );
        end
        
        function [ inputAdapter ] = doCreateFastaFileImporter( this )
            inputAdapter = biotracs.core.adapter.model.FileImporter();
            this.addNode( inputAdapter, 'FastaFileImporter' );
        end
        
        function [ convertingWorkflow ] = doFileConvertingWorkflow(this)
            convertingWorkflow = biotracs.openms.model.FileConvertingWorkflow();
            this.addNode(convertingWorkflow, 'FileConverting');
            convertingWorkflow.createInputPortInterface( 'FileConverter', 'DataFileSet' );
            convertingWorkflow.createOutputPortInterface( 'RtFileFilter', 'DataFileSet' );
        end
        
        function [ convertingMgfWorkflow ] = doMgfFileConvertingWorkflow(this)
            convertingMgfWorkflow = biotracs.openms.model.FileConvertingWorkflow();
            this.addNode(convertingMgfWorkflow, 'MgfFileConverting');
            convertingMgfWorkflow.createInputPortInterface( 'FileConverter', 'DataFileSet' );
            convertingMgfWorkflow.createOutputPortInterface( 'RtFileFilter', 'DataFileSet' );
        end
        
        function [ peptideIdentificationWorkflow ] = doPeptideIdentificationWorkflow(this)
            peptideIdentificationWorkflow = biotracs.openms.model.PeptideIdentificationMascotWorkflow();
            this.addNode(peptideIdentificationWorkflow, 'PeptideIdentification');
            peptideIdentificationWorkflow.createInputPortInterface( 'MascotAdapterOnline', 'DataFileSet' );
            peptideIdentificationWorkflow.createInputPortInterface( 'FastaImporterDemux', 'ResourceSet' );
            peptideIdentificationWorkflow.createOutputPortInterface( 'IDMergerPepIndex', 'DataFileSet' );
            peptideIdentificationWorkflow.createOutputPortInterface( 'IDFilter', 'DataFileSet' );
            peptideIdentificationWorkflow.createOutputPortInterface( 'FidoAdapter', 'DataFileSet' );
        end
        
        function [ featuresExctractionWorkflow ] = doFeatureExtractionWorkflow(this)
            featuresExctractionWorkflow = biotracs.openms.model.ProteoFeatureExtractionWorkflow();
            this.addNode(featuresExctractionWorkflow, 'FeatureExctraction');
            featuresExctractionWorkflow.createInputPortInterface( 'SnrFileFilter', 'DataFileSet' );
            featuresExctractionWorkflow.createOutputPortInterface( 'FeatureFinderCentroided', 'DataFileSet' );
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
            convertingWorkflow = this.getNode('FileConverting');
            mgfConvertingWorkflow = this.getNode('MgfFileConverting');
            peptideIdentificationWorkflow = this.getNode('PeptideIdentification');
            featuresExctractionWorkflow = this.getNode('FeatureExctraction');
            featuresMappingWorkflow  = this.getNode('FeatureMapping');
            featuresLinkingWorkflow = this.getNode('FeatureLinking');
            proteinQuantifyingWorkflow = this.getNode('ProteinQuantifying');
            mgfFileImporter = this.getNode('MgfFileImporter');
            mzFileImporter = this.getNode('MzFileImporter');
            fastaFileImporter = this.getNode('FastaFileImporter');
            
            %connect input file importers
            mzFileImporter.getOutputPort('DataFileSet').connectTo( convertingWorkflow.getInputPort('FileConverter:DataFileSet') );
            fastaFileImporter.getOutputPort('DataFileSet').connectTo( peptideIdentificationWorkflow.getInputPort('FastaImporterDemux:ResourceSet') );
            mgfFileImporter.getOutputPort('DataFileSet').connectTo( mgfConvertingWorkflow.getInputPort('FileConverter:DataFileSet') );
            
            convertingWorkflow.getOutputPort('RtFileFilter:DataFileSet').connectTo( featuresExctractionWorkflow.getInputPort('SnrFileFilter:DataFileSet') );
            mgfConvertingWorkflow.getOutputPort('RtFileFilter:DataFileSet').connectTo( peptideIdentificationWorkflow.getInputPort('MascotAdapterOnline:DataFileSet') );
            
            featuresExctractionWorkflow.getOutputPort('FeatureFinderCentroided:DataFileSet').connectTo( featuresMappingWorkflow.getInputPort('IDMapper:FeatureFileSet') );
            peptideIdentificationWorkflow.getOutputPort('IDFilter:DataFileSet').connectTo( featuresMappingWorkflow.getInputPort('IDMapper:IdFileSet') );
            featuresMappingWorkflow.getOutputPort('IDMapper:DataFileSet').connectTo( featuresLinkingWorkflow.getInputPort('MapAlignerPoseClustering:DataFileSet') );
            peptideIdentificationWorkflow.getOutputPort('FidoAdapter:DataFileSet').connectTo( proteinQuantifyingWorkflow.getInputPort('ProteinQuantifier:GroupProteinsFileSet') );
            featuresLinkingWorkflow.getOutputPort('FeatureLinkerUnlabeledQT:DataFileSet').connectTo( proteinQuantifyingWorkflow.getInputPort('ProteinQuantifier:FeatureFileSet') );
        end
    end
    
    methods(Access = protected)
    end
end