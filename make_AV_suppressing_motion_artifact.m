% Computes the annotation vector that suppresses motion artifacts
% Hoang Anh Dau Feb 18, 2017
%
% [annotationVector] = make_AV_suppressing_motion_artifact(data, subsequenceLength)
% Output:
%     annotationVector: the annotation vector (vector)
% Input:
%     data: the input time series (vector)
%     subsequenceLength: the motif length (scalar)
% 
% This function is intended for fNIRS.mat dataset. See readme_data.txt for
% details.
% The input time series should be the acceleration vector and the
% subsequence length should be 600.
% The problem description and solution are in subsection 3.2.1 of the paper
% The results are in Figure 8 and Figure 9.
%
%%
function [annotationVector] = make_AV_suppressing_motion_artifact(data, subsequenceLength)

data = zscore(data);
av = zeros(length(data) - subsequenceLength + 1, 1);

for i = 1:length(data) - subsequenceLength + 1
    subsequence = data(i:i+subsequenceLength - 1);
    av(i) = std(subsequence);
end

cav = av;
mu = mean(av);

cav(av >= mu) = 0;
cav(av < mu) = 1;

annotationVector = cav;

figure; plot(data + 2, 'b');
hold on; plot(cav, 'm', 'LineWidth', 4);
hline = refline([0 mu]);
hline.Color = 'r';

disp('Finish');

end






