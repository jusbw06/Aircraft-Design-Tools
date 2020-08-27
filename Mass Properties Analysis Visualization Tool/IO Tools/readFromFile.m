function [components] = readFromFile()
  
  [numarr, txtarr, rawarr, limits] = xlsread('MassPropertiesLocations.ods');
  A = size(rawarr);
  for i=1:A(1)-1
    components(i) = createComponentFromEntry( rawarr(i+1,:) );
  endfor
  
endfunction
