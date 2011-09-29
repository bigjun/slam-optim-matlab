        function d = Absolute2Relative3D_temp(p1, p2)
            d = inv(p1.Q) * (p2.pose - p1.pose);
        end
        
        function p2 = Relative2Absolute3D(d,p1)
            p2 = p1.Q * d + p1.pose;
        end
        
% smart plus and minus     
        





        



