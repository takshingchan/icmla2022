function mcc = evaltree(actual,predicted)
%EVALTREE Evaluate a predicted tree.
%
%   MCC = EVALTREE(ACTUAL,PREDICTED) evaluates a predicted tree using
%   Matthews correlation coefficient.
%
%   Inputs:
%     ACTUAL    - The actual tree.
%     PREDICTED - A predicted tree.
%
%   Outputs:
%     MCC       - Matthews correlation coefficient.

%   References:
%     [1] B. W. Matthews, "Comparison of the predicted and observed
%         secondary structure of T4 phage lysozyme," Biochim. Biophys. Acta
%         Protein Struct., vol. 405, no. 2, pp. 442-451, 1975.

%   Copyright 2022 Tak-Shing Chan

% Find the adjacency matrices.
actual = full(adjacency(actual));
predicted = full(adjacency(predicted));

% Ignore self-loops.
actual(1:size(actual,1)+1:end) = -1;
predicted(1:size(predicted,1)+1:end) = -1;

% Create confusion matrix.
tp = nnz(actual==1 & predicted==1);
fp = nnz(actual==0 & predicted==1);
fn = nnz(actual==1 & predicted==0);
tn = nnz(actual==0 & predicted==0);

% Matthews correlation coefficient.
mcc = (tp*tn-fp*fn)/sqrt((tp+fp)*(tp+fn)*(tn+fp)*(tn+fn));
