function [x1] = findDist2MAC(root, tip, leading_edge_offset, half_span)
  
  root_sum = root + tip*2;
  tip_sum = tip + root*2;
  
  span_dist_to_mac = (root_sum)/(root_sum+tip_sum)*half_span;
  x1 = span_dist_to_mac/half_span*leading_edge_offset;
  x2 = span_dist_to_mac/half_span*(root-tip-leading_edge_offset);
  mac = root-x1-x2;
  
  
endfunction
