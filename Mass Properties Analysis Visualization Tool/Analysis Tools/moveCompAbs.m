function [comp] = moveCompAbs(val,comp)
  
  cg_dx = comp.cg_loc*comp.length;
  
  comp.start_loc = val - cg_dx;
  
endfunction
