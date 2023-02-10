function A = aggpaths(pred)
%AGGPATHS Finds all aggregation paths.
%
%   A = AGGPATHS(PRED) finds all paths from leaves to root.
%
%   Inputs:
%     PRED  - 1-by-P vector of predecessor nodes.
%
%   Outputs:
%     A     - L-by-P vector of aggregation paths for each leaf.

%   Copyright 2022 Tak-Shing Chan

% Validate inputs.
p = size(pred,2);
validateattributes(pred,{'numeric'},{'row','>=',0,'<=',p,'integer'})

% Find all leaves.
leaves = setdiff(1:p,pred(pred~=0));
l = length(leaves);

% For each leaf, traverse from leaf to root.
A = zeros(l,p);
for i = 1:l
    visited = false(1,p);
    j = leaves(i);
    while j
        if visited(j)
            error('A tree should not contain loops.')
        else
            visited(j) = true;
        end

        % Mark the aggregation path.
        A(i,j) = 1;
        j = pred(j);
    end
end
