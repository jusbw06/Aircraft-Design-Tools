function [adjusted_components] = adjustToMTOW(real_MTOW, calc_MTOW, components)
  % 13 - Fuel
  % 14 - Retardant
  % [Empty, Fuel, Retardant, Full ]
  
  exempt_indices = [13 14];
  
  real_MTOW = real_MTOW - components(13).weight - components(14).weight
  calc_MTOW = calc_MTOW - components(13).weight - components(14).weight
  
  
  adj_rat = real_MTOW/calc_MTOW
  
  for i=1:length(components)
    adjusted_components(i) = components(i);

    
    if any(exempt_indices == i)
      continue;
    endif
    adjusted_components(i).weight = components(i).weight * adj_rat;
    
    
  endfor
  
  
endfunction
