function [lightCurve,lightCurveReal] = makeLightCurveEnergyTailPSDFiltered(PayloadRadData,payloadNumber,timeBinSize,minHeight,maxHeight)

dcc_time = PayloadRadData{payloadNumber}.dcc_time;
pulsedata_a = PayloadRadData{payloadNumber}.pulsedata_a;
pulsedata_b = PayloadRadData{payloadNumber}.pulsedata_b;
isTail = PayloadRadData{payloadNumber}.isTail;

clockHz = 50000000;

% Inverse Time Difference
lightCurveReal = clockHz./mod(dcc_time(2:end)-dcc_time(1:end-1),clockHz);

% Windowed Counts
second = 0;
tempPulseData = [];
lightCurve = [];
temp_time = 0;
j = 1;
for i = 2:length(dcc_time)
    if dcc_time(i)+100000<dcc_time(i-1) || dcc_time(i) > clockHz*timeBinSize + temp_time
        j = 1;
        lightCurve(second+1) = sum(tempPulseData);
        
        second = second + 1;
        tempPulseData = [];
        temp_time = dcc_time(i);
    end
    if max(abs(pulsedata_b(i,:))) > minHeight && max(abs(pulsedata_b(i,:))) < maxHeight
        if ~isTail(i)
            if (mean(-pulsedata_a(i,4:9)') > 1800 && mean(-pulsedata_a(i,4:9)') < 3300 && mean(-pulsedata_a(i,9:end)') > 1200 && mean(-pulsedata_a(i,9:end)') < 5000)
                tempPulseData(j) = 1;
                j = j + 1;
            end
        end
    end
end


end

