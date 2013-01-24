function [ out ] = gaussian_dist( x1, x2 )
    if all(size(x1)==size(x2))==0
        error('Mismatched argument sizes in gaussian_dist()');
    end
    if size(x1, 1) == 1
        x1 = x1';
    end
    if size(x2, 1) == 1
        x2 = x2';
    end
    out = exp(-norm(x1 - x2)^2);
end

