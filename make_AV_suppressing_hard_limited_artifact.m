% Computes the annotation vector that suppresses hard-limited artifacts
% Hoang Anh Dau Feb 18, 2017
%
% [annotationVector] = make_AV_suppressing_hard_limited_artifact(data, subsequenceLength)
% Output:
%     annotationVector: the annotation vector (vector)
% Input:
%     data: the input time series (vector)
%     subsequenceLength: the motif length (scalar)
% 
% This function is intended for EOGL_short.mat dataset. See readme_data.txt 
% for details.
% The subsequence length should be 450.
% The problem description and solution are in subsection 3.2.2 of the paper
% The results are in Figure 12.
%
%%
function [annotationVector] = make_AV_suppressing_hard_limited_artifact(data, subsequenceLength)

data = zscore(data);
ma = max(data);
mi = min(data);

profileLen = length(data) - subsequenceLength + 1;
av = zeros(profileLen, 1);

for i = 1:profileLen
   subsequence = data(i:i+subsequenceLength - 1);
   av(i) = length(subsequence(subsequence == ma | subsequence == mi));
end

av = zeroOneNorm(av);
annotationVector = (1-av);

disp('Finish');

end

function x = zeroOneNorm(x)
x = x-min(x);
x = x/max(x);
end





