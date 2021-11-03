function [f] = mergeRadEnvData(PayloadRadData, PayloadEnvData)
startingRADSecond = 9; 

%mergedDataTables
for i = 2:2:4
    subSeconds = PayloadRadData{i}.subSecond;
    dcc_time = PayloadRadData{i}.dcc_time;
    pps_time = PayloadRadData{i}.pps_time;

    radSeconds = zeros(1,length(subSeconds));
    radSeconds(1) = startingRADSecond;
    lastj = -100;
    for j = 2:length(subSeconds)
        if (dcc_time(j-1) < pps_time(j-1) && dcc_time(j) >= pps_time(j) && dcc_time(j) >= pps_time(j-1)) || (pps_time(j-1) == 0 && dcc_time(j)+100000<dcc_time(j-1))
            radSeconds(j) = radSeconds(j-1)+1;
            lastj = j;
        else
            radSeconds(j) = radSeconds(j-1);
        end
    end

    EnvDataInterp = zeros(length(subSeconds),32);
    tic
    interpVals = [2:18,21,22,23,24,25,30,31];
    otherVals = [1,19,20,26,27,28,29,32];

    for m = interpVals
        x = PayloadEnvData{i}.PacketNum;
        v = table2array(PayloadEnvData{i}(:,m));
        xq = radSeconds+subSeconds';
        EnvDataInterp(:,m) = interp1(x,v,xq);
    end
    
    for m = otherVals
        x = PayloadEnvData{i}.PacketNum;
        v = table2array(PayloadEnvData{i}(:,m));
        xq = radSeconds;
        EnvDataInterp(:,m) = interp1(x,v,xq);
    end

    PayloadRadData{i}.PacketNum = EnvDataInterp(:,1);
    
    
    
end


end