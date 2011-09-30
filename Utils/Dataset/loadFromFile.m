function [vertices, edges]=loadFromFile(dataFileGraph)

fid = fopen(dataFileGraph);
if isempty(fid) || (fid < 3)
    error('Cannot open the file %s.\n', dataFileGraph);
end
    
%errorMesage=cat(2,'Reading data from file: ',dataFileGraph,'...');
%disp(errorMesage)
lines = textscan(fid,'%s','delimiter','\n');
lines = lines{1}; %% to avoid using lines{1} later on
fclose(fid);

n = size(lines,1); % nombre de liniesma
vert_strings = {'VERTEX','VERTEX2','VERTEX3'};
edge_strings = {'EDGE','EDGE2','EDGE3','ODOMETRY','LANDMARK'};

vertex_cell = cell(n,1);
edge_cell = cell(n,1);
current_vert = 1;
current_edge = 1;

for i=1:n
    text=lines(i);
    text=cell2mat(text);
    LINE=textscan(text,'%s'); %% avoid 'line'; it is a matlab builtin

    kind_of_meas = LINE{1}{1};
    vert_or_edge = str2num(strvcat(LINE{1}{2:end}))';
    switch kind_of_meas,
        case vert_strings,
            vertex_cell{current_vert} = vert_or_edge;
            current_vert = current_vert + 1;

        case edge_strings,
            edge_cell{current_edge} = vert_or_edge;
            current_edge = current_edge + 1;

        otherwise
            error('Option %s not known.\n', kind_of_meas);
    end
end

vertices = cat(1, vertex_cell{1:current_vert - 1} );
edges    = cat(1,   edge_cell{1:current_edge - 1} );