function [predict_label, accuracy, dec_values] = classify(train_k, test_k, train_labels, test_labels)
    total_train = size(train_k,2);
    total_test = size(test_k,2);
    model_precomputed = svmtrain(train_labels, [(1:total_train)', train_k'], '-t 4');
    [predict_label, accuracy, dec_values] = svmpredict(test_labels, [(1:total_test)',test_k'], model_precomputed);
end