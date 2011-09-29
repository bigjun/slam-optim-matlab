function ie=InvertEdgeLandmark(e,obsType,poseDof)
d=zeros(2,1);
switch obsType
    case 'rb'
        r=e(1);
        b=e(2);
        d(1)=r*cos(b);
        d(2)=r*sin(b);
        ie=AbsolutePoint2RBObs(zeros(poseDof,1),d);  
    case 'dxdy'
        d(1)=e(3);
        d(2)=e(4);
        ie=AbsolutePoint2RelativePoint(zeros(poseDof,1),d);
    otherwise
        error('unknown observation type');
end