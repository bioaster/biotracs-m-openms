classdef FeatureFinderMetaboTests < matlab.unittest.TestCase
    
    properties (TestParameter)
    end
    
    properties
        workingDir = [biotracs.core.env.Env.workingDir, '/biotracs/openms/FeatureFinderMetaboTests'];
    end

    methods (Test)
        
        function testWithLocalFiles(testCase)
            dataFile = biotracs.data.model.DataFile( [pwd, '/../../../testdata/mzML/BlankExtrac_B1_neg_20160921_067.mzML'] );
            dataFile2 = biotracs.data.model.DataFile( [pwd, '/../../../testdata/mzML/BlankExtrac_B1_neg_20160921_066.mzML'] );
            ds = biotracs.data.model.DataFileSet();
            ds.add(dataFile);
            ds.add(dataFile2);

            process = biotracs.openms.model.FeatureFinderMetabo();
            c = process.getConfig();
            process.setInputPortData('DataFileSet', ds);
            c.updateParamValue('NoiseThresholdInt', 1e5);
            c.updateParamValue('WorkingDirectory', testCase.workingDir);
            c.updateParamValue('UseShellConfigFile', true);
            process.run();
            results = process.getOutputPortData('DataFileSet');
            
            expectedOutputFilePaths = fullfile([ testCase.workingDir, '/BlankExtrac_B1_neg_20160921_067.featureXML']);
            expectedLogFilePath = fullfile([ testCase.workingDir, '/BlankExtrac_B1_neg_20160921_067.log']);

            testCase.verifyEqual( exist(expectedOutputFilePaths, 'file'), 2 );
            testCase.verifyEqual( exist(expectedLogFilePath, 'file'), 2 );
            testCase.verifyEqual( results.getLength(), 2 );
            testCase.verifyClass( results.getAt(1), 'biotracs.data.model.DataFile' );
            testCase.verifyEqual( results.getAt(1).getPath(), expectedOutputFilePaths );
            testCase.verifyEqual( results.getAt(1).exist(), true );
        end
  
          function testWithDirectInjection(testCase)
            wd = [testCase.workingDir, '/FeatureFinderMetaboDirectInjectionTests'];
            dataFile = biotracs.data.model.DataFile( [pwd, '/../../../testdata/mzML/04_cells_BHI_biorad_4h_40ul.mzML'] );
            dataFile2 = biotracs.data.model.DataFile( [pwd, '/../../../testdata/mzML/05_cells_BHI_biorad_4h_40ul.mzML'] );
            
            ds = biotracs.data.model.DataFileSet();
            ds.add(dataFile);
            ds.add(dataFile2);

            process = biotracs.openms.model.FeatureFinderMetabo();
            c = process.getConfig();
            process.setInputPortData('DataFileSet', ds);
            c.updateParamValue('NoiseThresholdInt', 1e5);
            c.updateParamValue('WorkingDirectory', wd);
            c.updateParamValue('QuantificationMethod', 'median');
            c.updateParamValue('ChromatographicFwhm', 90);
            c.updateParamValue('IsobaricMassSplitting', false);
            c.updateParamValue('EnableRtFiltering', false);
            c.updateParamValue('WidthFiltering', 'off');
            c.updateParamValue('MaxTraceLength', -1);
            process.run();
            results = process.getOutputPortData('DataFileSet');
            
            expectedOutputFilePaths = fullfile([ wd, '/04_cells_BHI_biorad_4h_40ul.featureXML']);
            expectedLogFilePath = fullfile([ wd, '/04_cells_BHI_biorad_4h_40ul.log']);

            testCase.verifyEqual( exist(expectedOutputFilePaths, 'file'), 2 );
            testCase.verifyEqual( exist(expectedLogFilePath, 'file'), 2 );
            testCase.verifyEqual( results.getLength(), 2 );
            testCase.verifyClass( results.getAt(1), 'biotracs.data.model.DataFile' );
            testCase.verifyEqual( results.getAt(1).getPath(), expectedOutputFilePaths );
            testCase.verifyEqual( results.getAt(1).exist(), true );
        end
  
    end
end