 function [comp] = createComponentFromEntry(entry)

   comp.ID = cell2mat(entry(1));
   comp.desc = cell2mat(entry(2));
   comp.weight = cell2mat(entry(3));
   comp.start_loc = cell2mat(entry(4));
   comp.cg_loc = cell2mat(entry(5));
   comp.length = cell2mat(entry(6));
   comp.group = cell2mat(entry(7));
   
 endfunction
 
 
