tic
%DirectoryLocation = "D:/Flight Data/Flight 3/3-Processed Data/";
%load(strcat(DirectoryLocation,"Rad-Env_Data.mat"))
%toc

%% Todo

%A3
%Check for missed seconds
%Fix sub second calculation
%Fix combining payload data slowness

%%
fprintf('Finding Subsecond Values...\n');
PayloadRadData = findSubSeconds(PayloadRadData);
fprintf('Adding in Missed Pulses...\n');
PayloadRadData = addMissedPulses(PayloadRadData);
fprintf('Projecting GPS Time...\n');
PayloadEnvData = projectBackTime(PayloadEnvData);

mergedDataTables = mergeRadEnvData(PayloadRadData, PayloadEnvData);
clearvars -except mergedDataTables
FlightData = combinePayloadData(mergedDataTables);
clearvars -except FlightData
FlightData = sortrows(FlightData,'gpsTimes');
disp('Done Combining Data!')
toc