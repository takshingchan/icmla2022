function pred = gentree(m,n)
%GENTREE Generate a random tree.
%
%   PRED = GENTREE(M,N) generates a uniformly random m-restricted tree with
%   exactly n nodes. Trees with siblingless children are rejected.
%
%   Inputs:
%     M     - Maximum number of children at each node.
%     N     - Number of generated nodes.
%
%   Outputs:
%     PRED  - 1-by-N vector of predecessors.

%   References:
%     [1] R. Sedgewick, Analytic Combinatorics Lecture 0,
%         https://ac.cs.princeton.edu/online/slides/AC00-Random.pdf

%   Copyright 2022 Tak-Shing Chan

% Validate inputs.
validateattributes(m,{'numeric'},{'scalar','>=',2,'integer'})
validateattributes(n,{'numeric'},{'scalar','>=',1,'integer'})
if m==2 && mod(n,2)==0
    error('A full binary tree must have an odd number of nodes.')
end

while 1
    % Simulate a Galton-Watson process.
    pred = 0;
    s = 1;
    while s<=length(pred) && length(pred)<n
        % Sample from U{1,m} and treat 1 as 0.
        r = unidrnd(m);
        if r~=1
            pred = [pred repmat(s,1,r)];
        end
        s = s+1;
    end
    
    % Wait for trees of exactly size n.
    if length(pred)==n
        break
    end
end
