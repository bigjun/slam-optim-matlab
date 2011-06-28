function [d, H1, H2]=Absolute2RelativeLandmark(type,P1,pt)
switch type
    case 'rb'
        h=AbsolutePoint2RBObs(P1,pt); % Expectation
        [H1 H2]=AbsolutePoint2RBObsJacobian(P1,pt);
        d=z-h;
        d(end)=pi2pi(d(end));
    case 'dxdy'
        h=AbsolutePoint2RelativePoint(P1,pt); % Expectation
        [H1 H2]=AbsoluteRelativePointJacobian(P1,pt);
        d=z-h;
    otherwise
        error('unknown observation type');
end