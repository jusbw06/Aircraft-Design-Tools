pkg load io
graphics_toolkit("gnuplot")
clc; clear; close all;

MTOW = 41085.5;

% init -- manual fixes
components = readFromFile();
components = linker(components);
components(12).length = components(3).length*0.5; % fix
components(13).length = components(3).length*0.5;
components = addComponent('Rear Avionics',250,components(11).start_loc + components(11).length*1.25,0.5,4,3, components);


% manual tweaks
components(10) = moveComp(-0.5,components(10)); % forward avionics
components(15) = moveComp(3,components(15)); % rear avionics
components = growFuselage(4.5, components);
components(5) = moveComp(-2.5,components(5)); % main landing gear


% find MAC
MAC =11.073;
LE_MAC = components(3).start_loc+0.504;
TE_MAC = components(3).start_loc+0.504+MAC;
mac_x = [LE_MAC TE_MAC];

MAC_3 = LE_MAC + MAC*0.3

% move wet components to desired cg_loc
components(11) = moveCompAbs(MAC_3,components(11)); % tank
components(14) = moveCompAbs(MAC_3,components(14)); % retardant
components(11) = moveComp(0,components(11));
components(14) = moveComp(0,components(14));

[cg_x_loc, weights] = findCG(components)
%components = adjustToMTOW( MTOW, weights(4), components);
%[cg_x_loc, weights] = findCG(components)

per_mac = (cg_x_loc - LE_MAC)/MAC




MAC_Qtr = LE_MAC + 0.25*MAC;

% Find percentage weight to nose gear
dist_to_nose_gear = cg_x_loc - components(6).start_loc;
dist_to_main_gear = components(5).start_loc - cg_x_loc;
tot = dist_to_nose_gear + dist_to_main_gear;
nose_rat = 1 - dist_to_nose_gear./tot

%% Plot all Entities
% construct plot
figure;
hold all
plotEntry(components(1), .1)
plotEntry(components(2), .075)
plotEntry(components(3), .05)
plotEntry(components(4), 0)
plotEntry(components(5), -.03)
plotEntry(components(6), -.03)
plotEntry(components(7), .015)
plotEntry(components(8), 0.05)
plotEntry(components(9), .03)
plotEntry(components(10), -.015)
plotEntry(components(11), -.015)
plotEntry(components(12), .04)
%plotEntry(components(13), .06)
%plotEntry(components(14), -.025)
plotEntry(components(15), -.015)

% plot MAC
plot(mac_x, [0.06 0.06], '--')
text(LE_MAC,0.06,'MAC', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left')
%plot(cg_x_loc(1),0.06,'s')
%text(cg_x_loc(1),0.06,'CG', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center')
plot(MAC_3,0.06,'s')
text(MAC_3,0.06,'CG', 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'center')
xlabel('ft')
axis([0 50 -0.1 .3])

fus_len = components(2).start_loc + components(2).length

fuselage_station = addFuselageStation(components);

%adjusted_components = adjustToMTOW( 41085.5, weights(4), components)
%[cgs weights] = findCG(adjusted_components)