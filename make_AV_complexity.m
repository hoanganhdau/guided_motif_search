% Makes annotation vector that favors complexity
% Hoang Anh Dau Feb 18, 2017
%
% [annotationVector] = make_AV_complexity(data, subsequenceLength);
% Output:
%     annotationVector: annotation vector (vector)
% Input:
%     data: input time series (vector)
%     subsequenceLength: motif length (scalar)
%
%%
function [AV] = make_AV_complexity(data, subsequenceLength)
    data = zscore(data); % data is a row vector
    profile_length = length(data) - subsequenceLength + 1;
    AV = zeros(profile_length,1);  
    for j = 1: profile_length
        AV(j) = check_complexity(data(j:j+subsequenceLength-1));
    end
    AV = zeroOneNorm(AV);   
end

%%
function [complexity] = check_complexity(x)
    complexity = sqrt(sum(diff(x).^2));
end

%%
function x = zeroOneNorm(x)
x = x-min(x);
x = x/max(x);
end
