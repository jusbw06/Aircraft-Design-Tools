function [components] = addComponent(desc, weight, start_loc, cg_loc, len, group, components)
  
   comp.ID = length(components)+1;
   comp.desc = desc;
   comp.weight = weight;
   comp.start_loc = start_loc;
   comp.cg_loc = cg_loc;
   comp.length = len;
   comp.group = group;
   
   components(end+1) = comp;
  
endfunction
