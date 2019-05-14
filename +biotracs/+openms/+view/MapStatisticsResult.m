% BIOASTER
%> @file		MapStatisticsResult.m
%> @class		biotracs.openms.view.MapStatisticsResult
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2017


classdef MapStatisticsResult <  biotracs.core.mvc.view.BaseObject
    
    properties(SetAccess = protected)
    end
    
    methods
        
        function h = viewQcFeatureDistribution( this, varargin )
            p = inputParser();
%             p.addParameter('ListOfQc', {}, @iscell); 
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            % check data
            model = this.getModel();
            dataMatrix = model.getAt(1);
            
            m = getSize(dataMatrix,1);
            n = getLength(model);
            allNbFeatures  = zeros(m,n);
            allRtBegin =  zeros(m,n);
            allRtEnd=  zeros(m,n);
            
            for i = 1:n
                dataMatrix = model.getAt(i);
                dataMatrixNbFeatures = dataMatrix.getDataByColumnName('^NumberOfFeatures$');
                dataMatrixRtBegin = dataMatrix.getDataByColumnName('^RtBegin$');
                dataMatrixRtEnd = dataMatrix.getDataByColumnName('^RtEnd$');
                
                allNbFeatures(:,i) =  dataMatrixNbFeatures;
                allRtBegin(:,i)=  dataMatrixRtBegin;
                allRtEnd(:,i) = dataMatrixRtEnd;
            end
            
            
            nbFeaturesDm = biotracs.data.model.DataMatrix(allNbFeatures);

            rtBegin = biotracs.data.model.DataMatrix(allRtBegin);
            rtEnd = biotracs.data.model.DataMatrix(allRtEnd);
            
            meanRtBegin = rtBegin.mean('Direction', 'row');
            meanRtEnd = rtEnd.mean('Direction', 'row');
            stdRtBegin = rtBegin.std('Direction', 'row');
            stdRtEnd = rtEnd.std('Direction', 'row');
            tick = [meanRtBegin.data,stdRtBegin.data, meanRtEnd.data, stdRtEnd.data ];

            tickLabel = arrayfun( @(x)( sprintf(['%1.0f' char(177) '%1.1f ; %1.0f' char(177) '%1.1f '],tick(x,:)) ), 1:length(tick) ,  'UniformOutput', false);
          
            cv = nbFeaturesDm.varcoef('Direction', 'row');
            cvCell = num2cell(cv.data);
            legendLabel= cellfun(@(x)(sprintf('%1.2f',x)), cvCell, 'UniformOutput', false);
            h = nbFeaturesDm.view('BoxPlot', 'Direction', 'rows', 'TickLabel', tickLabel, 'XLabel', 'Slices', 'YLabel', 'Number of Features', 'LabelOrientation', 'horizontal' );
            xtickangle(45);
            hLegend = legend(findall(gca,'Tag','Box'), legendLabel, 'Location', 'southeast');
            title(hLegend, 'CV of Slices'); 
        end
        
        
    end
    
    methods(Access = protected)
        
    end
    
end
