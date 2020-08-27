function [components] = linker(components)

  for i=1:length(components)
    
    if( components(i).start_loc(1) == '#')
      [tmp, components] = parseExpr(components(i).start_loc, i, components);
      components(i).start_loc = tmp;
    endif
    
    if( components(i).length(1) == '#')
      [tmp, components] = parseExpr(components(i).length, i, components);
      components(i).length = tmp;      
    endif
  
  endfor
  
  
endfunction


