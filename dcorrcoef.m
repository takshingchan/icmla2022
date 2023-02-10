function R = dcorrcoef(X)
%DCORRCOEF Distance correlation coefficients.
%   R = DCORRCOEF(X) computes the distance correlation matrix of X using
%   the fast algorithm in [1].
%
%   Inputs:
%     X     - N-by-M matrix where the rows are observations and the columns
%             are variables.
%
%   Outputs:
%     R     - M-by-M matrix of distance correlations.
%
%   See also FASTDCOV.

%   References:
%     [1] A. Chaudhuri and W. Hu, "A fast algorithm for computing distance
%         correlation," Comput. Stat. Data An., vol. 135, pp. 15-24, 2019.

%   Copyright 2022 Tak-Shing Chan

m = size(X,2);

% Fill in the distance covariance matrix.
C = zeros(m);
for i = 1:m
    for j = i:m
        C(i,j) = fastDcov(X(:,i),X(:,j));
    end
end
C = C+triu(C,1)';

% Set R(i,j) = C(i,j)/sqrt(C(i,i)*C(j,j)) if the denominator is positive.
R = zeros(m);
for i = 1:m
    for j = 1:m
        denom = sqrt(C(i,i)*C(j,j));
        if denom>0
            R(i,j) = C(i,j)/denom;
        end
    end
end
