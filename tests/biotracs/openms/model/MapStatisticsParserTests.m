classdef MapStatisticsParserTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    properties
        workingDir = [biotracs.core.env.Env.workingDir, '/biotracs/openms/MapStatisticsParserTests'];
    end
    
    methods (Test)
        
        function testParserFile(testCase)
            file = '../../../testdata/txt/QC1_B1_pos_20170328_019.txt';
            process = biotracs.openms.model.MapStatisticsParser();
            process.setInputPortData( 'DataFile', biotracs.data.model.DataFile(file) );
            process.run();
            extTable = process.getOutputPortData('ResourceSet').getAt(1);
            extTable.summary()
        end

    end
    
end
