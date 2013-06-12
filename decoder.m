clc
clear all

%% Get log file
[FileName,PathName,FilterIndex] = uigetfile('C:\Users\Simon\Dropbox\PhD\Flight tests\*.csv','MAVLink csv file');

fid = fopen(strcat(PathName,FileName));
file = textscan(fid,'%s','delimiter','\n');
fclose(fid);
%clear fid PathName FileName FilterIndex ans

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
%clearvars -except data

%% Decode packets
packetlist = fieldnames(data);
for x=1:size(packetlist,1) % find variable in structure
    thispacket = data.(packetlist{x});
    for y=1:size(thispacket,1) % find next row in variable
        thisline = thispacket(y,:);
        
        % time of row in serial format
        try
            time = datenum(strrep(thisline(1,1),'T',' '));
            name = thisline{8};
        catch
            continue
        end
        
        for z=9:2:size(thisline,2)
            try
                out.(thisline{8}).(thisline{z}){y,1} = str2double(thisline(z+1));
            catch
                continue;
            end
        end
    end
end
%clearvars -except out

%% Save and end
save(strrep(FileName,'csv',''),'-struct','out');
disp(strcat('Saved to ./',FileName,'.mat'));
clear all

%% End
disp "Done!"