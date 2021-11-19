
% Plotting environmental stuff
for i = 1:width(PayloadEnvData{1})
figure()
t = tiledlayout(2,2);
t.Padding = 'compact';
t.TileSpacing = 'compact';
for payload = 1:4
nexttile
plot(table2array(PayloadEnvData{payload}(:,i)))
title(sprintf("Payload %i: %s",payload, PayloadEnvData{payload}.Properties.VariableNames{i}))
end
end

% Plotting radiation data
for i = [1:5,8,9]
figure()
t = tiledlayout(2,2);
t.Padding = 'compact';
t.TileSpacing = 'compact';
for payload = 1:4
nexttile
plot(table2array(PayloadRadData{payload}(:,i)))
title(sprintf("Payload %i: %s",payload, PayloadRadData{payload}.Properties.VariableNames{i}))
end
end

% Plotting timing data
figure()
hold on
plot((PayloadRadData{2}.pps_time(1760000:1763000)-min(PayloadRadData{2}.pps_time(1760000:1763000)))./max((PayloadRadData{2}.pps_time(1760000:1763000)-min(PayloadRadData{2}.pps_time(1760000:1763000)))))
plot((PayloadRadData{2}.dcc_time(1760000:1763000)-min(PayloadRadData{2}.dcc_time(1760000:1763000)))./max((PayloadRadData{2}.dcc_time(1760000:1763000)-min(PayloadRadData{2}.dcc_time(1760000:1763000)))))
plot((PayloadRadData{2}.subSecond(1760000:1763000)-min(PayloadRadData{2}.subSecond(1760000:1763000)))./max((PayloadRadData{2}.subSecond(1760000:1763000)-min(PayloadRadData{2}.subSecond(1760000:1763000)))))


% Pulses
figure()
for pulse = 1:height(PayloadRadData{4})
if ~isnan(PayloadRadData{4}.pulsedata_b(pulse,1))
plot(-PayloadRadData{4}.pulsedata_b(pulse,:))
ylim([0 3000])
drawnow
pause
end
end


% Light curves
[lightCurve,lightCurveReal] = makeLightCurveEnergyTailFiltered(PayloadRadData,2,0.1,0,8000);
plot(lightCurve)