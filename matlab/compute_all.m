function compute_all()
%% already processed featureset 
%    featureset = {'point'; 'hog_orig'; 'sparse_sift'; 'hog_resize'; 'gistGabor'; 'color_hist'; 'simpsal_orig'; 'simpsal_resize'; 'line_length'; 'line_angle'};
%    featureset = { 'small_dense_sift';};
%    for i=1:size(featureset, 1)
%        feature = featureset{i};
%        compute_feature_vecs(feature, 400);
%    end

%% Example to read a kernel gram matrix and run classification on it
%    disp('reading file...');
%    tic
%    k = read_kernel_from_file('kernels/color_hist_chi_sqr_gram.dat', 1600);
%    toc

 
%   Train and test kernels with manually specified split.
%   ordering = randperm(size(k,1));   
%    [train_k, test_k, train_labels, test_labels] = generate_train_test(k, 200, 50, ordering);  % ordering is optional, will be randomly generated if ommitted 
%    [p acc dec_values] = classify(train_k, test_k, train_labels, test_labels);
%    disp(acc)

%   Train and test kernels on k-fold cross-validation - this generates k
%   kernel sets, you need to run classify() on each kernel set.
%    [train_kcell, test_kcell, train_labelcell, test_labelcell] = generate_crossval_train_test(k, 5, ordering);

%    accsum = 0;
%    for i=1:5,
%        [p, accuracy, d] = classify(train_kcell{i},test_kcell{i},train_labelcell{i},test_labelcell{i});
%        accsum = accsum + accuracy(1);
%    end
%    disp(accsum/5.0);
   
%% Generating and saving gram matrices for select features
    kerneltypes = {'hist_int'};
    featureset = { 'small_dense_sift'; };
    for i=1:size(kerneltypes,1),
        kerneltype = kerneltypes{i};
        file_suffix = ['_', kerneltype, '_gram.dat'];
        for j=1:size(featureset,1),
            feature = featureset{j};
            fprintf('Doing kernel stuff on %s with %s kernels.\n', feature, kerneltype);
            fprintf('Reading features from disk... ');
            tic
            cf = read_feature_data(feature, 400);
            fprintf('done.\n');
            toc
            fprintf('Computing gram matrix... ');
            tic
            k = compute_gram_matrix(cf, 1600, kerneltype);
            fprintf('done.\n');
            toc
            fprintf('Writing backup to disk... ');
            tic
            write_kernel_to_file(['kernels/', feature, file_suffix], k);
            fprintf('done.\n');
            toc
            fprintf('Generating random train and test labels.\n');
            [train_k, test_k, train_labels, test_labels] = generate_train_test(k, 1000, 200);
            fprintf('Classifying.\n');
            classify(train_k, test_k, train_labels, test_labels);
        end
    end

     
     