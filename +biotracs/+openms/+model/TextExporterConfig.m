% BIOASTER
%> @file		TextExporterConfig.m
%> @class		biotracs.openms.model.TextExporterConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016


classdef TextExporterConfig < biotracs.openms.model.BaseProcessConfig
	 
	 properties(Constant)
	 end
	 
	 properties(SetAccess = protected)
	 end

	 % -------------------------------------------------------
	 % Public methods
	 % -------------------------------------------------------
	 
	 methods
		  
		  % Constructor
		  function this = TextExporterConfig( )
				this@biotracs.openms.model.BaseProcessConfig( );
				this.updateParamValue('OutputFileExtension','csv');
                this.setDescription('Exports various XML formats to a text file.');
		  end
 
	 end
	 
	 % -------------------------------------------------------
	 % Protected methods
	 % -------------------------------------------------------
	 
	 methods(Access = protected)
	 
	 end

end
