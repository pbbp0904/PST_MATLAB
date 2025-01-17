payload = 2;
maxE = 8100;
figure();
F = FlightData(FlightData.PayloadNumber==payload,:);
b = F.EPeakA;

b = b(boolean(~F.isTail),:);
bp = b;
b = b(b<maxE,:);
b = b(1:end,:);


d = F.time;
d = d(boolean(~F.isTail),:);
d = d(bp<maxE,:);
d = d(1:end,:);
b = b(d~=0,:);
d = d(d~=0,:);

try
    h=hist3([b,d],[round((max(b)-min(b))/40),round((max(d)-min(d))/1)],'EdgeColor','none','CDataMode','auto','FaceColor','interp');
    imagesc(0:max(d),min(b):max(b),h,'AlphaData',h)
    colormap('jet')
    set(gca, 'ColorScale', 'log')
    set(gca,'YDir','normal')

    caxis([1, max(max(h))])
catch
end
han = colorbar;
view(2)

title(sprintf('Channel A Energy Waterfall for Payload %i',payload))
xlabel('Time (s)')
ylabel('Energy (bin)')
ylabel(han, 'Counts/bin') % Colorbar label