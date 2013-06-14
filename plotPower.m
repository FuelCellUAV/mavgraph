clc
clear all

%% Get MAVLink .mat file
[FileName,PathName,FilterIndex] = uigetfile(...
    'C:\Users\Simon\Documents\GitHub\mavgraph\*.mat','MAVLink mat file');
if FileName <= 0
    return;
end

%% Load
load(strcat(PathName,FileName));
volts = mavlink_sys_status_t.voltage_battery(:,2)/1000;
amps  = mavlink_sys_status_t.current_battery(:,2)/100;
power = volts.*amps;
start = datenum(2013,05,02,12,07,00);
stop  = datenum(2013,05,02,12,07,30);

%% Plot
try
    myplot = figure;
    plot(...
        mavlink_sys_status_t.current_battery(:,1),power);
       
    title(strcat('Power of ./',FileName),'interpreter','none');
    xlabel('Time (global)');
    ylabel('Power /W');
    xlim([start stop]); ylim([0 1000]);
    datetick('x','MM:SS','keepticks');
    grid on;
    
    saveas(myplot,strcat(strrep(FileName,'.mat','-power.fig')));
catch
    disp 'Error plotting'
end

clearvars -except mavlink*;