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

%% Plot
try
    figure;
    plot(mavlink_sys_status_t.current_battery(:,1),mavlink_sys_status_t.current_battery(:,2)./100);
    datetick('x');
    ylabel('Current /A');
    xlabel('Time (mins)');
    title(strcat('Current of ./',FileName),'interpreter','none');
    
catch
    disp 'Error plotting'
end

clear FileName PathName FilterIndex;