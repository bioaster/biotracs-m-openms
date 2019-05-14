% BIOASTER
% %> @file		ProteinQuantifierConfig.m
%> @class		biotracs.openms.model.ProteinQuantifierConfig
%> @link		http://www.bioaster.org
%> @copyright	Copyright (c) 2014, Bioaster Technology Research Institute (http://www.bioaster.org)
%> @license		BIOASTER
%> @date		2017


classdef ProteinQuantifierConfig < biotracs.openms.model.BaseProcessConfig
    
    properties(Constant)
        
    end
    
    properties(SetAccess = protected)
    end
    
    % -------------------------------------------------------
    % Public methods
    % -------------------------------------------------------
    
    methods
        
        % Constructor
        function this = ProteinQuantifierConfig( )
            this@biotracs.openms.model.BaseProcessConfig( );
            
			this.updateParamValue('OutputFileExtension','csv');
            this.createParam('ProteinGroups', '' , ...
                'Constraint',  biotracs.core.constraint.IsPath(  ),...
                'Description', 'Protein inference results for the identification runs that were used to annotate the input (e.g. from ProteinProphet via IDFileConverter or Fido via FidoAdapter).#br#Information about indistinguishable proteins will be used for protein quantification. (valid formats: idXML) ');
            this.createParam('PeptideOut', '', ...
                'Constraint',   biotracs.core.constraint.IsPath(  ),...
                'Description', 'Output file for peptide abundances. ');
            this.createParam('Top', 3 , ...
                'Constraint',  biotracs.core.constraint.IsPositive( 'Type', 'integer' ),...
                'Description', 'Calculate protein abundance from this number of proteotypic peptides (most abundant first; 0 for all). (default: 2) ');
            this.createParam('Average', 'mean' , ...
                'Constraint', biotracs.core.constraint.IsText(), ...
                'Description', 'Averaging method used to compute protein abundances from peptide abundances (valid: median, mean, sum). (default: median)');
            this.createParam('IncludeAllPeptides', true , ...
                'Constraint', biotracs.core.constraint.IsBoolean(), ...
                'Description', 'Include results for proteins with fewer proteotypic peptides than indicated by top (no effect if top is 0 or 1). (default: false)');
            this.createParam('FixPeptidesQuantification', true , ...
                'Constraint', biotracs.core.constraint.IsBoolean(), ...
                'Description', 'Use the same peptides for protein quantification across all samples. With top 0, all peptides that occur in every sample are considered.Otherwise (top N), the N peptides that occur in the most samples (independently of each other) are selected, breaking ties by total abundance (there is no guarantee that the best co-ocurring peptides are chosen!). (default: false)');
            
            
            this.optionSet.addElements(...
                'ProteinGroups', biotracs.core.shell.model.Option('-protein_groups "%s"'), ...
                'PeptideOut',  biotracs.core.shell.model.Option('-peptide_out "%s"'), ...
                'Top',  biotracs.core.shell.model.Option('-top "%g"'), ...
                'Average',  biotracs.core.shell.model.Option('-average "%s"' ), ...
                'IncludeAllPeptides',  biotracs.core.shell.model.Option('-include_all "%s"', 'FormatFunction', @(x)this.doFormatBoolean(x)), ...
                'FixPeptidesQuantification',  biotracs.core.shell.model.Option('-consensus:fix_peptides "%s"', 'FormatFunction', @(x)this.doFormatBoolean(x)) ...
                );
        end
        
    end
    
    % -------------------------------------------------------
    % Protected methods
    % -------------------------------------------------------
    
    methods(Access = protected)
        
    end
    
end
