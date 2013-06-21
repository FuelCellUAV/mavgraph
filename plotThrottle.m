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
    plot(mavlink_vfr_hud_t.throttle(:,1),mavlink_vfr_hud_t.throttle(:,2));
    datetick('x');
    ylabel('Throttle /%');
    xlabel('Time (mins)');
    title(strcat('Throttle of ./',FileName),'interpreter','none');
    
catch
    disp 'Error plotting'
end

clear FileName PathName FilterIndex;