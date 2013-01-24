function [ out ] = hist_intersection( x1, x2 )
    if all(size(x1)==size(x2))==0
        error('Mismatched argument sizes in hist_intersection()');
    end
    if size(x1, 1) == 1
        x1 = x1';
    end
    if size(x2, 1) == 1
        x2 = x2';
    end
    out = sum(min(x1/sum(x1),x2/sum(x2)));
end

