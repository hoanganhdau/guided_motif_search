% Makes annotation vector that favors number of zero crossing
% Hoang Anh Dau Feb 18, 2017
%
% [annotationVector] = make_AV_zerocrossing(data, subsequenceLength);
% Output:
%     annotationVector: annotation vector (vector)
% Input:
%     data: input time series (vector)
%     subsequenceLength: motif length (scalar)
%
%%
function [AV] = make_AV_zerocrossing(data, subsequence_length)
% data is a row vector
data = zscore(data);
profile_length = length(data) - subsequence_length + 1;
AV = zeros(profile_length, 1);
for j = 1: profile_length
    AV(j) = zero_crossings(data(j:j+subsequence_length-1));
end
AV = zeroOneNorm(AV);
end

%%
% normalizes the time series to be in range [0-1]
function x = zeroOneNorm(x)
x = x-min(x);
x = x/max(x);
end

%%
% counts number of zero crossings
% The function below is copied from the Internet
function [count] = zero_crossings(x)
% Count the number of zero-crossings from the supplied time-domain
% input vector.  A simple method is applied here that can be easily
% ported to a real-time system that would minimize the number of
% if-else conditionals.
%
% Usage:     COUNT = zero_crossings(X);
%
%            X     is the input time-domain signal (one dimensional)
%            COUNT is the amount of zero-crossings in the input signal
%
% Author:    sparafucile17 06/27/04
%

% initial value
count = 0;

% error checks
if(length(x) == 1)
    length(x)
    error('ERROR: input signal must have more than one element');
    
end

if((size(x, 2) ~= 1) && (size(x, 1) ~= 1))
    error('ERROR: Input must be one-dimensional');
end

% force signal to be a vector oriented in the same direction
x = x(:);

num_samples = length(x);
for i=2:num_samples
    
    % Any time you multiply to adjacent values that have a sign difference
    % the result will always be negative.  When the signs are identical,
    % the product will always be positive.
    if((x(i) * x(i-1)) < 0)
        count = count + 1;
    end
    
end
end