% BIOASTER
%> @file		MapAlignerResult.m
%> @class		biotracs.openms.view.MapAlignerResult
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2017


classdef MapAlignerResult <  biotracs.core.mvc.view.BaseObject
    
    properties(SetAccess = protected)
    end
    
    methods
        
        function h = viewMzRtAlignment( this, varargin )
            p = inputParser();            
            p.KeepUnmatched = true;
            p.parse(varargin{:});

            % check data
            model = this.getModel();
            n = getLength(model);
            rgb = biotracs.core.color.Color.colormap();
            %             n = 1;
            h= figure ;
            for i = 1:n
                
                dataMatrix = model.getAt(i);
                dataMatrixMzRt = dataMatrix.selectByColumnName('^(Mz|Rt)$');
                rt = dataMatrixMzRt.data(:,1);
                mz = dataMatrixMzRt.data(:,2);
                plot(rt ,mz, 'Marker', '+', 'LineStyle', 'none','Color', rgb(i,:));
%                 dataMatrixMzRt.view('Plot', 'NewFigure', false, 'Marker', '+', 'Style', 'o');
                hold on;
                xlabel('RT');
                ylabel('M/Z');
                
            end
        end
        
        function h = viewPeakAlignment( this, varargin )
            p = inputParser();
            p.addParameter('Mz', @iscell);
            p.KeepUnmatched = true;
            p.parse(varargin{:});
            
            nbMz= length(p.Results.Mz);
            
            for j= 1: nbMz
                h= figure ;
%                 mzPlus2p5ppm = p.Results.Mz{j} + (p.Results.Mz{j}*2.5 /1e6);
%                 mzMinus2p5ppm = p.Results.Mz{j} - (p.Results.Mz{j}*2.5 /1e6);
                mzPlus2p5ppm = p.Results.Mz{j} + 0.002;
                mzMinus2p5ppm = p.Results.Mz{j} - 0.002;
              
                
                % check data
                model = this.getModel();
                n = getLength(model);
                %n = 1;
                rgb = biotracs.core.color.Color.colormap();
                index = model.getAt(1);
                indexIntensity = index.getColumnIndexesByName('^Intensity$');
                indexRt = index.getColumnIndexesByName('^Rt$');             
                indexFwhm= index.getColumnIndexesByName('^FWHM$'); 
                lineNames = model.elementNames();
                allMu= [];
                for i = 1:n
                    dataMatrix = model.getAt(i);
                    
                    selectedMz = dataMatrix.select('WhereColumns', '^Mz$', 'Between', [mzMinus2p5ppm ,mzPlus2p5ppm]);
                selectedMz.summary()
                    if isempty(selectedMz.data)
                        continue;
                    else
                        A = selectedMz.getDataAt(indexIntensity);
                        
                        mu = selectedMz.getDataAt(indexRt);
                        
                        allMu = [allMu,mu];
                        fwhm = selectedMz.getDataAt(indexFwhm);
                        
                        sigma =  fwhm/2;
                        
                        x = (mu-fwhm*2):0.05:(mu+fwhm*2);
                        
                        fx =  A.*exp(-((x-mu)./sigma).^2);
                        
                        %                         Fx = [Fx, fx];
                        ax1 = subplot(1,1,1);
                        
                        plot(x, fx, 'Color', rgb(i,:));
                        title(['Mz=' num2str(p.Results.Mz{j})]);
                        
                        lines =ax1.Children;
                        
                        lines(1).Tag = lineNames{i};
                        dcm_obj = datacursormode(h);
                        set(dcm_obj,'UpdateFcn', @myupdatefcn);
                        
                        hold on;
                        xlabel('RT');
                        ylabel('Intensity');
                        
                    end
                    
                end
                
                if isempty(x)
                    continue;
                else
                    muDataMatrix = biotracs.data.model.DataMatrix(allMu);
                    cv = muDataMatrix.varcoef('Direction', 'rows');
                    text((max(x)/1.1), max(fx), ['cv =' num2str(sprintf('%1.2f', cv.data) )])
                end
            end
                          
            function tagName = myupdatefcn(~,event)
                tagName = get(event.Target,'Tag');
            end
            
        end
        
    end
    
    methods(Access = protected)
        
    end
    
end
