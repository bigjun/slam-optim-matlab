function Data=getFake3DDataFrom2D(dataSet,pathToolbox,saveFile,maxID)

[vertices,edges]=loadDataSet(dataSet,pathToolbox,saveFile);
if strcmp(dataSet,'10KHOGMan')
    % Incremental feed for edges
    edges=sortrows(edges,[1,-2]); %TODO Change the dataset so that the edges come incrementaly
end
[vert,ed]=cut2maxID(maxID, vertices, edges);

[nVert]=size(vert,1);
[nEd]=size(ed,1);

vert3D=zeros(nVert,8);

for i=1:nVert
    % TODO here I need to convert from Euler to quaternions 
    r=0;
    p=0;
    y=vert(i,4);
    q=Euler2Quaternions(r,p,y);
    vert3D(i,:)=[vert(i,1:3),0,q];
end

ed3D=zeros(nEd,30);
for i=1:nEd
    %Transform to quaternions
    r=0;
    p=0;
    y=ed(i,5);
    q=Euler2Quaternions(r,p,y);
    ed3D(i,:)=[ed(i,1:4),0,q',1 0 0 0 0 0 1 0 0 0 0 1 0 0 0 100 0 0 100 0 100 ];
end


size(ed)
Data.nVert=nVert;
Data.nEd=nEd;
Data.name=dataSet;
Data.ed=ed3D;
Data.vert=vert3D;