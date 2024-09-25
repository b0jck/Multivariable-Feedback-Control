function u = sigmoid_f(t, delay, steepness, u_min, u_max)
   
   
  % Create "delay vector"
   b = ones(size(t))*delay;

   u = 1./(1 + exp(-steepness*(t-b)));
   
   % Normalize in [0,1];
    u = u - u(1);
    u = u / max(u);

   % Rescale and center between u_min, u_max

    u = (u_max-u_min)* u + u_min;
end

