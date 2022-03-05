%% A4

% (todo) Get number of counts for each time bin throughout the flight
% (todo) Look for cross corelations of events between payloads
% (todo) Add radiation Graphs

%%
%

FlightFolder = runFile();

PayloadPrefixes = {"1RED", "2GREEN", "3YELLOW", "4BLUE"};
PayloadColors = {"Red", "Green", "Yellow", "Blue"};
RadDetectorTypes = {"LYSO", "CLYC", "LYSO", "LYSO"};

if isfolder(FlightFolder + '6-Graphs') == 0
    mkdir(FlightFolder, '6-Graphs');
end

DirectoryLocation = strcat(FlightFolder,"3-Processed Data/");
DataLocation = strcat(FlightFolder,"5-FlightData/");
imagePath = strcat(FlightFolder,"6-Graphs/");
tic

if ~exist('PayloadEnvData','var')
    fprintf('Loading Environmental Data...\n');
    load(strcat(DirectoryLocation,"PayloadEnvData.mat"))
end

if ~exist('PayloadRadData','var')
    fprintf('Loading Radiation Data...\n');
    load(strcat(DirectoryLocation,"PayloadRadData.mat"))
end

if ~exist('FlightData','var')
    fprintf('Loading Flight Data...\n');
    load(strcat(DataLocation,"FlightData.mat"))
end


Stats = getStats(FlightData, PayloadEnvData, PayloadRadData, PayloadPrefixes);
makeGraphs(FlightData, PayloadEnvData, PayloadRadData, PayloadPrefixes, PayloadColors, Stats, imagePath);


createReport(Stats,imagePath)

toc