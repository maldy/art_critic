function cf = read_feature_data(feature, num_entries)
    cf = cell(num_entries * 4,1);
    dirs = {'abstractexpressionism'; 'cubism'; 'renaissance'; 'romanticism'};
    for i=1:size(dirs,1),
        fid = fopen(['art_movements/', dirs{i}, '/', feature, '_features.dat'], 'r');
        entrycount = 1;
        while ~feof(fid)
            line = fgets(fid);
            cf{num_entries*(i-1)+entrycount} = sscanf(line, '%g');            
            entrycount = entrycount + 1;
        end
        fclose(fid);
    end
end
