function [ out ] = chi_sqr_dist( x1, x2 )
    if all(size(x1)==size(x2))==0
        error('Mismatched argument sizes in chi_sqr_dist()');
    end
    if size(x1, 1) == 1
        x1 = x1';
    end
    if size(x2, 1) == 1
        x2 = x2';
    end
    x1 = x1/sum(x1);
    x2 = x2/sum(x2);
    out = 1.0;
    for i=1:size(x1,1),
        out = out - 1.0*(x1(i) - x2(i))^2 / (0.000001 + 0.5*(x1(i) + x2(i)));
    end
end

