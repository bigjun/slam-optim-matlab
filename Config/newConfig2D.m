function [Config]=newConfig2D(Config,dm)

Config.vector(:,1)=Config.vector(:,1)+dm;
ndx=1:Config.PoseDim;

while ndx < Config.size
    if size(ndx,2)==Config.PoseDim
        if (sum(Config.vector(ndx,2))==Config.PoseDim)
            Config.vector(ndx(end),1)=pi2pi(Config.vector(ndx(end)));
        else
            error('This is not a pose');
        end
    end
    if Config.vector(ndx(end)+1,2)==1
        ndx=ndx(end)+[1:Config.PoseDim];
    else
        ndx=ndx(end)+[1:Config.LandDim];
    end
end

