% Computes the accuracy of classic matrix profile method (using no annotation vector)
% Hoang Anh Dau Feb 18, 2017
%
% [accuracy] = test_classic_MP(data, motif_location, subsequenceLength)
% Output:
%     accuracy: the accuracy (percentage)
% Input:
%     data: input time series (vector)
%     motifLocation: groundtruth / The location of the embedded motif
%     subsequenceLength: motif length (scalar)
% 
% This function is intended to be generic.
% It is originally written to test the performance of the proposed method
% on MALLAT dataset. The dataset and motif location are provided with your download.
% The experiment results are presented in Table 4 of the paper
%
%%
function [accuracy] = test_classic_MP(data, motif_location, subsequenceLength)

% computes the matrix profile and profile index 
no_of_objects = size(data, 1);
for i = 1:no_of_objects
    [MP, MP_index] = Time_series_Self_Join_Fast(data(i, :), subsequenceLength);
end

MP_score = zeros(no_ob_objects, 1);

for i = 1:size(MP, 1)
    
    each_MP = MP(i,:);
    each_MP_index = MP_index(i,:);
    
    [~, mii] = min(each_MP);
    top_m1 = mii;
    top_m2 = each_MP_index(i, mii);
    if top_m1 > top_m2; tmp = top_m1; top_m1 = top_m2; top_m2 = tmp; end; %sort
    
    actual_m1 = motif_location(i, 1);
    actual_m2 = motif_location(i, 2);
    if actual_m1 > actual_m2; tmp = actual_m1; actual_m1 = actual_m2; actual_m2 = tmp; end
    
    overlap1 = intersect(top_m1:top_m1 + subsequenceLength - 1, actual_m1:actual_m1+subsequenceLength - 1);
    overlap2 = intersect(top_m2:top_m2 + subsequenceLength - 1, actual_m2:actual_m2+subsequenceLength - 1);
    
    if length(overlap1) + length(overlap2) > 0
        MP_score(i) = 1;
    end
    
end

accuracy = sum(MP_score)/no_of_objects;
disp(['Accuray is ' num2str(accuracy)]);

end
