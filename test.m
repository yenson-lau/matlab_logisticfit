n = 20;                                 % grid size
a = [1 sign(rand*2-1)*(0.5+rand/2)];    % slope
b = (rand*2-1)*0.1;                     % intercept
c = 10;                                 % sharpness of transition line
d = 1e-1;                               % noise level

[X1,X2] = meshgrid(linspace(-0.5,0.5,n), linspace(-0.5,0.5,n));

Y = 1./(1+exp(-c*(X1*a(1) + X2*a(2) + b)));
Y = min(max(Y + d*randn(size(Y)), 0),1);

%%
w0 = 1e2*([a b]+randn(1,3)/2/c);          % noisy estimate of parameters

%profile on;
[w, costs, Yhat, info] = logisticfit([X1(:) X2(:)], Y(:), w0, struct('trials', [20 1]));
%profile off; profile viewer;

subplot(131); imagesc(Y');    
title(sprintf('Simulated\n'));

err = w/w(1) - repmat([a b], [size(stats,1) 1]);
subplot(132); imagesc(reshape(Yhat, size(Y))');
title(sprintf('Recovered\n Error: [%.3f %.3f]', err(2:end)));


subplot(133); plot(costs); 
xlim([0 size(costs,1)-1]);
title(sprintf('Costs\n')); xlabel('Iter.');