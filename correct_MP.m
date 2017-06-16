% Computes the corrected matrix profile from the original matrix profile
% and the annotation vector
% Hoang Anh Dau Feb 18, 2017
%
% [MP_corrected] = correct_MP(matrixProfile, annotationVector);
% Output:
%     MP_corrected: the corrected matrix profile (vector)
% Input:
%     matrixProfile: matrix profile of the self-join (vector)
%     annotationVector: annotation vector (vector)
%
%%
function [MP_corrected] = correct_MP(matrixProfile, annotationVector)
    MP_corrected = matrixProfile + (1 - annotationVector) * max(matrixProfile);
end