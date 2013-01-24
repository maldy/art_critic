
function [train_k, test_k, train_labels, test_labels] = generate_train_test(k, num_train, num_test, random_ordering, true_labels)
    total_entries = size(k,1);
    if total_entries < num_train + num_test
        error('Not enough entries in kernel');
    end
    
    if nargin < 4   % this is good for a one-time random ordering
        random_ordering = randperm(total_entries);
    end
    if nargin < 5
       true_labels = [ones(400,1); 2*ones(400,1); 3*ones(400,1); 4*ones(400,1)];
    end
    
    shuffled_k = k(random_ordering, random_ordering);
    shuffled_labels = true_labels(random_ordering);
    
    train_k = shuffled_k(1:num_train,1:num_train);
    test_k = shuffled_k(1:num_train,num_train+1:num_train+num_test);
    
    train_labels = shuffled_labels(1:num_train);
    test_labels = shuffled_labels(num_train+1:num_train+num_test);
end