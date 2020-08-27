function [cg] = wingCG(perc_span, leading_edge_offset, root_chord, tip_chord, cg_loc)

  x = perc_span * leading_edge_offset + cg_loc * ( (1-perc_span)*(root_chord-tip_chord) + tip_chord)

  cg = x/root_chord

end