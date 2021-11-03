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
    
    PayloadRadData{i}.radSeconds = radSeconds';
    PayloadRadData{i}.PacketNum = EnvDataInterp(:,1);
    PayloadRadData{i}.Pitch = EnvDataInterp(:,2);
    PayloadRadData{i}.Roll = EnvDataInterp(:,3);
    PayloadRadData{i}.Yaw = EnvDataInterp(:,4);
    PayloadRadData{i}.AccX = EnvDataInterp(:,5);
    PayloadRadData{i}.AccY = EnvDataInterp(:,6);
    PayloadRadData{i}.AccZ = EnvDataInterp(:,7);
    PayloadRadData{i}.GyroX = EnvDataInterp(:,8);
    PayloadRadData{i}.GyroY = EnvDataInterp(:,9);
    PayloadRadData{i}.GyroZ = EnvDataInterp(:,10);
    PayloadRadData{i}.MagX = EnvDataInterp(:,11);
    PayloadRadData{i}.MagY = EnvDataInterp(:,12);
    PayloadRadData{i}.MagZ = EnvDataInterp(:,13);
    PayloadRadData{i}.IMUTemp = EnvDataInterp(:,14);
    PayloadRadData{i}.HPSTemp = EnvDataInterp(:,15);
    PayloadRadData{i}.EXTTemp = EnvDataInterp(:,16);
    PayloadRadData{i}.BATTemp = EnvDataInterp(:,17);
    PayloadRadData{i}.PMTTemp = EnvDataInterp(:,18);
    PayloadRadData{i}.gpsPacketNums = EnvDataInterp(:,19);
    PayloadRadData{i}.gpsTimes = EnvDataInterp(:,20);
    PayloadRadData{i}.gpsLats = EnvDataInterp(:,21);
    PayloadRadData{i}.gpsLongs = EnvDataInterp(:,22);
    PayloadRadData{i}.gpsSpeeds = EnvDataInterp(:,23);
    PayloadRadData{i}.gpsAngles = EnvDataInterp(:,24);
    PayloadRadData{i}.gpsAlts = EnvDataInterp(:,25);
    PayloadRadData{i}.gpsSatNum = EnvDataInterp(:,26);
    PayloadRadData{i}.gpsLatErrs = EnvDataInterp(:,27);
    PayloadRadData{i}.gpsLongErrs = EnvDataInterp(:,28);
    PayloadRadData{i}.gpsAltErrs = EnvDataInterp(:,29);
    PayloadRadData{i}.gpsClkBiases = EnvDataInterp(:,30);
    PayloadRadData{i}.gpsClkDrifts = EnvDataInterp(:,31);
    PayloadRadData{i}.TimeErrs = EnvDataInterp(:,32);
end


end