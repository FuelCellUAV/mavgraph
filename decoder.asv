clc
clear all

%% Get log file
[FileName,PathName,FilterIndex] = uigetfile('C:\Users\Simon\Dropbox\PhD\Flight tests\*.csv','MAVLink csv file');

fid = fopen(strcat(PathName,FileName));
file = textscan(fid,'%s','delimiter','\n');
fclose(fid);
clear fid PathName FileName FilterIndex ans

%% Decode & packetise
data = struct;
for x=1:size(file{1,1},1)
    oldline = file{1,1}{x,1};
    
    for y=1:length(strfind(oldline,','))
        [newline{y},oldline] = strtok(oldline,',');
    end
    
    try
        len = size(data.(newline{8}),1) + 1;
    catch exception
        len = 1;
    end
    
    for z=1:size(newline,2)
        data.(newline{8}){len,z} = newline{z};
    end
    % all packets IDs are now listed as a variable in the "data" structure
end
clearvars -except data

%% Decode packets
packetlist = fieldnames(data);
for x=1:size(packetlist,1) % find variable in structure
    for y=1:size(data.(packetlist{x}),1) % find next row in variable
        thisline = data.(packetlist{x})(1,:);
        
        % time of row in serial format
        time = datenum(strrep(data.mavlink_vfr_hud_t(x,1),'T',' '));
        name = thisline{8};
        
        for z=9:2:size(thisline,2)
            out.(thisline{8})(thisline{9}){y,1} = str2double(thisline(10));
        end
    end
end

%% Parse mavlink_vfr_hud_t

% Airspeed
try
    for x=1:size(data.mavlink_vfr_hud_t,1)
        vfr_hud.airspeed(x,1) = str2double(data.mavlink_vfr_hud_t(x,10));
    end
catch exception
    disp "No airspeed data"
end

% Groundspeed
try
    for x=1:size(data.mavlink_vfr_hud_t,1)
        vfr_hud.groundspeed(x,1) = str2double(data.mavlink_vfr_hud_t(x,12));
    end
catch exception
   disp "No groundspeed data"
end

% Altitude
try
    for x=1:size(data.mavlink_vfr_hud_t,1)
        vfr_hud.altitude(x,1) = str2double(data.mavlink_vfr_hud_t(x,14));
    end
catch exception
    disp "No altitude data"
end

% Throttle
try
    for x=1:size(data.mavlink_vfr_hud_t,1)
        vfr_hud.throttle(x,1) = str2double(data.mavlink_vfr_hud_t(x,20));
    end
catch exception
    disp "No throttle data"
end

% Time
try
    for x=1:size(data.mavlink_vfr_hud_t,1)
        time = strrep(data.mavlink_vfr_hud_t(x,1),'T',' ');
        vfr_hud.time(x,1) = datenum(time);
    end
catch exception
    disp "No time data"
end

clear exception x

%% End
disp "Done!"