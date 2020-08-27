function [result_array, weight_sum_] = findCG(components)
  % 13 - Fuel
  % 14 - Retardant
  % [ Empty, Fuel, Retardant, Full ]
  
  moment_sum_ = zeros(1,4);
  weight_sum_ = zeros(1,4);
  for i=1:length(components)
  
    for j=1:4
      if j == 1 && (i == 13 || i == 14)
        continue;
      elseif j == 2 && i == 14
        continue;        
      elseif j == 3 && i == 13
        continue;
      else
        moment_sum_(j) = moment_sum_(j) + (components(i).start_loc + components(i).length*components(i).cg_loc) * components(i).weight;
        weight_sum_(j) = weight_sum_(j) + components(i).weight;
      endif
    endfor

  endfor

  weight_sum_
  
  result_array = moment_sum_./weight_sum_;
  
endfunction
