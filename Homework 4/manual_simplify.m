function [P] = manual_simplify(P1)
sz = size(P1);
nu = sz(2);
ny = sz(1);
P = P1;
for i=1:ny
    for j=1:nu
    G = P1(i,j);
    polez = round(sort(pole(G),'ComparisonMethod','abs'),4);
    zeroz = round(sort(zero(G),'ComparisonMethod','abs'),4);

    gain = zpk(G).K;
    P(i,j) = gain * simplific(polez,zeroz);
    end
end
end 


function [simpl] = simplific(polez,zeroz)
    s = tf('s');
    i = 1;
    while(i <= length(polez))
       add = 1;
       Pi = polez(i);
       if ~isreal(Pi) && imag(Pi) > 0
        polez(i) = [];
        continue
       end
       j = 1;
       while(j <= length(zeroz))
           Pz = zeroz(j);
           if ~isreal(Pz) && imag(Pz) > 0
            zeroz(j) = [];
            continue
           end
           if isreal(Pi) && isreal(Pz)
                 if abs(Pi - Pz) < 1e-5
                     zeroz(j) = [];
                     polez(i) = [];
                     add = 0;
                     break
                 end
           elseif ~isreal(Pi) && ~isreal(Pz)
                 r1 = real(Pi); i1 = imag(Pi);
                 r2 = real(Pz); i2 = imag(Pz);
                 if abs(r1 - r2) < 1e-5 && abs(i1 - i2) < 1e-5
                     zeroz(j) = [];
                     polez(i) = [];
                     add = 0;
                     break
                 end
           end
           j = j + 1;
       end
    if add
    i = i + 1;
    end
    end
    num = 1;
    den = 1;
    for i=1:length(polez)
          Pi = polez(i);
          if isreal(Pi)
            den = den*(s - Pi);  
          else
            re = real(Pi); im = imag(Pi);
            b = -2*re;
            c = b^2/4 + im^2;
            den = den*(s^2 + b*s + c);    
          end
    end
    for i=1:length(zeroz)
      Pi = zeroz(i);
      if isreal(Pi)
        num = num*(s - Pi);  
      else
        re = real(Pi); im = imag(Pi);
        b = -2*re;
        c = b^2/4 + im^2;
        num = num*(s^2 + b*s + c);    
      end
    end
    simpl = num/den;
end


