function fillci(results,fi,alpha,k,p,d,ns,conf)
%FILLCI Plot results with shaded confidence intervals.
%
%   FILLCI(results,fi,alpha,k,p,d,ns,conf) plots the results with shaded
%   confidence intervals at a confidence level of conf.
%
%   See also EXPERIMENT.

%   Copyright 2022 Tak-Shing Chan

% Initialize variables.
m = zeros(1,length(ns));
ci = zeros(2,length(ns));
colors = [colororder;0 0 0];    % MATLAB color order plus black.
labels = {'SCP','SCA','DCP','DCA','SCPD','SCAD','DCPD','DCAD'};

% Filter results.
results = results(results.fi==fi       & ...
                  results.alpha==alpha & ...
                  results.k==k         & ...
                  results.p==p         & ...
                  results.d==d,:);

% Plot all methods.
figure
hold on
for method = 1:length(labels)
    for i = 1:length(ns)
        selected = results(results.n==ns(i) & ...
                           results.method==method,:);
        N = length(selected.mcc);

        % See https://www.mathworks.com/help/stats/tinv.html
        % If pLo+pUp=1 and pUp-pLo=conf then pLo=(1-conf)/2 and pUp=(1+conf)/2.
        t = tinv([1-conf;1+conf]/2,N-1);

        m(i) = mean(selected.mcc);
        ci(:,i) = m(i)+t*std(selected.mcc)/sqrt(N);
    end

    % See https://blogs.mathworks.com/graphics/2015/10/13/fill-between/
    h = fill([ns fliplr(ns)],[ci(2,:) fliplr(ci(1,:))],colors(method,:));
    h.FaceAlpha = 0.15;
    h.EdgeColor = 'none';
    h.Annotation.LegendInformation.IconDisplayStyle = 'off';
    plot(ns,m,'Color',colors(method,:),'DisplayName',labels{method})
end

% Add title and labels.
if alpha==1
    params = 'Cauchy';
elseif alpha==1.5
    params = 'Holtsmark';
elseif alpha==2
    params = 'Gaussian';
else
    params = ['S' num2str(alpha) 'S'];
end
if fi==true
    params = [params ' LRD'];
end
if d>0
    params = [params ', d=' num2str(d)];
end
title(['Reconstruction Performance (' params ')'])
xlabel('n')
ylabel('MCC')
ylim([0 1])
legend('Location','best')
hold off
