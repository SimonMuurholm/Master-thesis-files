model = ofxModel; % Create a new model
line = model.CreateObject(ofx.otLine, 'LineName'); % Create and name a line
line.Length(1) = 100; % Set the length of the first line section
model.RunSimulation; % Run the simulation
model.SaveSimulation('SavedSimulation.sim'); % Save the simulation
rangeResults = line.RangeGraph('Effective Tension'); % Extract result
rangeResults.Max % Display the range graph maximum values