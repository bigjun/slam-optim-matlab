function [vertices, edges]=loadFromFile(dataFileGraph)
vertices=[];
edges=[];
fid = fopen(dataFileGraph);
if isempty(fid)
    disp('Cannot open the file ');
else
    %errorMesage=cat(2,'Reading data from file: ',dataFileGraph,'...');
    %disp(errorMesage)
    lines=textscan(fid,'%s','delimiter','\n');
    fclose(fid);
    n=size(lines{1},1); % nombre de liniesma
    
    for i=1:n
        text=lines{1}(i);
        text=cell2mat(text);
        line=textscan(text,'%s');
        if strcmp('VERTEX2',line{1}(1)) || strcmp('VERTEX',line{1}(1))
            v=[];
            for j=2:size(line{1},1)
                v=[v,str2num(cell2mat(line{1}(j)))];
            end
            vertices=[vertices;v];
        elseif strcmp('EDGE2',line{1}(1)) || strcmp('EDGE',line{1}(1))
            e=[];
            for j=2:size(line{1},1)
                e=[e,str2num(cell2mat(line{1}(j)))];
            end
            edges=[edges;e];
        elseif strcmp('ODOMETRY',line{1}(1))
            odo=[];
            for j=2:size(line{1},1)
                odo=[odo,str2num(cell2mat(line{1}(j)))];
            end
            edges=[edges;odo];
        elseif strcmp('LANDMARK',line{1}(1))
            land=[];
            for j=2:size(line{1},1)
                land=[land,str2num(cell2mat(line{1}(j)))];
            end
            edges=[edges;land];
        elseif strcmp('VERTEX3',line{1}(1)) || strcmp('VERTEX',line{1}(1))
            v=[];
            for j=2:size(line{1},1)
                v=[v,str2num(cell2mat(line{1}(j)))];
            end
            vertices=[vertices;v];
        elseif strcmp('EDGE3',line{1}(1)) || strcmp('EDGE',line{1}(1))
            e=[];
            for j=2:size(line{1},1)
                e=[e,str2num(cell2mat(line{1}(j)))];
            end
            edges=[edges;e];
        end
    end
end