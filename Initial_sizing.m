function Initial_sizing(params)
    % Calling parameters from init function
    payload_weight = params.given_payload;
    range = params.given_range;
    L_D = params.base_L_D;
    cruise_mach =params.given_mach;
    AR = params.AR;          
    e = params.e;     
    S_ref = params.base_wing_area;  
    L_missile=params.base_length;
    l_d_ratio=params.l_d;
    engine_ref_l=params.base_engine_l;
    T_base_ref=params.base_thrust;
    
    % Calculating cruise velocity
    V_cruise = estimate_cruise_velocity(cruise_mach);
   
    % Calculating GTOW
    [GTOW, W_empty, W_fuel, W_fuel_climb, W_fuel_cruise, W_fuel_terminal] = estimate_takeoff_weight(payload_weight, range, L_D,V_cruise);
    
    %Calculating aerodynamic parameters
    [CDi, CD, CL, L_D_new] = estimate_aerodynamics(GTOW,V_cruise,AR,e, S_ref);
    
    %Calculating wing parameters
    [wing_loading,b,c] = estimate_wing(GTOW,AR,S_ref);
    
    % Calculating fuel tank volume
    V_fuel = estimate_fuel_volume(W_fuel);

    % Calculating engine parameters
    [T_cruise, P_required, engine_weight,P_out] = estimate__engine(GTOW, V_cruise, L_D_new);

    % Calculating fuselage parameters
    [L_fuselage,L_nose,L_warhead,L_fuel,engine_length] = estimate_fuselage_length(payload_weight, V_fuel,  L_missile, l_d_ratio,engine_ref_l,T_cruise,T_base_ref);
    
    % Calculating tail parameters
    [Tail_area, Tail_span, Tail_chord]=estimate_tail(S_ref,L_fuselage);

    % Checking Static stability
    check_static_stability(c,CL);

    % Displaing parameters
    Display_params(GTOW, W_empty, W_fuel, W_fuel_climb, W_fuel_cruise, W_fuel_terminal, CDi, L_D_new, CL,CD,wing_loading,b,c,V_fuel,T_cruise, P_required, engine_weight,P_out,L_fuselage,L_nose,L_warhead,L_fuel,engine_length,Tail_area, Tail_span, Tail_chord);
end

function V_cruise = estimate_cruise_velocity(cruise_mach)
         V_cruise = cruise_mach*340.0;
end

function [GTOW, W_empty, W_fuel, W_fuel_climb, W_fuel_cruise, W_fuel_terminal] = estimate_takeoff_weight(payload_weight, range,L_D,V_cruise)

% Initial Assumptions and Parameters
initial_GTOW = 1000;  % Initial guess for GTO (kg)

SFC = 0.5/3600;       % SFC in kg/N/s
wf_climb = 0.05;       % Fuel fraction for climb - referenced from Tomahawk
wf_terminal = 0.15;    % Fuel fraction for terminal - referenced from Tomahawk
empty_wf = 0.5;       % Airframe, propulsion, and avionics fraction of GTO

max_i = 100;         % Maximum no of iterations

% Initialize
GTOW = initial_GTOW;     
i = 0;              % Initialize iteration count
GTOW_old = 0;       % Previous GTOW value to check for convergence

while i < max_i
    i = i + 1;
    
    % Empty weight 
    W_empty = empty_wf * GTOW;
      
    % Estimating fuel weight using the Breguet range equation
    W_fuel_climb = wf_climb * GTOW;

    % Cruise Fuel
    Wi = GTOW - W_fuel_climb;  % Weight at start of cruise

    % Breguet weight fraction
    weight_fraction = exp(-range * 1000 * SFC / (V_cruise * L_D));
    W_fuel_cruise = Wi * (1 - weight_fraction);

    % Terminal fuel
    W_fuel_terminal = wf_terminal * GTOW;
    
    % Total fuel weight
    W_fuel = W_fuel_climb + W_fuel_cruise + W_fuel_terminal;
    
    % Total GTOW by Raymers approach
    GTOW_new = W_empty + W_fuel + payload_weight;
    
    if abs(GTOW_new - GTOW_old) < 1e-4
        break;
    end
    
    GTOW_old = GTOW_new;
    GTOW = GTOW_new;
end
end

function [CDi, CD, CL, L_D_new] = estimate_aerodynamics(GTOW,V_cruise,AR,e, S_ref)


    rho = 1.225;    % density at sea level (kg/m^3)                   

    %  Lift Coefficient
    CL = (GTOW*9.81) / (0.5 * rho * V_cruise^2 * S_ref);

    % Induced Drag Coefficient
    k = 1 / (pi * AR * e);
    CDi = k * CL^2;

    % Total Drag Coefficient
    CD0 = 0.02;  % Assumed for missiles
    CD = CD0 + CDi;

    %  Lift-to-Drag Ratio
    L_D_new = CL / CD;
end

function [wing_loading,b,c] = estimate_wing(GTOW,AR,S_ref)

    %  Wing loading
    wing_loading = GTOW / S_ref;  %(N/m^2)

    % Wing span
    b = sqrt(AR * S_ref);      % Wing span (m)

    % mean aerodynamic chord (MAC)
    c = S_ref / b;             % Mean aerodynamic chord (m)
end

function V_fuel = estimate_fuel_volume(W_fuel)
    
    fuel_density = 940; %JP-10 in kg/m^3
    V_fuel = W_fuel / fuel_density;
end

function [T_cruise, P_required, engine_weight,P_out] = estimate__engine(GTOW, V_cruise, L_D_new)

    % Assumed engine efficiency
    engine_efficiency = 0.85; 
   
    % Thrust Required for Cruise
    T_cruise = (GTOW*9.81) / L_D_new; 

    % Power required
    P_required = T_cruise * V_cruise;

    % Power out
    P_out = P_required*engine_efficiency;
    
    %  Engine Weight
    thrust_to_weight_ratio = 4;  % N/kg, average for small turbojets
    engine_weight = T_cruise / thrust_to_weight_ratio;  % in kg

end

function [L_fuselage,L_nose,L_warhead,L_fuel,engine_length] = estimate_fuselage_length(payload_weight, V_fuel,  L_missile, l_d_ratio,engine_ref_l,T_Cruise,T_base_ref)
   
    L_nose = 0.6;  % m, avionics and seeker section 
    
    % Warhead length 
    warhead_density = 1700;  % kg/m^3
    V_warhead = payload_weight / warhead_density; 
    
    % Estimate fuselage diameter based on the scaled diameter approach  based on length diameter ratio
    d_warhead = L_missile / l_d_ratio; 
    
    A_cross = pi * (d_warhead / 2)^2;
    L_warhead = V_warhead / A_cross;

    % Length of the fuel tank section
    d_fuel = d_warhead;  % m, assumed same diameter for fuel section
    A_fuel = pi * (d_fuel / 2)^2;
    L_fuel = V_fuel / A_fuel;

    % Engine length based on the scaled diameter approach
    engine_length=engine_ref_l*(T_Cruise/T_base_ref)^1/3;

    % Total fuselage length 
    L_fuselage = L_nose + L_warhead + L_fuel + engine_length;
end

function [Tail_area, Tail_span, Tail_chord]=estimate_tail(S_ref,L_fuselage)

    tail_arm_ratio = 0.8;            % Assumed 80% of missile length
    V_t = 0.065;                     % Tail volume coefficient, typical value assumed for tactical missiles

    % Tail Area 
    lt = tail_arm_ratio * L_fuselage;         % Tail arm (moment arm from CG to tail AC)
    Tail_area = V_t * (S_ref * L_fuselage) / lt;    % Tail surface area (m^2)
    
    % Tail Span
    AR_t = 2.0;   %aspect ratio of tail assumed                   
    Tail_span = sqrt(AR_t * Tail_area);          
    
    % Tail Chord 
    Tail_chord = Tail_area / Tail_span;   
    
end

function check_static_stability(c,CL)

    downwash = 0.3; %assumed for subsonic
    CG=0.5; %assumed from reference
    V_t = 0.065;                     % Tail volume coefficient, typical value assumed for tactical missiles
    CL_tail=0.3; %assumed

    % Compute NP location
    x_NP = c + V_t * (CL_tail / CL) / (1 - downwash);

    % Static margin
    static_margin = (x_NP - CG) / c;

    if static_margin > 0
        disp('Longitudinally Stable');
    else
        disp('Longitudinally Unstable');
    end
end

