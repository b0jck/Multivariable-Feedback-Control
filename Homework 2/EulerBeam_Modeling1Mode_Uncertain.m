% Dynamic model of a single flexible link % modeled as an Euler-Bernoulli beam% with geometric/dynamic boundary conditions% A. De Luca, May 2023% reference: Bellezza, Lanari, Ulivi (ICRA 1990 paper)%% global L ro J0 Jp Mp% set of parameters used in the ICRA 1990 paper% J0 = 1.95e-3;% L = 0.7;% ro = 2.975;% %E=2.1*10^11;% %I=1.167*10^(-11);% EI = 2.4507;% Mp = 0.117;% Jp = 0;% set of parameters used in the ECCI slide #22 on flexible link robotsJ0=0.002;L=1;ro=0.5;EI=1;R = 0.1;M = [0:0.01:0.5];    J = zeros(size(M));    Om2 = zeros(size(M));                     % square of the eigenfrequencies om_i^2 (in rad)    Phip0 = zeros(size(M));        % phi'_i(0)    PhiL = zeros(size(M));for j=1:length(M)        Mp = M(j);    Jp= 2/5*(R)^2*Mp;    n = 1;    % change this if you want a different number of elastic modes        % compute the first n modes        b = r2rfind(n);        % solutions of the characteristic equation, finds the n betas (it's a vector)    x = [0:L/100:L]';        % r2rmod(b(k)): for every beta, finds the corresponding coeefficients A B C D    % see p. 14 of the slides    for k = 1:n       [A_coeff(k),B_coeff(k),C_coeff(k),D_coeff(k)] = r2rmod(b(k));       phi(:,k) = A_coeff(k)*sin(b(k)*x)+B_coeff(k)*cos(b(k)*x)+ ...                  C_coeff(k)*sinh(b(k)*x)+D_coeff(k)*cosh(b(k)*x);    end        % parameters appearing in the model (and in tip output)        J(j) = ro*L^3/3+J0+Jp+Mp*L^2;  % total rotational inertia of the flexible arm    Om2(j)    = b.^4*EI/ro;                         % square of the eigenfrequencies om_i^2 (in rad)    Phip0(j)  = b.*(A_coeff+C_coeff);        % phi'_i(0)    PhiL(j)    = A_coeff.*sin(b*L)+B_coeff.*cos(b*L)+C_coeff.*sinh(b*L)+D_coeff.*cosh(b*L); % phi_i(L)end       % the elements of Phip0 appear in the input matrix of the pseudo-pinned model (p. 17 &    % 18 slides)    % the elements of PhiL appear in the output matrix of the tip output (p. 20 Slides)        % % plots of the modes. each mode is paused    % % uncomment if necessary    %     %{      figure;     set(gcf,'NumberTitle','Off');     set(gcf,'Name','deformation modes');     grid on; hold on;          for i=1:n         xlabel('x [m]'); ylabel(['phi_',num2str(i),'']);         plot(x,phi(:,i));  	    if i~=n 	       pause; cla     	    end     end     hold off              %}    