clear; clc; close all; format long;

importPath = "E:\Flight Data\FullPulseTestData\Test31\data_1";

tic

fileID = fopen(importPath);
data = fread(fileID,10000000000000000,'uint32');

pps_count = [];
pps_time  = [];
dcc_time  = [];
pulsedata_a = [];
pulsedata_b = [];

tracker = 0;
j = 0;
for i=1:length(data)
    if data(i) == 2^32-1
        tracker = 0;
        j = j + 1;
    end
    if tracker == 1
        pps_count(j) = data(i);
    elseif tracker == 2
        pps_time(j) = data(i);
    elseif tracker == 3
        dcc_time(j) = data(i);
    elseif tracker < 36 && tracker > 0
        pulsedata_a(tracker-3,j) = typecast(uint16(mod(data(i),2^16))*4,'int16')/4;
        pulsedata_b(tracker-3,j) = typecast(uint16(data(i)/2^16)*4,'int16')/4;
    end
    tracker = tracker + 1;
end