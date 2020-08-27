clc; clear; close all;


We = 28400; % lb
W_fuel = 2000; %lb

total_range = range_func(We+W_fuel, We);

disp(['Ferry Range: ', num2str(total_range)])


function [range] = range_func(Wi,Wf)

	LoD = 16;
	SFC = 0.4;
	eta_p = 0.8;

	range = 375 * eta_p / SFC * LoD * log(Wi/Wf);

end 
