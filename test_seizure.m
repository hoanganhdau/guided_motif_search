% tests the performance of classic matrix profile and guided motif search on
% epilepsy seizure dataset
% Hoang Anh Dau Feb 18, 2017
%
% [label_classic, label_corrected] = test_seizure(train_data, test_data)
% Output:
%     label_classic: the label of test data obtained by classic MP method
%     (vector)
%     label_corrected: the label of test data obtained by guided motif
%     search (vector)
% Input:
%     train_data: input time series used for training (vector)
%     test_data: input time series used for testing (vector)
% The train data is epilepsy_train.mat, which contains one recording of 
% mimicking epilepsy seizure  
% The test data is epilepsy_walking.mat, which contains five recording of
% mimicking epilepsy seizure and three recordings of walking task
% concatenated. 
% The experiment results are presented in Table 5 and Figure 22 of the
% paper
%
%%
function [label_classic, label_corrected] = test_seizure(train_data, test_data)

    train_data = zscore(train_data);
    test_data = zscore(test_data);
    
    subsequence_length = 16; % 1s
    
    [MP, MP_index] = Time_series_Self_Join_Fast(train_data, subsequence_length);
    [mi, mii] = min(MP);
    top_1 = mii;
    top_1_nn = MP_index(top_1);
    
    AV = make_AV_complexity(train_data, subsequence_length);
    MP_corrected = correct_MP(MP, AV);
    
    [mi, mii] = min(MP_corrected);
    top_1_corrected = mii;
    top_1_corrected_nn = MP_index(top_1_corrected);
    
    motif_classic = zscore(train_data(top_1:top_1+subsequence_length-1));
    motif_classic_nn = zscore(train_data(top_1_nn:top_1_nn+subsequence_length-1));
    motif_classic_average = mean([motif_classic; motif_classic_nn]);
     
    motif_corrected = zscore(train_data(top_1_corrected:top_1_corrected+subsequence_length-1));
    motif_corrected_nn = zscore(train_data(top_1_corrected_nn:top_1_corrected_nn+subsequence_length-1));
    motif_corrected_average = mean([motif_corrected; motif_corrected_nn]);
    
    figure; 
    subplot(3,1,1); plot(train_data, 'g'); hold on; plot(train_data(13,:), 'r');
    subplot(3,1,2); plot(motif_classic, 'b'); hold on; plot(motif_classic_nn, 'c'); 
    title('Top Motif Classic');
    subplot(3,1,3); plot(motif_corrected, 'b'); hold on; plot(motif_corrected_nn, 'c');
    title('Top Motif Corrected');  
    
    distance_classic = pdist2(motif_classic, motif_classic_nn);
    distance_corrected = pdist2(motif_corrected, motif_corrected_nn);
    
    profile_length = length(test_data) - subsequence_length + 1; 
    ca_dist = zeros(profile_length, 1);
    co_dist = zeros(profile_length, 1);
    result_classic = zeros(profile_length, 1);
    result_corrected = zeros(profile_length, 1);
    for i = 1:profile_length
       subsequence = zscore(test_data(i:i+subsequence_length -1));
       ca_dist(i) = pdist2(motif_classic_average, subsequence);
       co_dist(i) = pdist2(motif_corrected_average, subsequence);
    end   
    similarity_factor = 3;
    result_classic(ca_dist <= distance_classic * similarity_factor) = 1;
    result_corrected(co_dist <= distance_corrected * similarity_factor) = 1;
    
    label_classic = zeros(length(test_data), 1);
    label_corrected = zeros(length(test_data), 1);
    for i = 1:profile_length
        if (result_classic(i) == 1)
            label_classic(i:i+subsequence_length-1) = 3;
        end
        if (result_corrected(i) == 1)
            label_corrected(i:i+subsequence_length-1) = 3;
        end
    end
    
    figure; 
    subplot(4,1,1); plot(test_data, 'g'); hold on; plot(label_classic, 'b', 'LineWidth', 0.5); plot(label + 2, 'r');
    title('Classic');
    subplot(4,1,2); plot(test_data, 'm'); hold on; plot(label_corrected, 'b', 'LineWidth', 0.5); plot(label + 2, 'r');
    title('Corrected');
    subplot(4,1,3); plot(motif_classic, 'b'); hold on; plot(motif_classic_nn, 'c'); 
    title('Top Motif Classic');
    subplot(4,1,4); plot(motif_corrected, 'b'); hold on; plot(motif_corrected_nn, 'c');
    title('Top Motif Corrected');
    
    % compute score; segment of 2s = 36 data points (16Hz sampling)
    segment_length = 36;
    true_positive_classic = 0;
    true_positive_corrected = 0;
    false_positive_classic = 0;
    false_positive_corrected = 0;
    true_negative_classic = 0;
    true_negative_corrected = 0;
    false_negative_classic = 0;
    false_negative_corrected = 0;
    
    for i = 1: segment_length: length(test_data) - segment_length +1
        % true positive
        if sum(label(i:i+segment_length-1)== 1) > 0 && sum(label_classic(i:i+segment_length-1) == 3) > 0
            true_positive_classic = true_positive_classic + 1;
        end
        if sum(label(i:i+segment_length-1)== 1) > 0 && sum(label_corrected(i:i+segment_length-1) == 3) > 0
            true_positive_corrected = true_positive_corrected + 1;
        end
        
        % false positive
        if sum(label(i:i+segment_length-1)== 1) == 0 && sum(label_classic(i:i+segment_length-1) == 3) > 0
            false_positive_classic = false_positive_classic + 1;
        end
        if sum(label(i:i+segment_length-1)== 1) == 0 && sum(label_corrected(i:i+segment_length-1) == 3) > 0
            false_positive_corrected = false_positive_corrected + 1;
        end
        
        % true negative
        if sum(label(i:i+segment_length-1)== 1) == 0 && sum(label_classic(i:i+segment_length-1) == 3) == 0
            true_negative_classic = true_negative_classic + 1;
        end
        if sum(label(i:i+segment_length-1)== 1) == 0 && sum(label_corrected(i:i+segment_length-1) == 3) == 0
            true_negative_corrected = true_negative_corrected + 1;
        end
        
        % false negative
        if sum(label(i:i+segment_length-1)== 1) > 0 && sum(label_classic(i:i+segment_length-1) == 3) == 0
            false_negative_classic = false_negative_classic + 1;
        end
        if sum(label(i:i+segment_length-1)== 1) > 0 && sum(label_corrected(i:i+segment_length-1) == 3) == 0
            false_negative_corrected = false_negative_corrected + 1;
        end
    end
    
    precision_classic = true_positive_classic/(true_positive_classic + false_positive_classic);
    recall_classic = true_positive_classic/(true_positive_classic+false_negative_classic);
    F1_classic = 2*((precision_classic*recall_classic)/(precision_classic+recall_classic));
    
    precision_corrected = true_positive_corrected/(true_positive_corrected + false_positive_corrected);
    recall_corrected = true_positive_corrected/(true_positive_corrected+false_negative_corrected);
    F1_corrected = 2*((precision_corrected*recall_corrected)/(precision_corrected+recall_corrected));
    
    accuracy_classic = (true_positive_classic + true_negative_classic)/floor(length(test_data)/segment_length);
    accuracy_corrected = (true_positive_corrected + true_negative_corrected)/floor(length(test_data)/segment_length);

    disp('Classic result');
    disp(['F-measure ' num2str(F1_classic*100)]);
    disp(['Accuracy ' num2str(accuracy_classic*100)]);
    disp(['True positive ' num2str(true_positive_classic)]);
    disp(['False positive ' num2str(false_positive_classic)]);
    disp(['True negative ' num2str(true_negative_classic)]);
    disp(['False negative ' num2str(false_negative_classic)]);
   
    disp('Corrected result');
    disp(['F-measure ' num2str(F1_corrected*100)]);
    disp(['Accuracy ' num2str(accuracy_corrected*100)]);
    disp(['True positive ' num2str(true_positive_corrected)]);
    disp(['False positive ' num2str(false_positive_corrected)]);
    disp(['True negative ' num2str(true_negative_corrected)]);
    disp(['False negative ' num2str(false_negative_corrected)]);
    
    disp('Finish');
    
end








