function [components] = addFuselageStation(components)
  
  for i=1:length(components)
    components(i).fs = components(i).start_loc + components(i).cg_loc*components(i).length;
  endfor
  
endfunction
