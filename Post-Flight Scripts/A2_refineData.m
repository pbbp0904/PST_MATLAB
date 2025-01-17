%% A2

% (todo) Check for missed seconds
% (todo) Try to speed up subSecond calculation

%%
%FlightFolder = "D:/Flight Data/Testing/Database Test/";
%FlightFolder = "C:\Users\Sean\Desktop\UAH\SHC\HELEN\HELEN_Data\Flight 2\";
%FlightFolder = "D:\Flight Data\Flight 2\";
%FlightFolder = "D:\Flight Data\Flight 2\";
%FlightFolder = "D:\MATLAB\HELEN Data\Flight 2\";
FlightFolder = runFile();

PayloadPrefixes = {"1RED", "2GREEN", "3YELLOW", "4BLUE"};
PayloadColors = {"Red", "Green", "Yellow", "Blue"};
RadDetectorTypes = {"LYSO", "CLYC", "LYSO", "LYSO"};

if isfolder(FlightFolder + '4-Datastore') == 0
    mkdir(FlightFolder, '4-Datastore');
end

DirectoryLocation = strcat(FlightFolder,"3-Processed Data/");
tic

if ~exist('PayloadEnvData','var')
    fprintf('Loading Environmental Data...\n');
    load(strcat(DirectoryLocation,"PayloadEnvData.mat"))
end

if ~exist('PayloadRadData','var')
    fprintf('Loading Radiation Data...\n');
    load(strcat(DirectoryLocation,"PayloadRadData.mat"))
end

% Suppress preallocation warnings
%#ok<*SAGROW>


%% Refine Env Data

% For each payload
for payloadNumber = 1:length(PayloadEnvData)
    % Project back GPS time to start
    fprintf('Projecting GPS Time for payload %i...\n',payloadNumber);
    PayloadEnvData{payloadNumber}.gpsTimes = projectBackTime(PayloadEnvData{payloadNumber}.gpsTimes);  

    % Add cartesian distance from SWIRLL
    fprintf('Calculating Cartesian Distances for payload %i...\n',payloadNumber);
    [PayloadEnvData{payloadNumber}.xEast, PayloadEnvData{payloadNumber}.yNorth, PayloadEnvData{payloadNumber}.zUp] = calcSWIRLLDistance(PayloadEnvData{payloadNumber}.gpsLats, PayloadEnvData{payloadNumber}.gpsLongs, PayloadEnvData{payloadNumber}.gpsAlts);

    % Save Env Data
    fprintf('Saving Enviornmental Data for payload %i...\n',payloadNumber);
    writeEnvToDatastore(PayloadEnvData{payloadNumber}, FlightFolder, payloadNumber);
    fprintf('Done Saving Enviornmental Data for payload %i...\n',payloadNumber);
end

%% Refine Rad Data
for payloadNumber = 1:length(PayloadRadData)
    % Calculate subsecond values for pulses
    fprintf('Finding Subsecond Values for payload %i...\n',payloadNumber);
    [PayloadRadData{payloadNumber}.ppsTimeCorrected, PayloadRadData{payloadNumber}.subSecond] = findSubSeconds(PayloadRadData{payloadNumber}.pps_time, PayloadRadData{payloadNumber}.dcc_time);

    % Add missing pulses to the data table
    fprintf('Adding in Missed Pulses for payload %i...\n',payloadNumber);
    PayloadRadData{payloadNumber} = addMissedPulses(PayloadRadData{payloadNumber});
    
    % Pulse Pile Up
    %fprintf('Finding Pulse Pile Ups for payload %i...\n',payloadNumber);
    %PayloadRadData{payloadNumber}.PeakNumber = getPeakNumber(PayloadRadData{payloadNumber}.pulsedata_b);
    
    % Particle Type - Seth 
    %fprintf('Finding Particle Type for payload %i...\n',payloadNumber);
    %PayloadRadData{payloadNumber} = particleType(PayloadRadData{payloadNumber});
    
    % Energy - Sean
    fprintf('Finding Energies for payload %i...\n',payloadNumber);
    [PayloadRadData{payloadNumber}.EPeakA, PayloadRadData{payloadNumber}.EIntA, PayloadRadData{payloadNumber}.EPeakB, PayloadRadData{payloadNumber}.EIntB] = getEnergies(PayloadRadData{payloadNumber}.pulsedata_a, PayloadRadData{payloadNumber}.pulsedata_b, RadDetectorTypes{payloadNumber});
    
    % Pulse Tail
    fprintf('Finding Tails for payload %i...\n',payloadNumber);
    PayloadRadData{payloadNumber}.isTail = isTail(PayloadRadData{payloadNumber}.dcc_time,PayloadRadData{payloadNumber}.pulsedata_b);
    
    % Save Rad Data
    fprintf('Saving Radiation Data for payload %i...\n',payloadNumber);
    writeRadToDatastore(PayloadRadData{payloadNumber}, FlightFolder, payloadNumber);
    fprintf('Done Saving Radiation Data for payload %i...\n',payloadNumber);
end

toc