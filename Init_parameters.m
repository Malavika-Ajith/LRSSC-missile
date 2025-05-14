function params = Init_parameters()
    % Design Requirements : Given
    params.given_mach = 0.8;
    params.given_range = 1000;           % km
    params.given_payload = 300;          % kg
    params.given_cruise_altitude = 5;    % m
    
    %Assumed
    params.AR=4;                         % Assumed for getting a good lift at low speeds    
    params.e=0.8;                        % Assumed from referece book
    params.l_d=11;                       % Assumed length/diameter ratio

    % Baseline Parameters : Tomahawk missile (All SI units)
    params.base_length = 5.56;           % m
    params.base_diameter = 0.52;         % m
    params.base_launch_weight = 1300;    % kg
    params.base_payload = 450;           % kg
    params.base_range = 1600;            % km
    params.base_mach = 0.74;
    params.base_thrust = 2700;           % N
    params.base_wingspan = 2.67;         % m
    params.base_wing_area= 0.74;         % m^2
    params.base_tail_span=0.91;          % m
    params.base_cruise_alt = 30;         % m
    params.base_L_D =7;  
    params.base_engine_l=1.0;            % m


    % Scaling the parameters from baseline model
    params.scaled_range = params.given_range /params.base_range ;          
    params.scaled_payload = params.given_payload / params.base_payload;          
end