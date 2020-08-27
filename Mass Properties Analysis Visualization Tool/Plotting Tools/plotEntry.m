function [] = plotEntry(comp, z)

  x = [comp.start_loc (comp.start_loc+comp.length)];
  y = [z z];
  cg_dot = comp.start_loc + comp.length*comp.cg_loc;
  
  hold on
  plot(x,y, '--')
  plot(cg_dot,z,'*')
  text(comp.start_loc,z,comp.desc, 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left')
  
endfunction
