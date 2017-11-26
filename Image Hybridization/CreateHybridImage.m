function [ fused_image ] = CreateHybridImage( i1, bb1, i2, bb2)
    [r1, c1, rgb] = size(i1);
    [r2, c2, rgb] = size(i2);
    
    area1 = i1(bb1(2):bb1(4), bb1(1):bb1(3), :);
    area2 = i2(bb2(2):bb2(4),bb2(1):bb2(3), :);
    G1=fspecial('gaussian',[5 5],10);
    G2=fspecial('gaussian',[5 5],10);
    area1=imfilter(area1,G1,'same');
    area2=imfilter(area2,G2,'same');
   
    %bottom
    if bb1(1) == 1
        x = bb1(2) - 1;
        temp1 = i1(1:x,1: r1,:);
        x = bb2(4) + 1;
        temp2 = i2( x:c2,1: r2,:);
        
        c = 2;
        for i = 2:49
            alpha = (50.0-i)/50.0;
            area1(c,:,:) = alpha*area1(c,:,:); 
            area2(c,:,:) = (1-alpha)*area2(c,:,:);
            c = c + 1;
        end
        areafinal = imadd(area1, area2);
        fused_image = vertcat(temp1 , areafinal, temp2);
        
    %right
    else
        x = bb1(1) - 1;
        temp1 = i1(1:c1,1:x ,:);
        x = bb2(3)+1;
        temp2 = i2( 1:c2,x : r2,: );
        c = 2;
        for i = 2:49
            alpha = (50.0-i)/50.0;
            area1(:,c,:) = alpha*area1(:,c,:);
            area2(:,c,:) = (1-alpha)*area2(:,c,:);
            c = c + 1;
        end
        areafinal = area1 + area2;
        fused_image = [temp1 areafinal temp2];
    end
        fused_image = imresize(fused_image, [500,500]);
    
end

