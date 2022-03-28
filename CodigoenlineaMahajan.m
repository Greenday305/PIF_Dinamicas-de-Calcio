function [VOI, STATES, ALGEBRAIC, CONSTANTS] = mainFunction()
    % This is the "main function".  In Matlab, things work best if you rename this function to match the filename.
   [VOI, STATES, ALGEBRAIC, CONSTANTS] = solveModel();
end

function [algebraicVariableCount] = getAlgebraicVariableCount() 
    % Used later when setting a global variable with the number of algebraic variables.
    % Note: This is not the "main method".  
    algebraicVariableCount =108;
end
% There are a total of 26 entries in each of the rate and state variable arrays.
% There are a total of 80 entries in the constant variable array.
%

function [VOI, STATES, ALGEBRAIC, CONSTANTS] = solveModel()
    % Create ALGEBRAIC of correct size
    global algebraicVariableCount;  algebraicVariableCount = getAlgebraicVariableCount();
    % Initialise constants and state variables
    [INIT_STATES, CONSTANTS] = initConsts;

    % Set timespan to solve over 
    tspan = [0, 300];

    % Set numerical accuracy options for ODE solver
    options = odeset('RelTol', 1e-06, 'AbsTol', 1e-06, 'MaxStep', 1);

    % Solve model with ODE solver
    [VOI, STATES] = ode15s(@(VOI, STATES)computeRates(VOI, STATES, CONSTANTS), tspan, INIT_STATES, options);

    % Compute algebraic variables
    [RATES, ALGEBRAIC] = computeRates(VOI, STATES, CONSTANTS);
    ALGEBRAIC = computeAlgebraic(ALGEBRAIC, CONSTANTS, STATES, VOI);

    % Plot state variables against variable of integration
    [LEGEND_STATES, LEGEND_ALGEBRAIC, LEGEND_VOI, LEGEND_CONSTANTS] = createLegends();
    figure();
    plot(VOI, STATES);
    xlabel(LEGEND_VOI);
    l = legend(LEGEND_STATES);
    set(l,'Interpreter','none');
end

function [LEGEND_STATES, LEGEND_ALGEBRAIC, LEGEND_VOI, LEGEND_CONSTANTS] = createLegends()
    LEGEND_STATES = ''; LEGEND_ALGEBRAIC = ''; LEGEND_VOI = ''; LEGEND_CONSTANTS = '';
    LEGEND_VOI = strpad('time in component Environment (ms)');
    
    %Constantes (80)
    LEGEND_CONSTANTS(:,1) = strpad('R in component Environment (J_per_moleK)');
    LEGEND_CONSTANTS(:,2) = strpad('T in component Environment (kelvin)');
    LEGEND_CONSTANTS(:,3) = strpad('F in component Environment (coulomb_per_mmole)');
    LEGEND_CONSTANTS(:,4) = strpad('K_o in component Environment (mM)');
    LEGEND_CONSTANTS(:,5) = strpad('Ca_o in component Environment (mM)');
    LEGEND_CONSTANTS(:,6) = strpad('Na_o in component Environment (mM)');
    LEGEND_CONSTANTS(:,7) = strpad('wca in component cell (mV_per_uM)');
    LEGEND_CONSTANTS(:,8) = strpad('stim_offset in component cell (ms)');
    LEGEND_CONSTANTS(:,9) = strpad('stim_period in component cell (ms)');
    LEGEND_CONSTANTS(:,10) = strpad('stim_duration in component cell (ms)');
    LEGEND_CONSTANTS(:,11) = strpad('stim_amplitude in component cell (nA_per_nF)');
    LEGEND_CONSTANTS(:,12) = strpad('gna in component INa (uS_per_nF)');
    LEGEND_CONSTANTS(:,13) = strpad('gca in component ICaL (mmole_per_coulomb_cm)');
    LEGEND_CONSTANTS(:,14) = strpad('pca in component ICaL (cm_per_s)');
    LEGEND_CONSTANTS(:,15) = strpad('vth in component ICaL (mV)');
    LEGEND_CONSTANTS(:,16) = strpad('s6 in component ICaL (mV)');
    LEGEND_CONSTANTS(:,17) = strpad('vx in component ICaL (mV)');
    LEGEND_CONSTANTS(:,18) = strpad('sx in component ICaL (mV)');
    LEGEND_CONSTANTS(:,19) = strpad('vy in component ICaL (mV)');
    LEGEND_CONSTANTS(:,20) = strpad('sy in component ICaL (mV)');
    LEGEND_CONSTANTS(:,21) = strpad('vyr in component ICaL (mV)');
    LEGEND_CONSTANTS(:,22) = strpad('syr in component ICaL (mV)');
    LEGEND_CONSTANTS(:,23) = strpad('cat in component ICaL (uM)');
    LEGEND_CONSTANTS(:,24) = strpad('cpt in component ICaL (uM)');
    LEGEND_CONSTANTS(:,25) = strpad('k2 in component ICaL (per_ms)');
    LEGEND_CONSTANTS(:,26) = strpad('k1t in component ICaL (per_ms)');
    LEGEND_CONSTANTS(:,27) = strpad('k2t in component ICaL (per_ms)');
    LEGEND_CONSTANTS(:,28) = strpad('r1 in component ICaL (per_ms)');
    LEGEND_CONSTANTS(:,29) = strpad('r2 in component ICaL (per_ms)');
    LEGEND_CONSTANTS(:,30) = strpad('s1t in component ICaL (per_ms)');
    LEGEND_CONSTANTS(:,31) = strpad('tca in component ICaL (ms)');
    LEGEND_CONSTANTS(:,32) = strpad('taupo in component ICaL (ms)');
    LEGEND_CONSTANTS(:,33) = strpad('tau3 in component ICaL (ms)');
    LEGEND_CONSTANTS(:,34) = strpad('gkix in component IK1 (uS_per_nF)');
    LEGEND_CONSTANTS(:,35) = strpad('gkr in component IKr (uS_per_nF)');
    LEGEND_CONSTANTS(:,36) = strpad('gks in component IKs (uS_per_nF)');
    LEGEND_CONSTANTS(:,37) = strpad('gtos in component Ito (uS_per_nF)');
    LEGEND_CONSTANTS(:,38) = strpad('gtof in component Ito (uS_per_nF)');
    LEGEND_CONSTANTS(:,39) = strpad('gNaK in component INaK (nA_per_nF)');
    LEGEND_CONSTANTS(:,40) = strpad('xkmko in component INaK (mM)');
    LEGEND_CONSTANTS(:,41) = strpad('xkmnai in component INaK (mM)');
    LEGEND_CONSTANTS(:,42) = strpad('gNaCa in component INaCa (uM_per_ms)');
    LEGEND_CONSTANTS(:,43) = strpad('xkdna in component INaCa (uM)');
    LEGEND_CONSTANTS(:,44) = strpad('xmcao in component INaCa (mM)');
    LEGEND_CONSTANTS(:,45) = strpad('xmnao in component INaCa (mM)');
    LEGEND_CONSTANTS(:,46) = strpad('xmnai in component INaCa (mM)');
    LEGEND_CONSTANTS(:,47) = strpad('xmcai in component INaCa (mM)');
    LEGEND_CONSTANTS(:,48) = strpad('cstar in component Irel (uM)');
    LEGEND_CONSTANTS(:,49) = strpad('gryr in component Irel (per_ms)');
    LEGEND_CONSTANTS(:,50) = strpad('gbarsr in component Irel (dimensionless)');
    LEGEND_CONSTANTS(:,51) = strpad('gdyad in component Irel (mmole_per_coulomb_cm)');
    LEGEND_CONSTANTS(:,52) = strpad('ax in component Irel (per_mV)');
    LEGEND_CONSTANTS(:,53) = strpad('ay in component Irel (per_mV)');
    LEGEND_CONSTANTS(:,54) = strpad('av in component Irel (per_ms)');
    LEGEND_CONSTANTS(:,55) = strpad('taua in component Irel (ms)');
    LEGEND_CONSTANTS(:,56) = strpad('taur in component Irel (ms)');
    LEGEND_CONSTANTS(:,57) = strpad('cup in component Ileak_Iup_Ixfer (uM)');
    LEGEND_CONSTANTS(:,58) = strpad('kj in component Ileak_Iup_Ixfer (uM)');
    LEGEND_CONSTANTS(:,59) = strpad('vup in component Ileak_Iup_Ixfer (uM_per_ms)');
    LEGEND_CONSTANTS(:,60) = strpad('gleak in component Ileak_Iup_Ixfer (per_ms)');
    LEGEND_CONSTANTS(:,61) = strpad('bcal in component Ca (uM)');
    LEGEND_CONSTANTS(:,62) = strpad('xkcal in component Ca (uM)');
    LEGEND_CONSTANTS(:,63) = strpad('srmax in component Ca (uM)');
    LEGEND_CONSTANTS(:,64) = strpad('srkd in component Ca (uM)');
    LEGEND_CONSTANTS(:,65) = strpad('bmem in component Ca (uM)');
    LEGEND_CONSTANTS(:,66) = strpad('kmem in component Ca (uM)');
    LEGEND_CONSTANTS(:,67) = strpad('bsar in component Ca (uM)');
    LEGEND_CONSTANTS(:,68) = strpad('ksar in component Ca (uM)');
    LEGEND_CONSTANTS(:,69) = strpad('xkon in component Ca (per_uM_per_ms)');
    LEGEND_CONSTANTS(:,70) = strpad('xkoff in component Ca (per_ms)');
    LEGEND_CONSTANTS(:,71) = strpad('btrop in component Ca (uM)');
    LEGEND_CONSTANTS(:,72) = strpad('taud in component Ca (ms)');
    LEGEND_CONSTANTS(:,73) = strpad('taups in component Ca (ms)');
    LEGEND_CONSTANTS(:,74) = strpad('K_i in component reversal_potentials (mM)');
    LEGEND_CONSTANTS(:,75) = strpad('prNaK in component reversal_potentials (dimensionless)');
    LEGEND_CONSTANTS(:,76) = strpad('FonRT in component Environment (per_mV)');
    LEGEND_CONSTANTS(:,77) = strpad('s2t in component ICaL (per_ms)');
    LEGEND_CONSTANTS(:,78) = strpad('sigma in component INaK (dimensionless)');
    LEGEND_CONSTANTS(:,79) = strpad('bv in component Irel (uM_per_ms)');
    LEGEND_CONSTANTS(:,80) = strpad('ek in component reversal_potentials (mV)');
    
    %Algebraic variables
    LEGEND_ALGEBRAIC(:,1) = strpad('am in component INa (per_ms)');
    LEGEND_ALGEBRAIC(:,2) = strpad('ah in component INa (per_ms)');
    LEGEND_ALGEBRAIC(:,3) = strpad('aj in component INa (per_ms)');
    LEGEND_ALGEBRAIC(:,4) = strpad('past in component cell (ms)');
    LEGEND_ALGEBRAIC(:,5) = strpad('xkrv1 in component IKr (per_ms)');
    LEGEND_ALGEBRAIC(:,6) = strpad('xs1ss in component IKs (dimensionless)');
    LEGEND_ALGEBRAIC(:,7) = strpad('rt1 in component Ito (dimensionless)');
    LEGEND_ALGEBRAIC(:,8) = strpad('bm in component INa (per_ms)');
    LEGEND_ALGEBRAIC(:,9) = strpad('bh in component INa (per_ms)');
    LEGEND_ALGEBRAIC(:,10) = strpad('bj in component INa (per_ms)');
    LEGEND_ALGEBRAIC(:,11) = strpad('i_Stim in component cell (nA_per_nF)');
    LEGEND_ALGEBRAIC(:,12) = strpad('xkrv2 in component IKr (per_ms)');
    LEGEND_ALGEBRAIC(:,13) = strpad('xs2ss in component IKs (dimensionless)');
    LEGEND_ALGEBRAIC(:,14) = strpad('rt4 in component Ito (dimensionless)');
    LEGEND_ALGEBRAIC(:,15) = strpad('za in component ICaL (dimensionless)');
    LEGEND_ALGEBRAIC(:,16) = strpad('taukr in component IKr (ms)');
    LEGEND_ALGEBRAIC(:,17) = strpad('tauxs1 in component IKs (ms)');
    LEGEND_ALGEBRAIC(:,18) = strpad('xtos_inf in component Ito (dimensionless)');
    LEGEND_ALGEBRAIC(:,19) = strpad('poinf in component ICaL (dimensionless)');
    LEGEND_ALGEBRAIC(:,20) = strpad('xkrinf in component IKr (dimensionless)');
    LEGEND_ALGEBRAIC(:,21) = strpad('tauxs2 in component IKs (ms)');
    LEGEND_ALGEBRAIC(:,22) = strpad('xtof_inf in component Ito (dimensionless)');
    LEGEND_ALGEBRAIC(:,23) = strpad('txs in component Ito (ms)');
    LEGEND_ALGEBRAIC(:,24) = strpad('alpha in component ICaL (per_ms)');
    LEGEND_ALGEBRAIC(:,25) = strpad('txf in component Ito (ms)');
    LEGEND_ALGEBRAIC(:,26) = strpad('beta in component ICaL (per_ms)');
    LEGEND_ALGEBRAIC(:,27) = strpad('fca in component ICaL (dimensionless)');
    LEGEND_ALGEBRAIC(:,28) = strpad('s1 in component ICaL (per_ms)');
    LEGEND_ALGEBRAIC(:,29) = strpad('k1 in component ICaL (per_ms)');
    LEGEND_ALGEBRAIC(:,30) = strpad('s2 in component ICaL (per_ms)');
    LEGEND_ALGEBRAIC(:,31) = strpad('poi in component ICaL (dimensionless)');
    LEGEND_ALGEBRAIC(:,32) = strpad('k3 in component ICaL (per_ms)');
    LEGEND_ALGEBRAIC(:,33) = strpad('k3t in component ICaL (per_ms)');
    LEGEND_ALGEBRAIC(:,34) = strpad('Pr in component ICaL (dimensionless)');
    LEGEND_ALGEBRAIC(:,35) = strpad('recov in component ICaL (ms)');
    LEGEND_ALGEBRAIC(:,36) = strpad('tau_ca in component ICaL (ms)');
    LEGEND_ALGEBRAIC(:,37) = strpad('tauca in component ICaL (ms)');
    LEGEND_ALGEBRAIC(:,38) = strpad('tauba in component ICaL (ms)');
    LEGEND_ALGEBRAIC(:,39) = strpad('Ps in component ICaL (dimensionless)');
    LEGEND_ALGEBRAIC(:,40) = strpad('k6 in component ICaL (per_ms)');
    LEGEND_ALGEBRAIC(:,41) = strpad('k5 in component ICaL (per_ms)');
    LEGEND_ALGEBRAIC(:,42) = strpad('k6t in component ICaL (per_ms)');
    LEGEND_ALGEBRAIC(:,43) = strpad('k5t in component ICaL (per_ms)');
    LEGEND_ALGEBRAIC(:,44) = strpad('k4 in component ICaL (per_ms)');
    LEGEND_ALGEBRAIC(:,45) = strpad('k4t in component ICaL (per_ms)');
    LEGEND_ALGEBRAIC(:,46) = strpad('po in component ICaL (dimensionless)');
    LEGEND_ALGEBRAIC(:,47) = strpad('aki in component IK1 (per_ms)');
    LEGEND_ALGEBRAIC(:,48) = strpad('bki in component IK1 (per_ms)');
    LEGEND_ALGEBRAIC(:,49) = strpad('xkin in component IK1 (dimensionless)');
    LEGEND_ALGEBRAIC(:,50) = strpad('xik1 in component IK1 (nA_per_nF)');
    LEGEND_ALGEBRAIC(:,51) = strpad('rg in component IKr (dimensionless)');
    LEGEND_ALGEBRAIC(:,52) = strpad('xikr in component IKr (nA_per_nF)');
    LEGEND_ALGEBRAIC(:,53) = strpad('gksx in component IKs (dimensionless)');
    LEGEND_ALGEBRAIC(:,54) = strpad('rt2 in component Ito (dimensionless)');
    LEGEND_ALGEBRAIC(:,55) = strpad('rs_inf in component Ito (dimensionless)');
    LEGEND_ALGEBRAIC(:,56) = strpad('rt3 in component Ito (dimensionless)');
    LEGEND_ALGEBRAIC(:,57) = strpad('xitos in component Ito (nA_per_nF)');
    LEGEND_ALGEBRAIC(:,58) = strpad('rt5 in component Ito (dimensionless)');
    LEGEND_ALGEBRAIC(:,59) = strpad('xitof in component Ito (nA_per_nF)');
    LEGEND_ALGEBRAIC(:,60) = strpad('ytos_inf in component Ito (dimensionless)');
    LEGEND_ALGEBRAIC(:,61) = strpad('xito in component Ito (nA_per_nF)');
    LEGEND_ALGEBRAIC(:,62) = strpad('ytof_inf in component Ito (dimensionless)');
    LEGEND_ALGEBRAIC(:,63) = strpad('tys in component Ito (ms)');
    LEGEND_ALGEBRAIC(:,64) = strpad('fNaK in component INaK (dimensionless)');
    LEGEND_ALGEBRAIC(:,65) = strpad('tyf in component Ito (ms)');
    LEGEND_ALGEBRAIC(:,66) = strpad('xiNaK in component INaK (nA_per_nF)');
    LEGEND_ALGEBRAIC(:,67) = strpad('zw4 in component INaCa (dimensionless)');
    LEGEND_ALGEBRAIC(:,68) = strpad('aloss in component INaCa (dimensionless)');
    LEGEND_ALGEBRAIC(:,69) = strpad('yz3 in component INaCa (mM4)');
    LEGEND_ALGEBRAIC(:,70) = strpad('Qr0 in component Irel (uM_per_ms)');
    LEGEND_ALGEBRAIC(:,71) = strpad('Qr in component Irel (uM_per_ms)');
    LEGEND_ALGEBRAIC(:,72) = strpad('sparkV in component Irel (dimensionless)');
    LEGEND_ALGEBRAIC(:,73) = strpad('jup in component Ileak_Iup_Ixfer (uM_per_ms)');
    LEGEND_ALGEBRAIC(:,74) = strpad('jleak in component Ileak_Iup_Ixfer (uM_per_ms)');
    LEGEND_ALGEBRAIC(:,75) = strpad('bpxs in component Ca (dimensionless)');
    LEGEND_ALGEBRAIC(:,76) = strpad('spxs in component Ca (dimensionless)');
    LEGEND_ALGEBRAIC(:,77) = strpad('mempxs in component Ca (dimensionless)');
    LEGEND_ALGEBRAIC(:,78) = strpad('sarpxs in component Ca (dimensionless)');
    LEGEND_ALGEBRAIC(:,79) = strpad('dcsib in component Ca (dimensionless)');
    LEGEND_ALGEBRAIC(:,80) = strpad('bpxi in component Ca (dimensionless)');
    LEGEND_ALGEBRAIC(:,81) = strpad('spxi in component Ca (dimensionless)');
    LEGEND_ALGEBRAIC(:,82) = strpad('mempxi in component Ca (dimensionless)');
    LEGEND_ALGEBRAIC(:,83) = strpad('sarpxi in component Ca (dimensionless)');
    LEGEND_ALGEBRAIC(:,84) = strpad('dciib in component Ca (dimensionless)');
    LEGEND_ALGEBRAIC(:,85) = strpad('jd in component Ca (uM_per_ms)');
    LEGEND_ALGEBRAIC(:,86) = strpad('xbs in component Ca (uM_per_ms)');
    LEGEND_ALGEBRAIC(:,87) = strpad('xbi in component Ca (uM_per_ms)');
    LEGEND_ALGEBRAIC(:,88) = strpad('dCa_JSR in component Ca (uM_per_ms)');
    LEGEND_ALGEBRAIC(:,89) = strpad('csm in component Ca (mM)');
    LEGEND_ALGEBRAIC(:,90) = strpad('rxa in component ICaL (mA_per_cm2)');
    LEGEND_ALGEBRAIC(:,91) = strpad('jca in component ICaL (uM_per_ms)');
    LEGEND_ALGEBRAIC(:,92) = strpad('spark_rate in component Irel (per_ms)');
    LEGEND_ALGEBRAIC(:,93) = strpad('xirp in component Irel (uM_per_ms)');
    LEGEND_ALGEBRAIC(:,94) = strpad('xica in component ICaL (nA_per_nF)');
    LEGEND_ALGEBRAIC(:,95) = strpad('xicap in component Irel (uM_per_ms)');
    LEGEND_ALGEBRAIC(:,96) = strpad('zw3 in component INaCa (mM4)');
    LEGEND_ALGEBRAIC(:,97) = strpad('xiryr in component Irel (uM_per_ms)');
    LEGEND_ALGEBRAIC(:,98) = strpad('yz1 in component INaCa (mM4)');
    LEGEND_ALGEBRAIC(:,99) = strpad('yz2 in component INaCa (mM4)');
    LEGEND_ALGEBRAIC(:,100) = strpad('yz4 in component INaCa (mM4)');
    LEGEND_ALGEBRAIC(:,101) = strpad('zw8 in component INaCa (mM4)');
    LEGEND_ALGEBRAIC(:,102) = strpad('jNaCa in component INaCa (uM_per_ms)'); 
    LEGEND_ALGEBRAIC(:,103) = strpad('xiNaCa in component INaCa (nA_per_nF)');
    LEGEND_ALGEBRAIC(:,104) = strpad('eks in component reversal_potentials (mV)');
    LEGEND_ALGEBRAIC(:,105) = strpad('xiks in component IKs (nA_per_nF)');
    LEGEND_ALGEBRAIC(:,106) = strpad('ena in component reversal_potentials (mV)');
    LEGEND_ALGEBRAIC(:,107) = strpad('xina in component INa (nA_per_nF)');
    LEGEND_ALGEBRAIC(:,108) = strpad('Itotal in component cell (nA_per_nF)');
    
    %Todas las legend rates osea todas las derivadas
    LEGEND_RATES(:,1) = strpad('d/dt V in component cell (mV)');
    LEGEND_RATES(:,2) = strpad('d/dt xm in component INa (dimensionless)');
    LEGEND_RATES(:,3) = strpad('d/dt xh in component INa (dimensionless)');
    LEGEND_RATES(:,4) = strpad('d/dt xj in component INa (dimensionless)');
    LEGEND_RATES(:,5) = strpad('d/dt Ca_dyad in component Ca (uM)');
    LEGEND_RATES(:,6) = strpad('d/dt c1 in component ICaL (dimensionless)');
    LEGEND_RATES(:,7) = strpad('d/dt c2 in component ICaL (dimensionless)');
    LEGEND_RATES(:,8) = strpad('d/dt xi1ca in component ICaL (dimensionless)');
    LEGEND_RATES(:,9) = strpad('d/dt xi1ba in component ICaL (dimensionless)');
    LEGEND_RATES(:,10) = strpad('d/dt xi2ca in component ICaL (dimensionless)');
    LEGEND_RATES(:,11) = strpad('d/dt xi2ba in component ICaL (dimensionless)');
    LEGEND_RATES(:,12) = strpad('d/dt xr in component IKr (dimensionless)');
    LEGEND_RATES(:,13) = strpad('d/dt Ca_i in component Ca (uM)');
    LEGEND_RATES(:,14) = strpad('d/dt xs1 in component IKs (dimensionless)');
    LEGEND_RATES(:,15) = strpad('d/dt xs2 in component IKs (dimensionless)');
    LEGEND_RATES(:,16) = strpad('d/dt xtos in component Ito (dimensionless)');
    LEGEND_RATES(:,17) = strpad('d/dt ytos in component Ito (dimensionless)');
    LEGEND_RATES(:,18) = strpad('d/dt xtof in component Ito (dimensionless)');
    LEGEND_RATES(:,19) = strpad('d/dt ytof in component Ito (dimensionless)');
    LEGEND_RATES(:,20) = strpad('d/dt Na_i in component Na (mM)');
    LEGEND_RATES(:,21) = strpad('d/dt Ca_submem in component Ca (uM)');
    LEGEND_RATES(:,22) = strpad('d/dt Ca_NSR in component Ca (uM)');
    LEGEND_RATES(:,23) = strpad('d/dt Ca_JSR in component Irel (uM)');
    LEGEND_RATES(:,24) = strpad('d/dt xir in component Irel (uM_per_ms)');
    LEGEND_RATES(:,25) = strpad('d/dt tropi in component Ca (uM)');
    LEGEND_RATES(:,26) = strpad('d/dt trops in component Ca (uM)');
    
    %States variables
    LEGEND_STATES(:,1) = strpad('V in component cell (mV)');
    LEGEND_STATES(:,2) = strpad('xm in component INa (dimensionless)');
    LEGEND_STATES(:,3) = strpad('xh in component INa (dimensionless)');
    LEGEND_STATES(:,4) = strpad('xj in component INa (dimensionless)');
    LEGEND_STATES(:,5) = strpad('Ca_dyad in component Ca (uM)');
    LEGEND_STATES(:,6) = strpad('c1 in component ICaL (dimensionless)');
    LEGEND_STATES(:,7) = strpad('c2 in component ICaL (dimensionless)');
    LEGEND_STATES(:,8) = strpad('xi1ca in component ICaL (dimensionless)');
    LEGEND_STATES(:,9) = strpad('xi1ba in component ICaL (dimensionless)');
    LEGEND_STATES(:,10) = strpad('xi2ca in component ICaL (dimensionless)');
    LEGEND_STATES(:,11) = strpad('xi2ba in component ICaL (dimensionless)');
    LEGEND_STATES(:,12) = strpad('xr in component IKr (dimensionless)');
    LEGEND_STATES(:,13) = strpad('Ca_i in component Ca (uM)');
    LEGEND_STATES(:,14) = strpad('xs1 in component IKs (dimensionless)');
    LEGEND_STATES(:,15) = strpad('xs2 in component IKs (dimensionless)');
    LEGEND_STATES(:,16) = strpad('xtos in component Ito (dimensionless)');
    LEGEND_STATES(:,17) = strpad('ytos in component Ito (dimensionless)');
    LEGEND_STATES(:,18) = strpad('xtof in component Ito (dimensionless)');
    LEGEND_STATES(:,19) = strpad('ytof in component Ito (dimensionless)');
    LEGEND_STATES(:,20) = strpad('Na_i in component Na (mM)');
    LEGEND_STATES(:,21) = strpad('Ca_submem in component Ca (uM)');
    LEGEND_STATES(:,22) = strpad('Ca_NSR in component Ca (uM)');
    LEGEND_STATES(:,23) = strpad('Ca_JSR in component Irel (uM)');
    LEGEND_STATES(:,24) = strpad('xir in component Irel (uM_per_ms)');
    LEGEND_STATES(:,25) = strpad('tropi in component Ca (uM)');
    LEGEND_STATES(:,26) = strpad('trops in component Ca (uM)');
    
    %Los transponen
    LEGEND_STATES  = LEGEND_STATES';
    LEGEND_ALGEBRAIC = LEGEND_ALGEBRAIC';
    LEGEND_RATES = LEGEND_RATES';
    LEGEND_CONSTANTS = LEGEND_CONSTANTS';
end

function [STATES, CONSTANTS] = initConsts()
    VOI = 0; CONSTANTS = []; STATES = []; ALGEBRAIC = [];
    %Estados
    STATES(:,1) = -87.169816169406; %'V in component cell (mV)'
    
    STATES(:,2) = 0.001075453357; %'xm in component INa (dimensionless)'
    STATES(:,3) = 0.990691306716; %'xh in component INa (dimensionless)'
    STATES(:,4) = 0.993888937283; %'xj in component INa (dimensionless)'
    
    STATES(:,5) = 1.716573130685; %'Ca_dyad in component Ca (uM)'
    
    STATES(:,6) = 0.000018211252; %'c1 in component ICaL (dimensionless)'
    STATES(:,7) = 0.979322592773; %'c2 in component ICaL (dimensionless)'
    STATES(:,8) = 0.001208153482; %'xi1ca in component ICaL (dimensionless)'
    STATES(:,9) = 0.000033616596; %'xi1ba in component ICaL (dimensionless)'
    STATES(:,10) = 0.004173008466; %'xi2ca in component ICaL (dimensionless)'
    STATES(:,11) = 0.015242594688; %'xi2ba in component ICaL (dimensionless)'
    
    STATES(:,12) = 0.007074239331; %'xr in component IKr (dimensionless)'
    
    STATES(:,13) = 0.256752008084; %'Ca_i in component Ca (uM)'
    
    STATES(:,14) = 0.048267587131; %'xs1 in component IKs (dimensionless)'
    STATES(:,15) = 0.105468807033; %'xs2 in component IKs (dimensionless)'
    
    STATES(:,16) = 0.00364776906; %'xtos in component Ito (dimensionless)'
    STATES(:,17) = 0.174403618112; %'ytos in component Ito (dimensionless)'
    
    STATES(:,18) = 0.003643592594; %'xtof in component Ito (dimensionless)'
    STATES(:,19) = 0.993331326442; %'ytof in component Ito (dimensionless)'
    
    STATES(:,20) = 11.441712311614; %'Na_i in component Na (mM)'
    
    STATES(:,21) = 0.226941113355; %'Ca_submem in component Ca (uM)'
    STATES(:,22) = 104.450004990523; %'Ca_NSR in component Ca (uM)'
    STATES(:,23) = 97.505463697266; %'Ca_JSR in component Irel (uM)'
    STATES(:,24) = 0.006679257264; %'xir in component Irel (uM_per_ms)'
    
    STATES(:,25) = 22.171689894953; %'tropi in component Ca (uM)'
    STATES(:,26) = 19.864701949854; %'trops in component Ca (uM)'
    
    %Constantes
    CONSTANTS(:,1) = 8.314472; %Constante de los gases R
    CONSTANTS(:,2) = 308;
    CONSTANTS(:,3) = 96.4853415;
    CONSTANTS(:,4) = 5.4;
    CONSTANTS(:,5) = 1.8;
    CONSTANTS(:,6) = 136;
    CONSTANTS(:,7) = 8;
    CONSTANTS(:,8) = 0;
    CONSTANTS(:,9) = 400;
    CONSTANTS(:,10) = 3;
    CONSTANTS(:,11) = -15;
    CONSTANTS(:,12) = 12;
    CONSTANTS(:,13) = 182;
    CONSTANTS(:,14) = 0.00054;
    CONSTANTS(:,15) = 0;
    CONSTANTS(:,16) = 8;
    CONSTANTS(:,17) = -40;
    CONSTANTS(:,18) = 3;
    CONSTANTS(:,19) = -40;
    CONSTANTS(:,20) = 4;
    CONSTANTS(:,21) = -40;
    CONSTANTS(:,22) = 11.32;
    CONSTANTS(:,23) = 3;
    CONSTANTS(:,24) = 6.09365;
    CONSTANTS(:,25) = 1.03615e-4;
    CONSTANTS(:,26) = 0.00413;
    CONSTANTS(:,27) = 0.00224;
    CONSTANTS(:,28) = 0.3;
    CONSTANTS(:,29) = 3;
    CONSTANTS(:,30) = 0.00195;
    CONSTANTS(:,31) = 78.0329;
    CONSTANTS(:,32) = 1;
    CONSTANTS(:,33) = 3;
    CONSTANTS(:,34) = 0.3;
    CONSTANTS(:,35) = 0.0125;
    CONSTANTS(:,36) = 0.1386;
    CONSTANTS(:,37) = 0.04;
    CONSTANTS(:,38) = 0.11;
    CONSTANTS(:,39) = 1.5;
    CONSTANTS(:,40) = 1.5;
    CONSTANTS(:,41) = 12;
    CONSTANTS(:,42) = 0.84;
    CONSTANTS(:,43) = 0.3;
    CONSTANTS(:,44) = 1.3;
    CONSTANTS(:,45) = 87.5;
    CONSTANTS(:,46) = 12.3;
    CONSTANTS(:,47) = 0.0036;
    CONSTANTS(:,48) = 90;
    CONSTANTS(:,49) = 2.58079;
    CONSTANTS(:,50) = 26841.8;
    CONSTANTS(:,51) = 9000;
    CONSTANTS(:,52) = 0.3576;
    CONSTANTS(:,53) = 0.05;
    CONSTANTS(:,54) = 11.3;
    CONSTANTS(:,55) = 100;
    CONSTANTS(:,56) = 30;
    CONSTANTS(:,57) = 0.5;
    CONSTANTS(:,58) = 50;
    CONSTANTS(:,59) = 0.4;
    CONSTANTS(:,60) = 0.00002069;
    CONSTANTS(:,61) = 24;
    CONSTANTS(:,62) = 7;
    CONSTANTS(:,63) = 47;
    CONSTANTS(:,64) = 0.6;
    CONSTANTS(:,65) = 15;
    CONSTANTS(:,66) = 0.3;
    CONSTANTS(:,67) = 42;
    CONSTANTS(:,68) = 13;
    CONSTANTS(:,69) = 0.0327;
    CONSTANTS(:,70) = 0.0196;
    CONSTANTS(:,71) = 70;
    CONSTANTS(:,72) = 4;
    CONSTANTS(:,73) = 0.5;
    CONSTANTS(:,74) = 140;
    CONSTANTS(:,75) = 0.01833;
    CONSTANTS(:,76) = CONSTANTS(:,3)./( CONSTANTS(:,1).*CONSTANTS(:,2));
    CONSTANTS(:,77) = ( (( CONSTANTS(:,30).*CONSTANTS(:,28))./CONSTANTS(:,29)).*CONSTANTS(:,27))./CONSTANTS(:,26);
    CONSTANTS(:,78) = (exp(CONSTANTS(:,6)./67.3000) - 1.00000)./7.00000;
    CONSTANTS(:,79) =  (1.00000 - CONSTANTS(:,54)).*CONSTANTS(:,48) - 50.0000;
    CONSTANTS(:,80) =  (1.00000./CONSTANTS(:,76)).*log(CONSTANTS(:,4)./CONSTANTS(:,74));
    if (isempty(STATES)), warning('Initial values for states not set');, end
end

function [RATES, ALGEBRAIC] = computeRates(VOI, STATES, CONSTANTS)
    global algebraicVariableCount;
    statesSize = size(STATES);
    statesColumnCount = statesSize(2);
    if ( statesColumnCount == 1)
        STATES = STATES';
        ALGEBRAIC = zeros(1, algebraicVariableCount);
        utilOnes = 1;
    else
        statesRowCount = statesSize(1);
        ALGEBRAIC = zeros(statesRowCount, algebraicVariableCount);
        RATES = zeros(statesRowCount, statesColumnCount);
        utilOnes = ones(statesRowCount, 1);
    end
    RATES(:,23) = (STATES(:,22) - STATES(:,23))./CONSTANTS(:,55);
    ALGEBRAIC(:,2) = piecewise({STATES(:,1)< - 40.0000,  0.135000.*exp((80.0000+STATES(:,1))./ - 6.80000) }, 0.00000);
    ALGEBRAIC(:,9) = piecewise({STATES(:,1)< - 40.0000,  3.56000.*exp( 0.0790000.*STATES(:,1))+ 310000..*exp( 0.350000.*STATES(:,1)) }, 1.00000./( 0.130000.*(1.00000+exp((STATES(:,1)+10.6600)./ - 11.1000))));
    RATES(:,3) =  ALGEBRAIC(:,2).*(1.00000 - STATES(:,3)) -  ALGEBRAIC(:,9).*STATES(:,3);
    ALGEBRAIC(:,3) = piecewise({STATES(:,1)< - 40.0000, ( (  - 127140..*exp( 0.244400.*STATES(:,1)) -  3.47400e-05.*exp(  - 0.0439100.*STATES(:,1))).*1.00000.*(STATES(:,1)+37.7800))./(1.00000+exp( 0.311000.*(STATES(:,1)+79.2300))) }, 0.00000);
    ALGEBRAIC(:,10) = piecewise({STATES(:,1)< - 40.0000, ( 0.121200.*exp(  - 0.0105200.*STATES(:,1)))./(1.00000+exp(  - 0.137800.*(STATES(:,1)+40.1400))) }, ( 0.300000.*exp(  - 2.53500e-07.*STATES(:,1)))./(1.00000+exp(  - 0.100000.*(STATES(:,1)+32.0000))));
    RATES(:,4) =  ALGEBRAIC(:,3).*(1.00000 - STATES(:,4)) -  ALGEBRAIC(:,10).*STATES(:,4);
    ALGEBRAIC(:,1) = piecewise({abs(STATES(:,1)+47.1300)>0.00100000, ( 0.320000.*1.00000.*(STATES(:,1)+47.1300))./(1.00000 - exp(  - 0.100000.*(STATES(:,1)+47.1300))) }, 3.20000);
    ALGEBRAIC(:,8) =  0.0800000.*exp( - STATES(:,1)./11.0000);
    RATES(:,2) =  ALGEBRAIC(:,1).*(1.00000 - STATES(:,2)) -  ALGEBRAIC(:,8).*STATES(:,2);
    ALGEBRAIC(:,6) = 1.00000./(1.00000+exp( - (STATES(:,1) - 1.50000)./16.7000));
    ALGEBRAIC(:,17) = piecewise({abs(STATES(:,1)+30.0000)<0.00100000./0.0687000, 1.00000./(7.19000e-05./0.148000+0.000131000./0.0687000) }, 1.00000./(( 7.19000e-05.*(STATES(:,1)+30.0000))./(1.00000 - exp(  - 0.148000.*(STATES(:,1)+30.0000)))+( 0.000131000.*(STATES(:,1)+30.0000))./(exp( 0.0687000.*(STATES(:,1)+30.0000)) - 1.00000)));
    RATES(:,14) = (ALGEBRAIC(:,6) - STATES(:,14))./ALGEBRAIC(:,17);
    ALGEBRAIC(:,5) = piecewise({abs(STATES(:,1)+7.00000)>0.00100000, ( 0.00138000.*1.00000.*(STATES(:,1)+7.00000))./(1.00000 - exp(  - 0.123000.*(STATES(:,1)+7.00000))) }, 0.00138000./0.123000);
    ALGEBRAIC(:,12) = piecewise({abs(STATES(:,1)+10.0000)>0.00100000, ( 0.000610000.*1.00000.*(STATES(:,1)+10.0000))./(exp( 0.145000.*(STATES(:,1)+10.0000)) - 1.00000) }, 0.000610000./0.145000);
    ALGEBRAIC(:,16) = 1.00000./(ALGEBRAIC(:,5)+ALGEBRAIC(:,12));
    ALGEBRAIC(:,20) = 1.00000./(1.00000+exp( - (STATES(:,1)+50.0000)./7.50000));
    RATES(:,12) = (ALGEBRAIC(:,20) - STATES(:,12))./ALGEBRAIC(:,16);
    ALGEBRAIC(:,13) = ALGEBRAIC(:,6);
    ALGEBRAIC(:,21) =  4.00000.*ALGEBRAIC(:,17);
    RATES(:,15) = (ALGEBRAIC(:,13) - STATES(:,15))./ALGEBRAIC(:,21);
    ALGEBRAIC(:,7) =  - (STATES(:,1)+3.00000)./15.0000;
    ALGEBRAIC(:,18) = 1.00000./(1.00000+exp(ALGEBRAIC(:,7)));
    ALGEBRAIC(:,23) = 9.00000./(1.00000+exp( - ALGEBRAIC(:,7)))+0.500000;
    RATES(:,16) = (ALGEBRAIC(:,18) - STATES(:,16))./ALGEBRAIC(:,23);
    ALGEBRAIC(:,22) = ALGEBRAIC(:,18);
    ALGEBRAIC(:,14) = ( ( - STATES(:,1)./30.0000).*STATES(:,1))./30.0000;
    ALGEBRAIC(:,25) =  3.50000.*exp(ALGEBRAIC(:,14))+1.50000;
    RATES(:,18) = (ALGEBRAIC(:,22) - STATES(:,18))./ALGEBRAIC(:,25);
    ALGEBRAIC(:,19) = 1.00000./(1.00000+exp( - (STATES(:,1) - CONSTANTS(:,15))./CONSTANTS(:,16)));
    ALGEBRAIC(:,24) = ALGEBRAIC(:,19)./CONSTANTS(:,32);
    ALGEBRAIC(:,26) = (1.00000 - ALGEBRAIC(:,19))./CONSTANTS(:,32);
    ALGEBRAIC(:,27) = 1.00000./(1.00000+power(CONSTANTS(:,23)./STATES(:,5), 3.00000));
    ALGEBRAIC(:,35) = 10.0000+ 4954.00.*exp(STATES(:,1)./15.6000);
    ALGEBRAIC(:,36) = CONSTANTS(:,31)./(1.00000+power(STATES(:,5)./CONSTANTS(:,24), 4.00000))+0.100000;
    ALGEBRAIC(:,34) = 1.00000 - 1.00000./(1.00000+exp( - (STATES(:,1) - CONSTANTS(:,19))./CONSTANTS(:,20)));
    ALGEBRAIC(:,37) =  (ALGEBRAIC(:,35) - ALGEBRAIC(:,36)).*ALGEBRAIC(:,34)+ALGEBRAIC(:,36);
    ALGEBRAIC(:,39) = 1.00000./(1.00000+exp( - (STATES(:,1) - CONSTANTS(:,21))./CONSTANTS(:,22)));
    ALGEBRAIC(:,40) = ( ALGEBRAIC(:,27).*ALGEBRAIC(:,39))./ALGEBRAIC(:,37);
    ALGEBRAIC(:,41) = (1.00000 - ALGEBRAIC(:,39))./ALGEBRAIC(:,37);
    ALGEBRAIC(:,38) =  (ALGEBRAIC(:,35) - 450.000).*ALGEBRAIC(:,34)+450.000;
    ALGEBRAIC(:,42) = ALGEBRAIC(:,39)./ALGEBRAIC(:,38);
    ALGEBRAIC(:,43) = (1.00000 - ALGEBRAIC(:,39))./ALGEBRAIC(:,38);
    RATES(:,7) = ( ALGEBRAIC(:,26).*STATES(:,6)+ ALGEBRAIC(:,41).*STATES(:,10)+ ALGEBRAIC(:,43).*STATES(:,11)) -  (ALGEBRAIC(:,40)+ALGEBRAIC(:,42)+ALGEBRAIC(:,24)).*STATES(:,7);
    ALGEBRAIC(:,31) = 1.00000./(1.00000+exp( - (STATES(:,1) - CONSTANTS(:,17))./CONSTANTS(:,18)));
    ALGEBRAIC(:,32) = (1.00000 - ALGEBRAIC(:,31))./CONSTANTS(:,33);
    ALGEBRAIC(:,29) =  0.0241680.*ALGEBRAIC(:,27);
    ALGEBRAIC(:,44) = ( (( (( ALGEBRAIC(:,32).*ALGEBRAIC(:,24))./ALGEBRAIC(:,26)).*ALGEBRAIC(:,29))./CONSTANTS(:,25)).*ALGEBRAIC(:,41))./ALGEBRAIC(:,40);
    RATES(:,10) = ( ALGEBRAIC(:,32).*STATES(:,8)+ ALGEBRAIC(:,40).*STATES(:,7)) -  (ALGEBRAIC(:,41)+ALGEBRAIC(:,44)).*STATES(:,10);
    ALGEBRAIC(:,33) = ALGEBRAIC(:,32);
    ALGEBRAIC(:,45) = ( (( (( ALGEBRAIC(:,33).*ALGEBRAIC(:,24))./ALGEBRAIC(:,26)).*CONSTANTS(:,26))./CONSTANTS(:,27)).*ALGEBRAIC(:,43))./ALGEBRAIC(:,42);
    RATES(:,11) = ( ALGEBRAIC(:,33).*STATES(:,9)+ ALGEBRAIC(:,42).*STATES(:,7)) -  (ALGEBRAIC(:,43)+ALGEBRAIC(:,45)).*STATES(:,11);
    ALGEBRAIC(:,46) = (((((1.00000 - STATES(:,8)) - STATES(:,10)) - STATES(:,9)) - STATES(:,11)) - STATES(:,6)) - STATES(:,7);
    RATES(:,6) = ( ALGEBRAIC(:,24).*STATES(:,7)+ CONSTANTS(:,25).*STATES(:,8)+ CONSTANTS(:,27).*STATES(:,9)+ CONSTANTS(:,29).*ALGEBRAIC(:,46)) -  (ALGEBRAIC(:,26)+CONSTANTS(:,28)+CONSTANTS(:,26)+ALGEBRAIC(:,29)).*STATES(:,6);
    ALGEBRAIC(:,28) =  0.0182688.*ALGEBRAIC(:,27);
    ALGEBRAIC(:,30) = ( (( ALGEBRAIC(:,28).*CONSTANTS(:,28))./CONSTANTS(:,29)).*CONSTANTS(:,25))./ALGEBRAIC(:,29);
    RATES(:,8) = ( ALGEBRAIC(:,29).*STATES(:,6)+ ALGEBRAIC(:,44).*STATES(:,10)+ ALGEBRAIC(:,28).*ALGEBRAIC(:,46)) -  (ALGEBRAIC(:,32)+CONSTANTS(:,25)+ALGEBRAIC(:,30)).*STATES(:,8);
    RATES(:,9) = ( CONSTANTS(:,26).*STATES(:,6)+ ALGEBRAIC(:,45).*STATES(:,11)+ CONSTANTS(:,30).*ALGEBRAIC(:,46)) -  (ALGEBRAIC(:,33)+CONSTANTS(:,27)+CONSTANTS(:,77)).*STATES(:,9);
    ALGEBRAIC(:,54) = (STATES(:,1)+33.5000)./10.0000;
    ALGEBRAIC(:,60) = 1.00000./(1.00000+exp(ALGEBRAIC(:,54)));
    ALGEBRAIC(:,56) = (STATES(:,1)+60.0000)./10.0000;
    ALGEBRAIC(:,63) = 3000.00./(1.00000+exp(ALGEBRAIC(:,56)))+30.0000;
    RATES(:,17) = (ALGEBRAIC(:,60) - STATES(:,17))./ALGEBRAIC(:,63);
    ALGEBRAIC(:,62) = ALGEBRAIC(:,60);
    ALGEBRAIC(:,58) = (STATES(:,1)+33.5000)./10.0000;
    ALGEBRAIC(:,65) = 20.0000./(1.00000+exp(ALGEBRAIC(:,58)))+20.0000;
    RATES(:,19) = (ALGEBRAIC(:,62) - STATES(:,19))./ALGEBRAIC(:,65);
    ALGEBRAIC(:,73) = ( CONSTANTS(:,59).*STATES(:,13).*STATES(:,13))./( STATES(:,13).*STATES(:,13)+ CONSTANTS(:,57).*CONSTANTS(:,57));
    ALGEBRAIC(:,74) =  (( CONSTANTS(:,60).*STATES(:,22).*STATES(:,22))./( STATES(:,22).*STATES(:,22)+ CONSTANTS(:,58).*CONSTANTS(:,58))).*( STATES(:,22).*16.6670 - STATES(:,13));
    ALGEBRAIC(:,80) = ( CONSTANTS(:,61).*CONSTANTS(:,62))./( (CONSTANTS(:,62)+STATES(:,13)).*(CONSTANTS(:,62)+STATES(:,13)));
    ALGEBRAIC(:,81) = ( CONSTANTS(:,63).*CONSTANTS(:,64))./( (CONSTANTS(:,64)+STATES(:,13)).*(CONSTANTS(:,64)+STATES(:,13)));
    ALGEBRAIC(:,82) = ( CONSTANTS(:,65).*CONSTANTS(:,66))./( (CONSTANTS(:,66)+STATES(:,13)).*(CONSTANTS(:,66)+STATES(:,13)));
    ALGEBRAIC(:,83) = ( CONSTANTS(:,67).*CONSTANTS(:,68))./( (CONSTANTS(:,68)+STATES(:,13)).*(CONSTANTS(:,68)+STATES(:,13)));
    ALGEBRAIC(:,84) = 1.00000./(1.00000+ALGEBRAIC(:,80)+ALGEBRAIC(:,81)+ALGEBRAIC(:,82)+ALGEBRAIC(:,83));
    ALGEBRAIC(:,87) =  CONSTANTS(:,69).*STATES(:,13).*(CONSTANTS(:,71) - STATES(:,25)) -  CONSTANTS(:,70).*STATES(:,25);
    ALGEBRAIC(:,85) = (STATES(:,21) - STATES(:,13))./CONSTANTS(:,72);
    RATES(:,13) =  ALGEBRAIC(:,84).*(((ALGEBRAIC(:,85) - ALGEBRAIC(:,73))+ALGEBRAIC(:,74)) - ALGEBRAIC(:,87));
    RATES(:,25) = ALGEBRAIC(:,87);
    ALGEBRAIC(:,86) =  CONSTANTS(:,69).*STATES(:,21).*(CONSTANTS(:,71) - STATES(:,26)) -  CONSTANTS(:,70).*STATES(:,26);
    RATES(:,26) = ALGEBRAIC(:,86);
    ALGEBRAIC(:,88) = ( - STATES(:,24)+ALGEBRAIC(:,73)) - ALGEBRAIC(:,74);
    RATES(:,22) = ALGEBRAIC(:,88);
    ALGEBRAIC(:,70) = piecewise({STATES(:,23)>50.0000&STATES(:,23)<CONSTANTS(:,48), (STATES(:,23) - 50.0000)./1.00000 , STATES(:,23)>=CONSTANTS(:,48),  CONSTANTS(:,54).*STATES(:,23)+CONSTANTS(:,79) }, 0.00000);
    ALGEBRAIC(:,71) = ( STATES(:,22).*ALGEBRAIC(:,70))./CONSTANTS(:,48);
    ALGEBRAIC(:,89) = STATES(:,21)./1000.00;
    ALGEBRAIC(:,15) =  STATES(:,1).*2.00000.*CONSTANTS(:,76);
    ALGEBRAIC(:,90) = piecewise({abs(ALGEBRAIC(:,15))<0.00100000, ( 4.00000.*CONSTANTS(:,14).*CONSTANTS(:,3).*CONSTANTS(:,76).*( ALGEBRAIC(:,89).*exp(ALGEBRAIC(:,15)) -  0.341000.*CONSTANTS(:,5)))./( 2.00000.*CONSTANTS(:,76)) }, ( 4.00000.*CONSTANTS(:,14).*STATES(:,1).*CONSTANTS(:,3).*CONSTANTS(:,76).*( ALGEBRAIC(:,89).*exp(ALGEBRAIC(:,15)) -  0.341000.*CONSTANTS(:,5)))./(exp(ALGEBRAIC(:,15)) - 1.00000));
    ALGEBRAIC(:,72) = exp(  - CONSTANTS(:,53).*(STATES(:,1)+30.0000))./(1.00000+exp(  - CONSTANTS(:,53).*(STATES(:,1)+30.0000)));
    ALGEBRAIC(:,92) =  (CONSTANTS(:,49)./1.00000).*ALGEBRAIC(:,46).*abs(ALGEBRAIC(:,90)).*ALGEBRAIC(:,72);
    RATES(:,24) =  ALGEBRAIC(:,92).*ALGEBRAIC(:,71) - ( STATES(:,24).*(1.00000 - ( CONSTANTS(:,56).*ALGEBRAIC(:,88))./STATES(:,22)))./CONSTANTS(:,56);
    ALGEBRAIC(:,93) = ( (( ALGEBRAIC(:,46).*ALGEBRAIC(:,71).*abs(ALGEBRAIC(:,90)).*CONSTANTS(:,50))./1.00000).*exp(  - CONSTANTS(:,52).*(STATES(:,1)+30.0000)))./(1.00000+exp(  - CONSTANTS(:,52).*(STATES(:,1)+30.0000)));
    ALGEBRAIC(:,95) =  ALGEBRAIC(:,46).*CONSTANTS(:,51).*abs(ALGEBRAIC(:,90));
    ALGEBRAIC(:,97) = ALGEBRAIC(:,93)+ALGEBRAIC(:,95);
    RATES(:,5) = ALGEBRAIC(:,97) - (STATES(:,5) - STATES(:,21))./CONSTANTS(:,73);
    ALGEBRAIC(:,91) =  CONSTANTS(:,13).*ALGEBRAIC(:,46).*ALGEBRAIC(:,90);
    ALGEBRAIC(:,68) = 1.00000./(1.00000+power(CONSTANTS(:,43)./STATES(:,21), 3.00000));
    ALGEBRAIC(:,96) =  power(STATES(:,20), 3.00000).*CONSTANTS(:,5).*exp( STATES(:,1).*0.350000.*CONSTANTS(:,76)) -  power(CONSTANTS(:,6), 3.00000).*ALGEBRAIC(:,89).*exp( STATES(:,1).*(0.350000 - 1.00000).*CONSTANTS(:,76));
    ALGEBRAIC(:,67) = 1.00000+ 0.200000.*exp( STATES(:,1).*(0.350000 - 1.00000).*CONSTANTS(:,76));
    ALGEBRAIC(:,98) =  CONSTANTS(:,44).*power(STATES(:,20), 3.00000)+ power(CONSTANTS(:,45), 3.00000).*ALGEBRAIC(:,89);
    ALGEBRAIC(:,99) =  power(CONSTANTS(:,46), 3.00000).*CONSTANTS(:,5).*(1.00000+ALGEBRAIC(:,89)./CONSTANTS(:,47));
    ALGEBRAIC(:,69) =  CONSTANTS(:,47).*power(CONSTANTS(:,6), 3.00000).*(1.00000+power(STATES(:,20)./CONSTANTS(:,46), 3.00000));
    ALGEBRAIC(:,100) =  power(STATES(:,20), 3.00000).*CONSTANTS(:,5)+ power(CONSTANTS(:,6), 3.00000).*ALGEBRAIC(:,89);
    ALGEBRAIC(:,101) = ALGEBRAIC(:,98)+ALGEBRAIC(:,99)+ALGEBRAIC(:,69)+ALGEBRAIC(:,100);
    ALGEBRAIC(:,102) = ( CONSTANTS(:,42).*ALGEBRAIC(:,68).*ALGEBRAIC(:,96))./( ALGEBRAIC(:,67).*ALGEBRAIC(:,101));
    ALGEBRAIC(:,75) = ( CONSTANTS(:,61).*CONSTANTS(:,62))./( (CONSTANTS(:,62)+STATES(:,21)).*(CONSTANTS(:,62)+STATES(:,21)));
    ALGEBRAIC(:,76) = ( CONSTANTS(:,63).*CONSTANTS(:,64))./( (CONSTANTS(:,64)+STATES(:,21)).*(CONSTANTS(:,64)+STATES(:,21)));
    ALGEBRAIC(:,77) = ( CONSTANTS(:,65).*CONSTANTS(:,66))./( (CONSTANTS(:,66)+STATES(:,21)).*(CONSTANTS(:,66)+STATES(:,21)));
    ALGEBRAIC(:,78) = ( CONSTANTS(:,67).*CONSTANTS(:,68))./( (CONSTANTS(:,68)+STATES(:,21)).*(CONSTANTS(:,68)+STATES(:,21)));
    ALGEBRAIC(:,79) = 1.00000./(1.00000+ALGEBRAIC(:,75)+ALGEBRAIC(:,76)+ALGEBRAIC(:,77)+ALGEBRAIC(:,78));
    RATES(:,21) =  ALGEBRAIC(:,79).*( 50.0000.*(((STATES(:,24) - ALGEBRAIC(:,85)) - ALGEBRAIC(:,91))+ALGEBRAIC(:,102)) - ALGEBRAIC(:,86));
    ALGEBRAIC(:,64) = 1.00000./(1.00000+ 0.124500.*exp(  - 0.100000.*STATES(:,1).*CONSTANTS(:,76))+ 0.0365000.*CONSTANTS(:,78).*exp(  - STATES(:,1).*CONSTANTS(:,76)));
    ALGEBRAIC(:,66) = ( (( CONSTANTS(:,39).*ALGEBRAIC(:,64).*STATES(:,20))./(STATES(:,20)+CONSTANTS(:,41))).*CONSTANTS(:,4))./(CONSTANTS(:,4)+CONSTANTS(:,40));
    ALGEBRAIC(:,103) =  CONSTANTS(:,7).*ALGEBRAIC(:,102);
    ALGEBRAIC(:,106) =  (1.00000./CONSTANTS(:,76)).*log(CONSTANTS(:,6)./STATES(:,20));
    ALGEBRAIC(:,107) =  CONSTANTS(:,12).*STATES(:,3).*STATES(:,4).*STATES(:,2).*STATES(:,2).*STATES(:,2).*(STATES(:,1) - ALGEBRAIC(:,106));
    RATES(:,20) =  - (ALGEBRAIC(:,107)+ 3.00000.*ALGEBRAIC(:,66)+ 3.00000.*ALGEBRAIC(:,103))./( CONSTANTS(:,7).*1000.00);
    ALGEBRAIC(:,47) = 1.02000./(1.00000+exp( 0.238500.*((STATES(:,1) - CONSTANTS(:,80)) - 59.2150)));
    ALGEBRAIC(:,48) = ( 0.491240.*exp( 0.0803200.*((STATES(:,1) - CONSTANTS(:,80))+5.47600))+ 1.00000.*exp( 0.0617500.*((STATES(:,1) - CONSTANTS(:,80)) - 594.310)))./(1.00000+exp(  - 0.514300.*((STATES(:,1) - CONSTANTS(:,80))+4.75300)));
    ALGEBRAIC(:,49) = ALGEBRAIC(:,47)./(ALGEBRAIC(:,47)+ALGEBRAIC(:,48));
    ALGEBRAIC(:,50) =  CONSTANTS(:,34).*power((CONSTANTS(:,4)./5.40000), 1.0 ./ 2).*ALGEBRAIC(:,49).*(STATES(:,1) - CONSTANTS(:,80));
    ALGEBRAIC(:,55) = 1.00000./(1.00000+exp(ALGEBRAIC(:,54)));
    ALGEBRAIC(:,57) =  CONSTANTS(:,37).*STATES(:,16).*(STATES(:,17)+ 0.500000.*ALGEBRAIC(:,55)).*(STATES(:,1) - CONSTANTS(:,80));
    ALGEBRAIC(:,59) =  CONSTANTS(:,38).*STATES(:,18).*STATES(:,19).*(STATES(:,1) - CONSTANTS(:,80));
    ALGEBRAIC(:,61) = ALGEBRAIC(:,57)+ALGEBRAIC(:,59);
    ALGEBRAIC(:,94) =  2.00000.*CONSTANTS(:,7).*ALGEBRAIC(:,91);
    ALGEBRAIC(:,51) = 1.00000./(1.00000+exp((STATES(:,1)+33.0000)./22.4000));
    ALGEBRAIC(:,52) =  CONSTANTS(:,35).*power((CONSTANTS(:,4)./5.40000), 1.0 ./ 2).*STATES(:,12).*ALGEBRAIC(:,51).*(STATES(:,1) - CONSTANTS(:,80));
    ALGEBRAIC(:,104) =  (1.00000./CONSTANTS(:,76)).*log((CONSTANTS(:,4)+ CONSTANTS(:,75).*CONSTANTS(:,6))./(CONSTANTS(:,74)+ CONSTANTS(:,75).*STATES(:,20)));
    ALGEBRAIC(:,53) = 1.00000+0.800000./(1.00000+power(0.500000./STATES(:,13), 3.00000));
    ALGEBRAIC(:,105) =  CONSTANTS(:,36).*ALGEBRAIC(:,53).*STATES(:,14).*STATES(:,15).*(STATES(:,1) - ALGEBRAIC(:,104));
    ALGEBRAIC(:,4) =  floor(VOI./CONSTANTS(:,9)).*CONSTANTS(:,9);
    ALGEBRAIC(:,11) = piecewise({VOI - ALGEBRAIC(:,4)>=CONSTANTS(:,8)&VOI - ALGEBRAIC(:,4)<=CONSTANTS(:,8)+CONSTANTS(:,10), CONSTANTS(:,11) }, 0.00000);
    ALGEBRAIC(:,108) =  - (ALGEBRAIC(:,107)+ALGEBRAIC(:,50)+ALGEBRAIC(:,52)+ALGEBRAIC(:,105)+ALGEBRAIC(:,61)+ALGEBRAIC(:,103)+ALGEBRAIC(:,94)+ALGEBRAIC(:,66)+ALGEBRAIC(:,11));
    RATES(:,1) = ALGEBRAIC(:,108);
   RATES = RATES';
end

% Calculate algebraic variables
function ALGEBRAIC = computeAlgebraic(ALGEBRAIC, CONSTANTS, STATES, VOI)
    statesSize = size(STATES);
    statesColumnCount = statesSize(2);
    if ( statesColumnCount == 1)
        STATES = STATES';
        utilOnes = 1;
    else
        statesRowCount = statesSize(1);
        utilOnes = ones(statesRowCount, 1);
    end
    ALGEBRAIC(:,2) = piecewise({STATES(:,1)< - 40.0000,  0.135000.*exp((80.0000+STATES(:,1))./ - 6.80000) }, 0.00000);
    ALGEBRAIC(:,9) = piecewise({STATES(:,1)< - 40.0000,  3.56000.*exp( 0.0790000.*STATES(:,1))+ 310000..*exp( 0.350000.*STATES(:,1)) }, 1.00000./( 0.130000.*(1.00000+exp((STATES(:,1)+10.6600)./ - 11.1000))));
    ALGEBRAIC(:,3) = piecewise({STATES(:,1)< - 40.0000, ( (  - 127140..*exp( 0.244400.*STATES(:,1)) -  3.47400e-05.*exp(  - 0.0439100.*STATES(:,1))).*1.00000.*(STATES(:,1)+37.7800))./(1.00000+exp( 0.311000.*(STATES(:,1)+79.2300))) }, 0.00000);
    ALGEBRAIC(:,10) = piecewise({STATES(:,1)< - 40.0000, ( 0.121200.*exp(  - 0.0105200.*STATES(:,1)))./(1.00000+exp(  - 0.137800.*(STATES(:,1)+40.1400))) }, ( 0.300000.*exp(  - 2.53500e-07.*STATES(:,1)))./(1.00000+exp(  - 0.100000.*(STATES(:,1)+32.0000))));
    ALGEBRAIC(:,1) = piecewise({abs(STATES(:,1)+47.1300)>0.00100000, ( 0.320000.*1.00000.*(STATES(:,1)+47.1300))./(1.00000 - exp(  - 0.100000.*(STATES(:,1)+47.1300))) }, 3.20000);
    ALGEBRAIC(:,8) =  0.0800000.*exp( - STATES(:,1)./11.0000);
    ALGEBRAIC(:,6) = 1.00000./(1.00000+exp( - (STATES(:,1) - 1.50000)./16.7000));
    ALGEBRAIC(:,17) = piecewise({abs(STATES(:,1)+30.0000)<0.00100000./0.0687000, 1.00000./(7.19000e-05./0.148000+0.000131000./0.0687000) }, 1.00000./(( 7.19000e-05.*(STATES(:,1)+30.0000))./(1.00000 - exp(  - 0.148000.*(STATES(:,1)+30.0000)))+( 0.000131000.*(STATES(:,1)+30.0000))./(exp( 0.0687000.*(STATES(:,1)+30.0000)) - 1.00000)));
    ALGEBRAIC(:,5) = piecewise({abs(STATES(:,1)+7.00000)>0.00100000, ( 0.00138000.*1.00000.*(STATES(:,1)+7.00000))./(1.00000 - exp(  - 0.123000.*(STATES(:,1)+7.00000))) }, 0.00138000./0.123000);
    ALGEBRAIC(:,12) = piecewise({abs(STATES(:,1)+10.0000)>0.00100000, ( 0.000610000.*1.00000.*(STATES(:,1)+10.0000))./(exp( 0.145000.*(STATES(:,1)+10.0000)) - 1.00000) }, 0.000610000./0.145000);
    ALGEBRAIC(:,16) = 1.00000./(ALGEBRAIC(:,5)+ALGEBRAIC(:,12));
    ALGEBRAIC(:,20) = 1.00000./(1.00000+exp( - (STATES(:,1)+50.0000)./7.50000));
    ALGEBRAIC(:,13) = ALGEBRAIC(:,6);
    ALGEBRAIC(:,21) =  4.00000.*ALGEBRAIC(:,17);
    ALGEBRAIC(:,7) =  - (STATES(:,1)+3.00000)./15.0000;
    ALGEBRAIC(:,18) = 1.00000./(1.00000+exp(ALGEBRAIC(:,7)));
    ALGEBRAIC(:,23) = 9.00000./(1.00000+exp( - ALGEBRAIC(:,7)))+0.500000;
    ALGEBRAIC(:,22) = ALGEBRAIC(:,18);
    ALGEBRAIC(:,14) = ( ( - STATES(:,1)./30.0000).*STATES(:,1))./30.0000;
    ALGEBRAIC(:,25) =  3.50000.*exp(ALGEBRAIC(:,14))+1.50000;
    ALGEBRAIC(:,19) = 1.00000./(1.00000+exp( - (STATES(:,1) - CONSTANTS(:,15))./CONSTANTS(:,16)));
    ALGEBRAIC(:,24) = ALGEBRAIC(:,19)./CONSTANTS(:,32);
    ALGEBRAIC(:,26) = (1.00000 - ALGEBRAIC(:,19))./CONSTANTS(:,32);
    ALGEBRAIC(:,27) = 1.00000./(1.00000+power(CONSTANTS(:,23)./STATES(:,5), 3.00000));
    ALGEBRAIC(:,35) = 10.0000+ 4954.00.*exp(STATES(:,1)./15.6000);
    ALGEBRAIC(:,36) = CONSTANTS(:,31)./(1.00000+power(STATES(:,5)./CONSTANTS(:,24), 4.00000))+0.100000;
    ALGEBRAIC(:,34) = 1.00000 - 1.00000./(1.00000+exp( - (STATES(:,1) - CONSTANTS(:,19))./CONSTANTS(:,20)));
    ALGEBRAIC(:,37) =  (ALGEBRAIC(:,35) - ALGEBRAIC(:,36)).*ALGEBRAIC(:,34)+ALGEBRAIC(:,36);
    ALGEBRAIC(:,39) = 1.00000./(1.00000+exp( - (STATES(:,1) - CONSTANTS(:,21))./CONSTANTS(:,22)));
    ALGEBRAIC(:,40) = ( ALGEBRAIC(:,27).*ALGEBRAIC(:,39))./ALGEBRAIC(:,37);
    ALGEBRAIC(:,41) = (1.00000 - ALGEBRAIC(:,39))./ALGEBRAIC(:,37);
    ALGEBRAIC(:,38) =  (ALGEBRAIC(:,35) - 450.000).*ALGEBRAIC(:,34)+450.000;
    ALGEBRAIC(:,42) = ALGEBRAIC(:,39)./ALGEBRAIC(:,38);
    ALGEBRAIC(:,43) = (1.00000 - ALGEBRAIC(:,39))./ALGEBRAIC(:,38);
    ALGEBRAIC(:,31) = 1.00000./(1.00000+exp( - (STATES(:,1) - CONSTANTS(:,17))./CONSTANTS(:,18)));
    ALGEBRAIC(:,32) = (1.00000 - ALGEBRAIC(:,31))./CONSTANTS(:,33);
    ALGEBRAIC(:,29) =  0.0241680.*ALGEBRAIC(:,27);
    ALGEBRAIC(:,44) = ( (( (( ALGEBRAIC(:,32).*ALGEBRAIC(:,24))./ALGEBRAIC(:,26)).*ALGEBRAIC(:,29))./CONSTANTS(:,25)).*ALGEBRAIC(:,41))./ALGEBRAIC(:,40);
    ALGEBRAIC(:,33) = ALGEBRAIC(:,32);
    ALGEBRAIC(:,45) = ( (( (( ALGEBRAIC(:,33).*ALGEBRAIC(:,24))./ALGEBRAIC(:,26)).*CONSTANTS(:,26))./CONSTANTS(:,27)).*ALGEBRAIC(:,43))./ALGEBRAIC(:,42);
    ALGEBRAIC(:,46) = (((((1.00000 - STATES(:,8)) - STATES(:,10)) - STATES(:,9)) - STATES(:,11)) - STATES(:,6)) - STATES(:,7);
    ALGEBRAIC(:,28) =  0.0182688.*ALGEBRAIC(:,27);
    ALGEBRAIC(:,30) = ( (( ALGEBRAIC(:,28).*CONSTANTS(:,28))./CONSTANTS(:,29)).*CONSTANTS(:,25))./ALGEBRAIC(:,29);
    ALGEBRAIC(:,54) = (STATES(:,1)+33.5000)./10.0000;
    ALGEBRAIC(:,60) = 1.00000./(1.00000+exp(ALGEBRAIC(:,54)));
    ALGEBRAIC(:,56) = (STATES(:,1)+60.0000)./10.0000;
    ALGEBRAIC(:,63) = 3000.00./(1.00000+exp(ALGEBRAIC(:,56)))+30.0000;
    ALGEBRAIC(:,62) = ALGEBRAIC(:,60);
    ALGEBRAIC(:,58) = (STATES(:,1)+33.5000)./10.0000;
    ALGEBRAIC(:,65) = 20.0000./(1.00000+exp(ALGEBRAIC(:,58)))+20.0000;
    ALGEBRAIC(:,73) = ( CONSTANTS(:,59).*STATES(:,13).*STATES(:,13))./( STATES(:,13).*STATES(:,13)+ CONSTANTS(:,57).*CONSTANTS(:,57));
    ALGEBRAIC(:,74) =  (( CONSTANTS(:,60).*STATES(:,22).*STATES(:,22))./( STATES(:,22).*STATES(:,22)+ CONSTANTS(:,58).*CONSTANTS(:,58))).*( STATES(:,22).*16.6670 - STATES(:,13));
    ALGEBRAIC(:,80) = ( CONSTANTS(:,61).*CONSTANTS(:,62))./( (CONSTANTS(:,62)+STATES(:,13)).*(CONSTANTS(:,62)+STATES(:,13)));
    ALGEBRAIC(:,81) = ( CONSTANTS(:,63).*CONSTANTS(:,64))./( (CONSTANTS(:,64)+STATES(:,13)).*(CONSTANTS(:,64)+STATES(:,13)));
    ALGEBRAIC(:,82) = ( CONSTANTS(:,65).*CONSTANTS(:,66))./( (CONSTANTS(:,66)+STATES(:,13)).*(CONSTANTS(:,66)+STATES(:,13)));
    ALGEBRAIC(:,83) = ( CONSTANTS(:,67).*CONSTANTS(:,68))./( (CONSTANTS(:,68)+STATES(:,13)).*(CONSTANTS(:,68)+STATES(:,13)));
    ALGEBRAIC(:,84) = 1.00000./(1.00000+ALGEBRAIC(:,80)+ALGEBRAIC(:,81)+ALGEBRAIC(:,82)+ALGEBRAIC(:,83));
    ALGEBRAIC(:,87) =  CONSTANTS(:,69).*STATES(:,13).*(CONSTANTS(:,71) - STATES(:,25)) -  CONSTANTS(:,70).*STATES(:,25);
    ALGEBRAIC(:,85) = (STATES(:,21) - STATES(:,13))./CONSTANTS(:,72);
    ALGEBRAIC(:,86) =  CONSTANTS(:,69).*STATES(:,21).*(CONSTANTS(:,71) - STATES(:,26)) -  CONSTANTS(:,70).*STATES(:,26);
    ALGEBRAIC(:,88) = ( - STATES(:,24)+ALGEBRAIC(:,73)) - ALGEBRAIC(:,74);
    ALGEBRAIC(:,70) = piecewise({STATES(:,23)>50.0000&STATES(:,23)<CONSTANTS(:,48), (STATES(:,23) - 50.0000)./1.00000 , STATES(:,23)>=CONSTANTS(:,48),  CONSTANTS(:,54).*STATES(:,23)+CONSTANTS(:,79) }, 0.00000);
    ALGEBRAIC(:,71) = ( STATES(:,22).*ALGEBRAIC(:,70))./CONSTANTS(:,48);
    ALGEBRAIC(:,89) = STATES(:,21)./1000.00;
    ALGEBRAIC(:,15) =  STATES(:,1).*2.00000.*CONSTANTS(:,76);
    ALGEBRAIC(:,90) = piecewise({abs(ALGEBRAIC(:,15))<0.00100000, ( 4.00000.*CONSTANTS(:,14).*CONSTANTS(:,3).*CONSTANTS(:,76).*( ALGEBRAIC(:,89).*exp(ALGEBRAIC(:,15)) -  0.341000.*CONSTANTS(:,5)))./( 2.00000.*CONSTANTS(:,76)) }, ( 4.00000.*CONSTANTS(:,14).*STATES(:,1).*CONSTANTS(:,3).*CONSTANTS(:,76).*( ALGEBRAIC(:,89).*exp(ALGEBRAIC(:,15)) -  0.341000.*CONSTANTS(:,5)))./(exp(ALGEBRAIC(:,15)) - 1.00000));
    ALGEBRAIC(:,72) = exp(  - CONSTANTS(:,53).*(STATES(:,1)+30.0000))./(1.00000+exp(  - CONSTANTS(:,53).*(STATES(:,1)+30.0000)));
    ALGEBRAIC(:,92) =  (CONSTANTS(:,49)./1.00000).*ALGEBRAIC(:,46).*abs(ALGEBRAIC(:,90)).*ALGEBRAIC(:,72);
    ALGEBRAIC(:,93) = ( (( ALGEBRAIC(:,46).*ALGEBRAIC(:,71).*abs(ALGEBRAIC(:,90)).*CONSTANTS(:,50))./1.00000).*exp(  - CONSTANTS(:,52).*(STATES(:,1)+30.0000)))./(1.00000+exp(  - CONSTANTS(:,52).*(STATES(:,1)+30.0000)));
    ALGEBRAIC(:,95) =  ALGEBRAIC(:,46).*CONSTANTS(:,51).*abs(ALGEBRAIC(:,90));
    ALGEBRAIC(:,97) = ALGEBRAIC(:,93)+ALGEBRAIC(:,95);
    ALGEBRAIC(:,91) =  CONSTANTS(:,13).*ALGEBRAIC(:,46).*ALGEBRAIC(:,90);
    ALGEBRAIC(:,68) = 1.00000./(1.00000+power(CONSTANTS(:,43)./STATES(:,21), 3.00000));
    ALGEBRAIC(:,96) =  power(STATES(:,20), 3.00000).*CONSTANTS(:,5).*exp( STATES(:,1).*0.350000.*CONSTANTS(:,76)) -  power(CONSTANTS(:,6), 3.00000).*ALGEBRAIC(:,89).*exp( STATES(:,1).*(0.350000 - 1.00000).*CONSTANTS(:,76));
    ALGEBRAIC(:,67) = 1.00000+ 0.200000.*exp( STATES(:,1).*(0.350000 - 1.00000).*CONSTANTS(:,76));
    ALGEBRAIC(:,98) =  CONSTANTS(:,44).*power(STATES(:,20), 3.00000)+ power(CONSTANTS(:,45), 3.00000).*ALGEBRAIC(:,89);
    ALGEBRAIC(:,99) =  power(CONSTANTS(:,46), 3.00000).*CONSTANTS(:,5).*(1.00000+ALGEBRAIC(:,89)./CONSTANTS(:,47));
    ALGEBRAIC(:,69) =  CONSTANTS(:,47).*power(CONSTANTS(:,6), 3.00000).*(1.00000+power(STATES(:,20)./CONSTANTS(:,46), 3.00000));
    ALGEBRAIC(:,100) =  power(STATES(:,20), 3.00000).*CONSTANTS(:,5)+ power(CONSTANTS(:,6), 3.00000).*ALGEBRAIC(:,89);
    ALGEBRAIC(:,101) = ALGEBRAIC(:,98)+ALGEBRAIC(:,99)+ALGEBRAIC(:,69)+ALGEBRAIC(:,100);
    ALGEBRAIC(:,102) = ( CONSTANTS(:,42).*ALGEBRAIC(:,68).*ALGEBRAIC(:,96))./( ALGEBRAIC(:,67).*ALGEBRAIC(:,101));
    ALGEBRAIC(:,75) = ( CONSTANTS(:,61).*CONSTANTS(:,62))./( (CONSTANTS(:,62)+STATES(:,21)).*(CONSTANTS(:,62)+STATES(:,21)));
    ALGEBRAIC(:,76) = ( CONSTANTS(:,63).*CONSTANTS(:,64))./( (CONSTANTS(:,64)+STATES(:,21)).*(CONSTANTS(:,64)+STATES(:,21)));
    ALGEBRAIC(:,77) = ( CONSTANTS(:,65).*CONSTANTS(:,66))./( (CONSTANTS(:,66)+STATES(:,21)).*(CONSTANTS(:,66)+STATES(:,21)));
    ALGEBRAIC(:,78) = ( CONSTANTS(:,67).*CONSTANTS(:,68))./( (CONSTANTS(:,68)+STATES(:,21)).*(CONSTANTS(:,68)+STATES(:,21)));
    ALGEBRAIC(:,79) = 1.00000./(1.00000+ALGEBRAIC(:,75)+ALGEBRAIC(:,76)+ALGEBRAIC(:,77)+ALGEBRAIC(:,78));
    ALGEBRAIC(:,64) = 1.00000./(1.00000+ 0.124500.*exp(  - 0.100000.*STATES(:,1).*CONSTANTS(:,76))+ 0.0365000.*CONSTANTS(:,78).*exp(  - STATES(:,1).*CONSTANTS(:,76)));
    ALGEBRAIC(:,66) = ( (( CONSTANTS(:,39).*ALGEBRAIC(:,64).*STATES(:,20))./(STATES(:,20)+CONSTANTS(:,41))).*CONSTANTS(:,4))./(CONSTANTS(:,4)+CONSTANTS(:,40));
    ALGEBRAIC(:,103) =  CONSTANTS(:,7).*ALGEBRAIC(:,102);
    ALGEBRAIC(:,106) =  (1.00000./CONSTANTS(:,76)).*log(CONSTANTS(:,6)./STATES(:,20));
    ALGEBRAIC(:,107) =  CONSTANTS(:,12).*STATES(:,3).*STATES(:,4).*STATES(:,2).*STATES(:,2).*STATES(:,2).*(STATES(:,1) - ALGEBRAIC(:,106));
    ALGEBRAIC(:,47) = 1.02000./(1.00000+exp( 0.238500.*((STATES(:,1) - CONSTANTS(:,80)) - 59.2150)));
    ALGEBRAIC(:,48) = ( 0.491240.*exp( 0.0803200.*((STATES(:,1) - CONSTANTS(:,80))+5.47600))+ 1.00000.*exp( 0.0617500.*((STATES(:,1) - CONSTANTS(:,80)) - 594.310)))./(1.00000+exp(  - 0.514300.*((STATES(:,1) - CONSTANTS(:,80))+4.75300)));
    ALGEBRAIC(:,49) = ALGEBRAIC(:,47)./(ALGEBRAIC(:,47)+ALGEBRAIC(:,48));
    ALGEBRAIC(:,50) =  CONSTANTS(:,34).*power((CONSTANTS(:,4)./5.40000), 1.0 ./ 2).*ALGEBRAIC(:,49).*(STATES(:,1) - CONSTANTS(:,80));
    ALGEBRAIC(:,55) = 1.00000./(1.00000+exp(ALGEBRAIC(:,54)));
    ALGEBRAIC(:,57) =  CONSTANTS(:,37).*STATES(:,16).*(STATES(:,17)+ 0.500000.*ALGEBRAIC(:,55)).*(STATES(:,1) - CONSTANTS(:,80));
    ALGEBRAIC(:,59) =  CONSTANTS(:,38).*STATES(:,18).*STATES(:,19).*(STATES(:,1) - CONSTANTS(:,80));
    ALGEBRAIC(:,61) = ALGEBRAIC(:,57)+ALGEBRAIC(:,59);
    ALGEBRAIC(:,94) =  2.00000.*CONSTANTS(:,7).*ALGEBRAIC(:,91);
    ALGEBRAIC(:,51) = 1.00000./(1.00000+exp((STATES(:,1)+33.0000)./22.4000));
    ALGEBRAIC(:,52) =  CONSTANTS(:,35).*power((CONSTANTS(:,4)./5.40000), 1.0 ./ 2).*STATES(:,12).*ALGEBRAIC(:,51).*(STATES(:,1) - CONSTANTS(:,80));
    ALGEBRAIC(:,104) =  (1.00000./CONSTANTS(:,76)).*log((CONSTANTS(:,4)+ CONSTANTS(:,75).*CONSTANTS(:,6))./(CONSTANTS(:,74)+ CONSTANTS(:,75).*STATES(:,20)));
    ALGEBRAIC(:,53) = 1.00000+0.800000./(1.00000+power(0.500000./STATES(:,13), 3.00000));
    ALGEBRAIC(:,105) =  CONSTANTS(:,36).*ALGEBRAIC(:,53).*STATES(:,14).*STATES(:,15).*(STATES(:,1) - ALGEBRAIC(:,104));
    ALGEBRAIC(:,4) =  floor(VOI./CONSTANTS(:,9)).*CONSTANTS(:,9);
    ALGEBRAIC(:,11) = piecewise({VOI - ALGEBRAIC(:,4)>=CONSTANTS(:,8)&VOI - ALGEBRAIC(:,4)<=CONSTANTS(:,8)+CONSTANTS(:,10), CONSTANTS(:,11) }, 0.00000);
    ALGEBRAIC(:,108) =  - (ALGEBRAIC(:,107)+ALGEBRAIC(:,50)+ALGEBRAIC(:,52)+ALGEBRAIC(:,105)+ALGEBRAIC(:,61)+ALGEBRAIC(:,103)+ALGEBRAIC(:,94)+ALGEBRAIC(:,66)+ALGEBRAIC(:,11));
end

% Compute result of a piecewise function
function x = piecewise(cases, default)
    set = [0];
    for i = 1:2:length(cases)
        if (length(cases{i+1}) == 1)
            x(cases{i} & ~set,:) = cases{i+1};
        else
            x(cases{i} & ~set,:) = cases{i+1}(cases{i} & ~set);
        end
        set = set | cases{i};
        if(set), break, end
    end
    if (length(default) == 1)
        x(~set,:) = default;
    else
        x(~set,:) = default(~set);
    end
end

% Pad out or shorten strings to a set length
function strout = strpad(strin)
    req_length = 160;
    insize = size(strin,2);
    if insize > req_length
        strout = strin(1:req_length);
    else
        strout = [strin, blanks(req_length - insize)];
    end
end
