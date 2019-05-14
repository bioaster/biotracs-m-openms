classdef MapAlignerParserTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    properties
        workingDir = [biotracs.core.env.Env.workingDir, '/biotracs/openms/MapAlignerParserTests'];
    end
    
    methods (Test)
        
        function testParser(testCase)
            %return;
            file = '../../../testdata/csv/QC1_B1_pos_20170328_028.csv';
            process = biotracs.openms.model.MapAlignerParser();
            process.setInputPortData( 'DataFile', biotracs.data.model.DataFile(file) );
            process.run();
            extTable = process.getOutputPortData('ResourceSet').getAt(1);
            
        end
        
        function testParseFolder(testCase)
            return;
%             file = 'C:\Users\jabighanem\BIOASTER\Biocode\AlignmentAssessmentWorkflow\003-TextExporterMapAligner\';
            file = 'C:\Users\jabighanem\BIOASTER\Biocode\AlignmentAssessmentWorkflow_gd\003-TextExporterMapAligner\';

            process = biotracs.openms.model.MapAlignerParser();
            process.setInputPortData( 'DataFile', biotracs.data.model.DataFile(file) );
            process.run();

            
            extTable = process.getOutputPortData('ResourceSet');
%             extTable.bindView(biotracs.openms.view.MapAlign());
%             extTable.summary
            extTable.view('MzRtAlignment'); 

            extTable.view('PeakAlignment', 'Mz', {104.1069,202.2165, 270.0016} );
        end
        
    end
    
end
