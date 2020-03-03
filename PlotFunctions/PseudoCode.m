function [OutputResults] = BuildModel
% Specify jj number of geometry excel input files
    for jj = 1:NumberOfGeometryInputFiles
        
        % Read in simple OrcaFlex template file
        % Read in jj'th geometry inputfile 
        
        for ii = 1:NumberOfSheets           
            % Read in ii'th sheet of jj'th excel file
            for i = 1:NumberOfLines 
                
                % Build MP
                % Build nacelle 
                % Build WT tower
                % Build i'th chain
                
            end                
            % Apply load 
            % Run simulation
            % Produce results
        end 
        
        % Save all results
        % Export results to main file
        % Plot results [OutputResults]from main file
        
    end    
    
end

