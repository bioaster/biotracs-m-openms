% BIOASTER
%> @file		FileConverterConfig.m
%> @class		biotracs.openms.model.FileConverterConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2016


classdef FileConverterConfig < biotracs.openms.model.BaseProcessConfig
	 
	 properties(Constant)
	 end
	 
	 properties(SetAccess = protected)
	 end

	 % -------------------------------------------------------
	 % Public methods
	 % -------------------------------------------------------
	 
	 methods
		  
		  % Constructor
		  function this = FileConverterConfig( )
				this@biotracs.openms.model.BaseProcessConfig( );
				this.updateParamValue('OutputFileExtension','mzML');
		  end
 
	 end
	 
	 % -------------------------------------------------------
	 % Protected methods
	 % -------------------------------------------------------
	 
	 methods(Access = protected)
	 
	 end

end
