function PlotConfig(varargin)

% PlotConfig(varargin)
% The script plots the current config
% It can either take struct parameters:
%       PlotConfig(Plot,Config,Graph,'r','b');
% or nonstruct parameters
%       PlotConfig(plot_mesurements,config,factors,id2config,poseDim,color1,landDim,color2);
% Returns the relinearized system: System
% Author: Viorela Ila

if isstruct(varargin{1})&& isstruct(varargin{2})
    Plot=varargin{1};
    Config=varargin{2};
    Graph=varargin{3};
    c1=varargin{4};
    c2=varargin{5};
    vector=Config.vector;
    F=Graph.F;
    id2config=Config.id2config;
    PoseDim=Config.PoseDim;
    LandDim=Config.LandDim;
    plot_mesurements=Plot.measurement;
else
    if nargin<7
        error('PlotConfig needs 7 parameters')
    else
        plot_mesurements=varargin{1};
        vector=varargin{2};
        F=varargin{3};
        id2config=varargin{4};
        PoseDim=varargin{5};
        c1=varargin{6};
        LandDim=varargin{7};
        c2=varargin{8};
    end
end

%plot the edges
nEdges=size(F,1);
p1{nEdges} = [];
p2{nEdges} = [];
for i=1:nEdges
    s1=F(i).data(2);
    s2=F(i).data(1);
    pl=F(i).data(end);
    if pl==99999
        dim=LandDim;
        ndx1=[PoseDim*id2config((s1+1),1)+LandDim*id2config((s1+1),2)]+[1:dim];
        ndx2=[PoseDim*id2config((s2+1),1)+PoseDim+LandDim*id2config((s2+1),2)]+[1:dim]-LandDim;
        c=c2;
    else
        dim=PoseDim;
        ndx1=[PoseDim*id2config((s1+1),1)+LandDim*id2config((s1+1),2)]+[1:dim];
        ndx2=[PoseDim*id2config((s2+1),1)+LandDim*id2config((s2+1),2)]+[1:dim];
        c=c1;
        
    end

    p1{i}=vector(ndx1,1); % The estimation of the two poses
    p2{i}=vector(ndx2,1);
    if pl==99999 
        if plot_mesurements
            if i==nEdges
                c='m';
                line([p1{i}(1) p2{i}(1)],[p1{i}(2) p2{i}(2)],'Color',c); hold on;
            end
        plot(p2{i}(1),p2{i}(2),'*','Color',c);
        %line([p1{i}(1) p2{i}(1)],[p1{i}(2) p2{i}(2)],'Color',c); hold on;
        end
    else
        line([p1{i}(1) p2{i}(1)],[p1{i}(2) p2{i}(2)],'Color',c); hold on;
    end
end
axis equal