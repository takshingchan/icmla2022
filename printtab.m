%PRINTTAB Script to print the tables.
%
%   See also EXPERIMENT.

%   Copyright 2022 Tak-Shing Chan

% Tabulate results 1 with fi==true, d==0, n==500. For each alpha, display rank
% of means for k==2:5. Also show means and standard deviations.
load results_1.mat
for alpha = [1.5 2]
    mu = zeros(8,4);
    mu_sigma = cell(8,4);
    ranking = zeros(8,4);
    filtered = results(results.fi==true     & ...
                       results.alpha==alpha & ...
                       results.p==31        & ...
                       results.d==0         & ...
                       results.n==500,:);
    for k = 2:5
        for method = 1:8
            selected = filtered(filtered.k==k & ...
                                filtered.method==method,:);
            mu(method,k-1) = mean(selected.mcc);
            mu_sigma{method,k-1} = sprintf('%.3f (%.3f)',mean(selected.mcc),std(selected.mcc));
        end
        ranking(:,k-1) = tiedrank(mu(:,k-1));
    end
    method = {'SCP','SCA','DCP','DCA','SCPD','SCAD','DCPD','DCAD'}';
    disp(['ranking (alpha = ' num2str(alpha) ')'])
    disp([cell2table(method) array2table(ranking)])
    disp(['mu_sigma (alpha = ' num2str(alpha) ')'])
    disp([cell2table(method) cell2table(mu_sigma)])
end
