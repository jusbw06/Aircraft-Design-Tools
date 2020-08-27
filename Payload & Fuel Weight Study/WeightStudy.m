clc; clear; close all;

global We
global Wp
global total_iterations
total_iterations = 0;
We = 28400; % lb

rho = 8.345; % gal to lb

refuel_time = 20; % min
refill_time = 5; % min
time_to_fire = 15; % min
time_from_fire = 15; % min
loiter_time = 5; % min

total_time_rep = refill_time + time_to_fire + time_from_fire + loiter_time;

for n=1:10

	num_consec_trips = n;
	total_time_var = refuel_time/num_consec_trips;
    
	total_time = total_time_rep + total_time_var;
	Vp(n) = 2000 * total_time/60; % gal
	Wp = Vp(n) * rho; % rho water or retardant


	% find the fuel required for one trip at one particular n value
    % guess at 2000 lb
	Wfu = fzero( @(x) fuel_on_trip(n,x), 2000);

    data.Wp(n) = Wp;
    data.Wfu(n) = Wfu;
    data.Wtot(n) = Wp + Wfu;
    data.n(n) = n;
    data.t(n) = total_time;
    data.Vp(n) = Vp(n);
    
    disp(['Num Consec Trips: ' num2str(n) newline 'Weight Payload: ' ...
        num2str(Wp) newline 'Weight Fuel: ' num2str(Wfu) newline 'Total: ' ...
        num2str(Wp+Wfu) newline])
    
end

dist_one_trip = 2 * 225 * 0.25; % 2 trips dist is 1/4 of speed 15 min
dist_reserve = 225 * 0.75; % 3/4 hr is 45 min
design_range = [1:10] * dist_one_trip + dist_reserve;

[M,I] = min(data.Wtot);

figure;
hold all
plot(design_range,data.Wfu/1000, '--','LineWidth',2)
plot(design_range,data.Wp/1000, '--','LineWidth',2)
plot(design_range,data.Wtot/1000,'LineWidth',2)
plot(design_range(I),M/1000, '*','LineWidth',2,'MarkerSize',15)
% text(design_range(I),M/1000, ['\leftarrow ' num2str(I) ' Consecutive Trips'], 'FontSize', 18)
xlabel('Design Range (mi)')
ylabel('Liquid Weight (lb-10^3)')
legend('Fuel Weight', 'Payload Weight', 'Fuel & Payload', 'Minimum Point')
grid on
set(gca,'LineWidth',2)
set(gca,'FontSize',18)
set(gca,'FontWeight','bold')
xlim([design_range(1) design_range(end)])
ylim([0 20])
disp(['Total Iterations: ' num2str(total_iterations) newline])
disp('Minimum: ')
% disp(['Num Consectrips: ' num2str(I)])
printFields(data, I)

function [] = printFields(data, i)
    
    disp(['Num Consec Trips: ' num2str(i) newline 'Weight Payload: ' ...
        num2str(data.Wp(i)) newline 'Payload Capacity: ' ... 
        num2str(data.Vp(i)) newline 'Weight Fuel: ' num2str(data.Wfu(i)) ...
        newline 'Total: ' num2str(data.Wtot(i)) newline])


end


% This function takes in a number of consecutive trips value and a fuel
% weight guess and returns the fuel wight necessary to complete that number
% of trips
% Wfu is initial fuel guess, should return 0 on success
function [Wfu] = fuel_on_trip(n,Wfu)
    global We
    global Wp
    for i=1:n
        % while payload is still on craft
		Wi = We + Wp + Wfu;
        Wf = We + Wp;
		Wf = fzero( @(x) range_func(Wi,x, 15), Wf );

		dx = Wi - Wf; % fuel burned
		Wfu = Wfu - dx;

		Wi = We + Wfu;
		% while payload is empty
		Wf = fzero( @(x) range_func(Wi,x, 15), We );

		dx = Wi - Wf; % fuel burned
		Wfu = Wfu - dx;
    end
    
    % Reserve Fuel
    % Fuel required to go for 45 min
    % while payload is still on craft
    Wi = We + Wp + Wfu;
    Wf = We + Wp;
    Wf = fzero( @(x) range_func(Wi,x, 45), Wf );

    dx = Wi - Wf; % fuel burned
    Wfu = Wfu - dx;
    
end

% This function takes an initial weight and a final weight and returns the
% difference between the required range and the range travelled at those
% given initial weight parameters flight time is time in min per trip
function [dx] = range_func(Wi,Wf, flight_time)

    global total_iterations
    total_iterations = total_iterations + 1;

	LoD = 16;
	SFC = 0.4;
	V = 225/60^2; % mi/s
	eta_p = 0.8;
    cruise_speed = 225;
	range_trip = flight_time/60 * cruise_speed; %mi

	range = 375 * eta_p / SFC * LoD * log(Wi/Wf);

	dx = range - range_trip;

end 
