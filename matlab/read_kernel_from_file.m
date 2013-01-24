  
function k = read_kernel_from_file( filename, total_entries )
    k = zeros(total_entries);
    fid = fopen(filename, 'r');
    for i=1:total_entries,
        for j=1:total_entries,
            k(i,j) = fscanf(fid, '%g', 1);
        end
    end
    fclose(fid);
end