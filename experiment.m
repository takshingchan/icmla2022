function experiment(fi,alphas,ks,ps,ds,ns,N)
%EXPERIMENT Generate random trees and simulate energy usage.
%
%   EXPERIMENT(fi,alphas,ks,ps,ds,ns,N) generates synthetic data using a
%   standard symmetric stable distribution, with an option for fractional
%   integration. First we generate a uniformly random k-restricted tree
%   with p+d nodes where trees with siblingless children are rejected. Then
%   we generate synthetic data of length n for all leaves and propagate
%   them to all ancestors. We remove d non-root nodes at random to simulate
%   missing meters. Eight methods will be tested: 1) squared correlation
%   polytree; 2) squared correlation arborescence; 3) distance correlation
%   polytree; 4) distance correlation arborescence; 5) squared correlation
%   polytree with dominance; 6) squared correlation arborescence with
%   dominance; 7) distance correlation polytree with dominance; and 8)
%   distance correlation arborescence with dominance. Each experiment will
%   be repeated N times. Results are evaluated by MCC then saved into
%   results.mat.

%   Copyright 2022 Tak-Shing Chan

% Validate inputs.
validateattributes(fi,{'logical'},{'scalar'})
validateattributes(alphas,{'numeric'},{'vector','>',1,'<=',2})
validateattributes(ks,{'numeric'},{'vector','>=',2,'integer'})
validateattributes(ps,{'numeric'},{'vector','>=',1,'integer'})
validateattributes(ds,{'numeric'},{'vector','>=',0,'integer'})
validateattributes(ns,{'numeric'},{'vector','>=',10,'integer'})
validateattributes(N,{'numeric'},{'scalar','>=',30,'integer'})

% Initialize results.
results = cell(length(alphas)*length(ks)*length(ps)*length(ds)...
    *length(ns)*N*8,8);
ind = 1;

% Start simulations.
for alpha = alphas
    for k = ks
        for p = ps
            for d = ds
                for n = ns
                    for t = 1:N
                        % Generate a random tree with p+d nodes.
                        pred = gentree(k,p+d);
                        A = aggpaths(pred);
                        m = size(A,1);

                        % Delete d random nodes that are not the root.
                        deleted = randperm(p+d-1,d)+1;
                        for node = deleted
                            pred(pred==node) = pred(node);
                        end
                        pred(deleted) = [];

                        % Renumber surviving nodes consecutively.
                        survived = setdiff(1:p+d,deleted);
                        renum = NaN(1,p+d);
                        renum(survived) = 1:length(survived);
                        tree = digraph(renum(pred(pred~=0)),find(pred~=0));

                        % Generate synthetic data for all leaves.
                        if fi
                            % FI(1-1/alpha) with SaS innovations.
                            c = [1;cumprod(1-(1/alpha)./(1:n-1)')];
                            D = zeros(n,m);
                            for i = 1:m
                                e = random('Stable',alpha,0,1,0,n,1);
                                D(:,i) = filter(c,1,e);
                            end
                        else
                            % D ~ Stable(alpha,0,1,0).
                            D = random('Stable',alpha,0,1,0,n,m);
                        end

                        % Ensure all data are nonnegative then propagate
                        % them to all ancestors.
                        D = D-min(D(:));
                        X = D*A(:,survived);

                        % Calculate dominance and symmetrized dominance.
                        dom = zeros(p);
                        for i = 1:p
                            for j = 1:p
                                dom(i,j) = all(X(:,i)>=X(:,j));
                            end
                        end
                        symdom = dom|dom';

                        % Method 1. Squared correlation polytree.
                        SC = corrcoef(X).^2;
                        [~,pred] = minspantree(graph(-SC),'Method','sparse');
                        tree_predicted = digraph(pred(pred~=0),find(pred~=0));
                        mcc = evaltree(tree,tree_predicted);
                        results(ind,:) = {fi,alpha,k,p,d,n,1,mcc};

                        % Method 2. Squared correlation arborescence.
                        edges = getDirectedTree(SC);
                        tree_predicted = digraph(edges(:,1),edges(:,2));
                        mcc = evaltree(tree,tree_predicted);
                        results(ind+1,:) = {fi,alpha,k,p,d,n,2,mcc};

                        % Method 3. Distance correlation polytree.
                        DC = dcorrcoef(X);
                        [~,pred] = minspantree(graph(-DC),'Method','sparse');
                        tree_predicted = digraph(pred(pred~=0),find(pred~=0));
                        mcc = evaltree(tree,tree_predicted);
                        results(ind+2,:) = {fi,alpha,k,p,d,n,3,mcc};

                        % Method 4. Distance correlation arborescence.
                        edges = getDirectedTree(DC);
                        tree_predicted = digraph(edges(:,1),edges(:,2));
                        mcc = evaltree(tree,tree_predicted);
                        results(ind+3,:) = {fi,alpha,k,p,d,n,4,mcc};

                        % Method 5. Squared correlation polytree with
                        % symmetric dominance.
                        SCSD = SC;
                        SCSD(~symdom) = 0;
                        [~,pred] = minspantree(graph(-SCSD),'Method','sparse');
                        tree_predicted = digraph(pred(pred~=0),find(pred~=0));
                        mcc = evaltree(tree,tree_predicted);
                        results(ind+4,:) = {fi,alpha,k,p,d,n,5,mcc};

                        % Method 6. Squared correlation arborescence with
                        % dominance.
                        SCD = SC;
                        SCD(~dom) = 0;
                        edges = getDirectedTree(SCD);
                        tree_predicted = digraph(edges(:,1),edges(:,2));
                        mcc = evaltree(tree,tree_predicted);
                        results(ind+5,:) = {fi,alpha,k,p,d,n,6,mcc};

                        % Method 7. Distance correlation polytree with
                        % symmetric dominance.
                        DCSD = DC;
                        DCSD(~symdom) = 0;
                        [~,pred] = minspantree(graph(-DCSD),'Method','sparse');
                        tree_predicted = digraph(pred(pred~=0),find(pred~=0));
                        mcc = evaltree(tree,tree_predicted);
                        results(ind+6,:) = {fi,alpha,k,p,d,n,7,mcc};

                        % Method 8. Distance correlation arborescence with
                        % dominance.
                        DCD = DC;
                        DCD(~dom) = 0;
                        edges = getDirectedTree(DCD);
                        tree_predicted = digraph(edges(:,1),edges(:,2));
                        mcc = evaltree(tree,tree_predicted);
                        results(ind+7,:) = {fi,alpha,k,p,d,n,8,mcc};
                        ind = ind+8;
                    end
                end
            end
        end
    end
end

% Save results.
results = cell2table(results,...
    'VariableNames',{'fi','alpha','k','p','d','n','method','mcc'});
save('results.mat','results')
