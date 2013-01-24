  
function write_kernel_to_file(filename, k)
    fid = fopen(filename, 'w');
    total_entries = size(k, 1);
    for i=1:total_entries,
        for j=1:total_entries,
            fprintf(fid, '%d ', k(i,j));
        end
        fprintf(fid, '\n');
    end
    fclose(fid);
end

    