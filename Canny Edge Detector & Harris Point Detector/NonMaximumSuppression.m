function [ nonMaxSupImage ] = NonMaximumSuppression( gradient, direction )
%UNTITLED2 Summary of this function goes here
%   Detailed explanation goes here
[rows, cols] = size(gradient);

for r = 2 : rows - 1
    for c = 2 : cols - 1 
        dir = direction(r,c);
        grad = gradient(r,c);
        
        %top-right, bottom-left
        if ( (dir >= 22.5 && dir < 67.5)  || (dir < -112.5 && dir >= -157.5) )
            if  ( grad > gradient(r+1,c-1) && grad > gradient(r-1,c+1))
                gradient(r,c) = gradient(r,c);
            else
                gradient(r,c) = 0;
            end
            
         %vertical
        elseif ( (dir >= 67.5 && dir < 112.5) || (dir < - 67.5 && dir >= -112.5) )
            if (grad > gradient(r-1,c) && grad > gradient(r+1,c))
                gradient(r,c) = gradient(r,c);
            else
                gradient(r,c) = 0;
            end
            
            %top-left, bottom-right
        elseif ((dir >= 112.5 && dir < 157.5) || ( dir <  -22.5 && dir >= -67.5 ) )
            if (grad > gradient(r-1,c-1) && grad> gradient(r+1,c+1) )
                gradient(r,c) = gradient(r,c);
            else
                gradient(r,c) = 0;
            end
            
            %horizontal
        else if ( ( dir < 22.5 && dir >= -22.5  ) || ( dir < -157.5 && dir >= -180 ) )
            if (grad > gradient(r,c-1) && grad > gradient(r,c+1))
                gradient(r,c) = gradient(r,c);
            else
                gradient(r,c) = 0;
            end     
        end
    end
end

nonMaxSupImage = gradient;

end

