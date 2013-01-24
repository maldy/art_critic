function [train_kcell, test_kcell, train_labelcell, test_labelcell] = generate_crossval_train_test(k, folds, random_ordering, true_labels)
    total_entries = size(k,1);

    if nargin < 3
        random_ordering = randperm(total_entries);
    end
    if nargin < 4
        true_labels = [ones(400,1); 2*ones(400,1); 3*ones(400,1); 4*ones(400,1)];
    end
    
    shuffled_k = k(random_ordering, random_ordering);
    shuffled_labels = true_labels(random_ordering);
    
    num_test = ceil(total_entries / folds);
    
    train_kcell = cell(folds,1);
    test_kcell = cell(folds,1);
    train_labelcell = cell(folds,1);
    test_labelcell = cell(folds,1);
    
    for i=1:folds,
        train_kcell{i} = [ shuffled_k(1:((i-1)*num_test), 1:((i-1)*num_test)), shuffled_k(1:((i-1)*num_test),(i*num_test+1):total_entries); ...
            shuffled_k((i*num_test+1):total_entries, 1:((i-1)*num_test)), shuffled_k((i*num_test+1):total_entries,(i*num_test+1):total_entries)];
        test_kcell{i} = [ shuffled_k( 1:((i-1)*num_test), ((i-1)*num_test+1):(i*num_test) ) ; shuffled_k((i*num_test+1):total_entries, ((i-1)*num_test+1):(i*num_test)) ];
        train_labelcell{i} = shuffled_labels([(1:((i-1)*num_test)),  ((i*num_test+1):total_entries)]);
        test_labelcell{i} = shuffled_labels(((i-1)*num_test+1):(i*num_test));
    end
end