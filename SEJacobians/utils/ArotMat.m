
function Ln=ArotMat(varargin)
if nargin==1
     rd11=varargin{1}(1,1);
     rd12=varargin{1}(1,2);
     rd13=varargin{1}(1,3);
     rd21=varargin{1}(2,1);
     rd22=varargin{1}(2,2);
     rd23=varargin{1}(2,3);
     rd31=varargin{1}(3,1);
     rd32=varargin{1}(3,2);
     rd33=varargin{1}(3,3);
else
    rd11=varargin(1);
     rd12=varargin(2);
     rd13=varargin(3);
     rd21=varargin(4);
     rd22=varargin(5);
     rd23=varargin(6);
     rd31=varargin(7);
     rd32=varargin(8);
     rd33=varargin(9);
end
    
tr = rd11 + rd22 + rd33;
cd = (tr-1)/2;
th = acos(cd);
sd = sqrt(1 - cd^2);
b=th/(2*sd);
r=[rd32 - rd23;
   rd13 - rd31;
   rd21 - rd12];

Ln=b*r;

