% BIOASTER
%> @file		BaseProcess.m
%> @class		biotracs.openms.model.BaseProcess
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2017

classdef (Abstract)BaseProcess < biotracs.core.shell.model.Shell
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = BaseProcess()
            %#function biotracs.openms.model.BaseProcessConfig biotracs.data.model.DataFileSet
            
            this@biotracs.core.shell.model.Shell();
            this.configType = 'biotracs.openms.model.BaseProcessConfig';
            
            % enhance inputs specs
            this.setInputSpecs({...
                struct(...
                'name', 'DataFileSet',...
                'class', 'biotracs.data.model.DataFileSet' ...
                )...
                });

            % enhance outputs specs
            this.setOutputSpecs({...
                struct(...
                'name', 'DataFileSet',...
                'class', 'biotracs.data.model.DataFileSet' ...
                )...
                });
        end

        %-- E --
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)

        function this = doAttachDefaultConfig( this )
            this.doAttachDefaultConfig@biotracs.core.shell.model.Shell();
            this.config.setProcessName( this.getClassNameParts('head') );
        end
        
    end

end
