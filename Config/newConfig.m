function [Config]=newConfig(Config,dm)

ndx=1:Config.PoseDim;


while ndx(end) <= Config.size
    if size(ndx,2)==Config.PoseDim
        if (sum(Config.vector(ndx,2))==Config.PoseDim)
            %pose
            switch Config.PoseDim
                case 3
                    Config.vector(ndx,1)=Config.vector(ndx,1)+dm(ndx,1);
                    Config.vector(ndx(end),1)=pi2pi(Config.vector(ndx(end)));
                case 6
                    Config.vector(ndx,1)=smartPlus(Config.vector(ndx,1),dm(ndx,1));
                otherwise
                    error('Unknown pose type');
            end
        else
            %landmark
            Config.vector(ndx,1)=Config.vector(ndx,1)+dm(ndx,1);
        end
    end
    if (ndx(end) < Config.size)
        if (Config.vector(ndx(end)+1,2)==1)
            ndx=ndx(end)+[1:Config.PoseDim];
        else
            ndx=ndx(end)+[1:Config.LandDim];
        end
    else
        ndx=ndx+1;
    end
end

