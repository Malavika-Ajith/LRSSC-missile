function Display_params(GTOW, W_empty, W_fuel, W_fuel_climb, W_fuel_cruise, W_fuel_terminal, CDi, L_D_new, CL,CD,wing_loading,b,c,V_fuel,T_cruise, P_required, engine_weight,P_out,L_fuselage,L_nose,L_warhead,L_fuel,engine_length,Tail_area, Tail_span, Tail_chord)
    fprintf('----------------------------------------\n');
    fprintf('\n----- Missile Design Output -----\n');

    fprintf('\nWeight Estimates\n');
    fprintf(' Gross Takeoff Weight (kg)          : %.2f kg\n', GTOW);
    fprintf(' Empty Weight (kg)                  : %.2f kg\n', W_empty);
    fprintf(' Total Fuel Weight (kg)             : %.2f kg\n', W_fuel);
    fprintf(' Climb Fuel (kg)                    : %.2f kg\n', W_fuel_climb);
    fprintf(' Cruise Fuel (kg)                   : %.2f kg\n', W_fuel_cruise);
    fprintf(' Terminal Fuel (kg)                 : %.2f kg\n', W_fuel_terminal);
    
    fprintf('\nAerodynamic Estimates\n');
    fprintf('  Induced Drag (                    : %.4f\n', CDi);
    fprintf('  Lift-to-Drag Ratio                : %.2f\n', L_D_new);
    fprintf('  Lift Coefficient                  : %.2f\n', CL);
    fprintf('  Lift Coefficient                  : %.2f\n', CD);
    
    fprintf('\nWing Estimates\n');
    fprintf('  Wing Loading (N/m^2)              : %.4f\n', wing_loading);
    fprintf('  Wing Span (m)                     : %.2f\n', b);
    fprintf('  Mean Aerodynamic Chord(m)         : %.2f\n', c);

    fprintf('\nFuel Tank Estimates\n');
    fprintf('  Volume of Fuel Tank (m^3)         : %.2f\n', V_fuel);

    fprintf('\nEngine Estimates\n');
    fprintf('  Thrust required (N)               : %.2f\n', T_cruise);
    fprintf('  Required Power (W)                : %.2f\n', P_required);
    fprintf('  Engine Weight (kg)                : %.2f\n', engine_weight);
    fprintf('  Power Output of Engine (W)        : %.2f\n', P_out);

    fprintf('\nFuselage Estimates\n');
    fprintf('  Fuselage Length (m)               : %.2f\n', L_fuselage);
    fprintf('  Nose Length (m)                   : %.2f\n', L_nose);
    fprintf('  Warhead Length (m)                : %.2f\n', L_warhead);
    fprintf('  Fuel Tank Length (m)              : %.2f\n', L_fuel);
    fprintf('  Engine Length (m)                 : %.2f\n', engine_length);

    fprintf('\nTail Estimates (Control surface)\n');
    fprintf('  Tail Area (m^2)                  : %.2f\n', Tail_area);
    fprintf('  Tail Span (m)                    : %.2f\n', Tail_span);
    fprintf('  Tail Chord (m)                   : %.2f\n', Tail_chord);
    fprintf('----------------------------------------\n');

end