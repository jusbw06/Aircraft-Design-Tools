function [components] = growFuselage(dist, components)
  
  for i=1:length(components)
    if components(i).group == 1
      components(i).length = components(i).length + dist;
    elseif components(i).group == 2
      components(i).start_loc = components(i).start_loc + dist;
    endif
  endfor
  
  
endfunction
