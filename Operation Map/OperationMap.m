clc; clear; close all;

pkg load io

function [] = RangePlot(speed_mph, ex_locs)

    speed_max = speed_mph/0.8;
	radius = speed_mph/4; % radius at cruise speed mi
	radius_max = speed_max/4; % radius at max speed mi
	inner_green = [19 69 32]/255;
    outer_green = [198 224 180]/255;
    
	% lat, long
	% California GPS coors
    %
	california = { [41.998, -124.212], ... % upper left corner
        [41.994, -119.999], ... % upper right corner
        [38.999, -120.001], ... % lake Tahoe
        [35.002, -114.634], ... % Southern Tip Nevada
        [32.719, -114.720], ... % Southeastern tip CA
        [32.534, -117.124], ... % Southwestern tip CA
        [33.460, -117.714], ... % Dana Point
        [33.736, -118.403], ... % Long Beach Tip
        [34.568, -120.635], ... %
        [35.671, -121.281], ... % west Hearst Castle
        [37.800, -122.516], ... % SF
        [38.945, -123.720], ... %
        [39.665, -123.791], ... % near Westport-Union Landing State Beach
        [40.258, -124.358], ... % Petrolia, CA tip southwest
        [40.409, -124.387] }; % CapeTown, CA
	
    % create legend colors
 	figure;
	hold all;


	bases = readBases();

	drawCircles(bases, radius_max, inner_green);
	drawCircles(ex_locs, radius_max, inner_green);
	drawCircles(bases, radius, outer_green);
	drawCircles(ex_locs, radius, outer_green);
	drawBases(ex_locs, 'k+');
	drawBases(bases, 'kx');
	drawState(california);

	axis equal
	set(gca, 'FontName', 'Liberation Sans');
	set(gca,'fontsize', 20);
	set(gca,'linewidth',2)
    set(gca,'visible','off')
	%saveas(gcf, ['Aerial Coverage Map'], 'fig')
	%print(['Aerial Coverage Map'], '-dpng')
	
endfunction

function [dist, coor1, coor2] = findFurthest(bases)

	dist = 0;
	n = length(bases);
	for i=1:n
		if i == n
			j = 1; 
		else
			j = i + 1;
		end

		new_dist = distanceInKmBetweenEarthCoordinates(bases{i}.lat, bases{i}.long, bases{j}.lat, bases{j}.long);
		if new_dist > dist

			dist = new_dist;
			coor1.name = bases{i}.name;
			coor1.lat = bases{i}.lat;
			coor1.long = bases{i}.long;
			coor2.name = bases{j}.name;
			coor2.lat = bases{j}.lat;
			coor2.long = bases{j}.long;
		end

	end


	plot([coor1.long coor2.long],[coor1.lat coor2.lat],'g--')

endfunction


function [] = drawCircles(bases, radius, color)

	for i=1:length(bases)
		[x, y] = gpsToCart(bases{i}.lat,bases{i}.long);
		rectangle('Position',[x-radius,y-radius,radius*2,radius*2],'FaceColor', color, 'Curvature', [1 1], 'linewidth', 0.5);
	end

end

function [bases] = readBasesAir()

	[num, txt, raw] = xlsread('AirportLocations.xlsx','Airports');
    rows = size(raw);
    j=1;
    for i=1:rows(1)-1
        if raw{1+i,6} == 'x'
            firebase.name = raw{1+i,3};
            firebase.lat = raw{1+i,4};
            firebase.long = raw{1+i,5};
            bases{j} = firebase;
            j = j+ 1;
        end
    end

endfunction

function [bases] = readBases()

	[num, txt, raw] = xlsread('airBases.xlsx');
	for i=1:13

		firebase.name = raw{1+i,3};
		firebase.lat = raw{1+i,4};
		firebase.long = raw{1+i,5};
		bases{i} = firebase;

	end

endfunction

function [] = drawBases(bases, opt)

	for i=1:length(bases)

		[x, y] = gpsToCart(bases{i}.lat,bases{i}.long);
		plot(x, y, opt, 'markerSize', 7, 'linewidth', 2);
 		text(x + 10, y, bases{i}.name)

	end
endfunction




function [] = drawState(state)

	x=zeros(1,length(state)+1);
	y=zeros(1,length(state)+1);
	for i=1:length(state)
	    [ x(i), y(i) ] = gpsToCart( state{1,i}(1,1),  state{1,i}(1,2) );
	end
	[ x(i+1), y(i+1) ] = gpsToCart( state{1,1}(1,1),  state{1,1}(1,2) );
% 	plot(x,y,'kx', 'MarkerSize', 2);
    plot(x,y,'k', 'MarkerSize', 2);


endfunction


function [x, y] = gpsToCart(lat, long)

	dx = 121.396;
	dy = -38.671;

	y = (lat + dy) * 69; % dist btwn lat
	x = (long + dx) * cosd(lat) * 69.172; % dist btwn long equator

endfunction


% change reference center location

range_speeds = 225;

new_bases = readBasesAir();

RangePlot( range_speeds, new_bases  )
