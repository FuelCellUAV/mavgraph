clc
clear all

%% Get MAVLink .mat file
[FileName,PathName,FilterIndex] = uigetfile(...
    'C:\Users\Simon\Documents\GitHub\mavgraph\*.mat','MAVLink mat file',datestr(date,'yyyy-mm-dd'));
if FileName <= 0
    return;
end

%% Load
load(strcat(PathName,FileName));

%% Get start and end time
pcStart = input('Enter starting %: ')/100;
pcEnd   = input('Enter ending %: ')/100;

%% Create figure
plotRows = 2;
plotCols = 2;
currentPlot = 1;
%figure;

%% Plot throttle
try
    subplot(plotRows,plotCols,currentPlot);
    currentPlot = currentPlot + 1;
    len = length(mavlink_vfr_hud_t.throttle);
    rowStart = round(pcStart * len)+1;
    rowEnd   = round(pcEnd * len);
    plot(mavlink_vfr_hud_t.throttle(rowStart:rowEnd,1),mavlink_vfr_hud_t.throttle(rowStart:rowEnd,2));
    datetick('x','keepticks');
    grid on;
    axis tight;
    set(gca,'FontSize',14);
    ylabel('Throttle /%', 'FontSize', 16);
    xlabel('Time (UTC)', 'FontSize', 16);
    title('Throttle', 'FontSize', 20);
catch
    disp 'Error plotting throttle'
    return
end

%% Plot power
try
    subplot(plotRows,plotCols,currentPlot);
    currentPlot = currentPlot + 1;
    len = length(mavlink_sys_status_t.voltage_battery);
    rowStart = round(pcStart * len)+1;
    rowEnd   = round(pcEnd * len);
    
    power = zeros(len,1);
    for i=1:len
        power(i,1) = (mavlink_sys_status_t.voltage_battery(i,2)./1000) .* ...
        (mavlink_sys_status_t.current_battery(i,2)./100);
    end
    
    plot(mavlink_sys_status_t.voltage_battery(rowStart:rowEnd,1),...
        power(rowStart:rowEnd,1));
    datetick('x','keepticks');
    grid on;
    axis tight;
    set(gca,'FontSize',14);
    ylabel('Power /W', 'FontSize', 16);
    xlabel('Time (UTC)', 'FontSize', 16);
    title('Power', 'FontSize', 20);  
catch
    disp 'Error plotting power'
end

%% Plot voltage
try
    subplot(plotRows,plotCols,currentPlot);
    currentPlot = currentPlot + 1;
    len = length(mavlink_sys_status_t.voltage_battery);
    rowStart = round(pcStart * len)+1;
    rowEnd   = round(pcEnd * len);
    plot(mavlink_sys_status_t.voltage_battery(rowStart:rowEnd,1),mavlink_sys_status_t.voltage_battery(rowStart:rowEnd,2)./1000);
    datetick('x','keepticks');
    grid on;
    axis tight;
    set(gca,'FontSize',14);
    ylabel('Voltage /V', 'FontSize', 16);
    xlabel('Time (UTC)', 'FontSize', 16);
    title('Voltage', 'FontSize', 20);
catch
    disp 'Error plotting voltage'
end

%% Plot current
try
    subplot(plotRows,plotCols,currentPlot);
    currentPlot = currentPlot + 1;
    len = length(mavlink_sys_status_t.current_battery);
    rowStart = round(pcStart * len)+1;
    rowEnd   = round(pcEnd * len);
    plot(mavlink_sys_status_t.current_battery(rowStart:rowEnd,1),mavlink_sys_status_t.current_battery(rowStart:rowEnd,2)./100);
    datetick('x','keepticks');
    grid on;
    axis tight;
    set(gca,'FontSize',14);
    ylabel('Current /A', 'FontSize', 16);
    xlabel('Time (UTC)', 'FontSize', 16);
    title('Current', 'FontSize', 20);
catch
    disp 'Error plotting current'
    return
end

clear FileName PathName FilterIndex;