function [return_val, components] = parseExpr(str, index, components)
  
  str;
  
  op_index = 3;
  link_id(1) = str(2);
    
  if( isdigit(str(3)))
    
    link_id(2) = str(3);
    op_index = 4;
      
  endif
    
  link_id = str2num(link_id);

  if (str(op_index) == '*')
    operator = '*';
  else
    operator = '+';
  endif
    
  val = substr(str,op_index+1);
  value = str2num(val);
    
    %-----------link_id, operator, value -------------  
    
  if components(link_id).start_loc(1) == '#'
    % a link
    [tmp, components]= parseExpr(components(link_id).start_loc,link_id,components);
    components(index).start_loc = tmp;
  elseif components(link_id).length(1) == '#'
    % a link
    [tmp, components] = parseExpr(components(link_id).length,link_id,components);
    components(index).length = tmp;
  endif
  
  % After Links Set
  if operator == '*'
    return_val = components(link_id).start_loc+components(link_id).length*value;
  elseif operator == '+'
    return_val = components(link_id).start_loc+value; 
  endif 
  
endfunction

 %{   
    if operator == '*'
      
      if components(link_id).start_loc(1) == '#'
        % a link
          comp.start_loc = parseExpr(components(link_id).start_loc,components(link_id),components);
      elseif components(link_id).length(1) == '#'
          comp.length = parseExpr(components(link_id).start_loc,components(link_id),components);
      else
        % not a link
        return_val = components(link_id).start_loc+components(link_id).length*value;
      endif
      
    elseif operator == '+'

      if components(link_id).start_loc(1) == '#'
        % a link
          comp.start_loc = parseExpr(components(link_id).start_loc,components(link_id),components);
      else
        % not a link
          return_val = components(link_id).start_loc+value;     
       endif
       
    endif
    %}