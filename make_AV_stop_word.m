% Makes annotation vector that supresses stop-word motifs
% Hoang Anh Dau Feb 18, 2017
%
% [annotationVector] = make_AV_stop_word(data, subsequenceLength);
% Output:
%     annotationVector: annotation vector (vector)
% Input:
%     data: input time series (vector)
%     subsequenceLength: motif length (scalar)
%
% The function is intended to be generic. However, its parameters
% (threshold, exclusionZone and stopWordLocation) are dataset-dependent
% The parameters' default value are for specifically for dataset
% ECG_LTAF-71.mat. Recommened subsequence length of this dataset is 150.
%
%%
function [AV] = make_AV_stop_word(data, subsequenceLength)
% the following parameters are dataset-dependent
threshold = 0.1;
exclusionZone = 450;
stopWordLocation = 63;

data = zscore(data);
stop_word = data(stopWordLocation:stopWordLocation+subsequenceLength - 1);

AV = zeros(length(data) - subsequenceLength + 1, 1);
for i = 1:length(data) - subsequenceLength + 1
    s = data(i:i+subsequenceLength-1);
    AV(i) = pdist2(s, stop_word);
end

AV = zeroOneNorm(AV);

index = find(AV <= threshold);
for i = 1:length(index)
    if index(i) < exclusionZone
        AV(index(i)-index(i)+1:index(i)+exclusionZone-1) = 0;
    else
        AV(index(i)-exclusionZone+1:index(i)+exclusionZone-1) = 0;
    end
end
end

%%
function x = zeroOneNorm(x)
x = x-min(x);
x = x/max(x);
end