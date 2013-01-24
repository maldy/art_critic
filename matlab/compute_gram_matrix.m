function k =  compute_gram_matrix( cf, total_entries, kerneltype )
    k = zeros(total_entries);
    if strcmp(kerneltype,'linear')==1 || strcmp(kerneltype,'rbf')==1   % normalizing data
        arr = zeros(size(cf{1},1),1);
        for i=1:total_entries,
            arr = arr + cf{i};
        end
        arr = arr ./ total_entries;
        sd = zeros(size(cf{1},1),1);
        for i=1:total_entries,
            sd = sd + (cf{i} - arr).^2;
        end
        sd = sqrt(sd);
        for i=1:total_entries,
            cf{i} = (cf{i} - arr)./sd;
        end
    end
    for i=1:total_entries,
        for j=1:i,
            switch kerneltype
                case 'linear'
                    k(i,j) = dot(cf{i},cf{j});
                case 'rbf'
                    k(i,j) = gaussian_dist(cf{i},cf{j});           
                case 'chi_sqr'
                    k(i,j) = chi_sqr_dist(cf{i},cf{j});
                case 'hist_int'
                    k(i,j) = hist_intersection(cf{i},cf{j});
            end
            k(j,i) = k(i,j);
        end
    end
end