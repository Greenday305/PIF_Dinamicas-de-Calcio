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
    V = -87.169816169406; %'V in component cell (mV)'

xm = 0.001075453357; %'xm in component INa (dimensionless)'
xh = 0.990691306716; %'xh in component INa (dimensionless)'
xj = 0.993888937283; %'xj in component INa (dimensionless)'

Ca_dyad = 1.716573130685; %'Ca_dyad in component Ca (uM)'

c1 = 0.000018211252; %'c1 in component ICaL (dimensionless)'
c2 = 0.979322592773; %'c2 in component ICaL (dimensionless)'
xi1ca = 0.001208153482; %'xi1ca in component ICaL (dimensionless)'
xi1ba = 0.000033616596; %'xi1ba in component ICaL (dimensionless)'
xi2ca = 0.004173008466; %'xi2ca in component ICaL (dimensionless)'
xi2ba = 0.015242594688; %'xi2ba in component ICaL (dimensionless)'

xr = 0.007074239331; %'xr in component IKr (dimensionless)'

Ca_i = 0.256752008084; %'Ca_i in component Ca (uM)'

xs1 = 0.048267587131; %'xs1 in component IKs (dimensionless)'
xs2 = 0.105468807033; %'xs2 in component IKs (dimensionless)'

xtos = 0.00364776906; %'xtos in component Ito (dimensionless)'
ytos = 0.174403618112; %'ytos in component Ito (dimensionless)'

xtof = 0.003643592594; %'xtof in component Ito (dimensionless)'
ytof = 0.993331326442; %'ytof in component Ito (dimensionless)'

Na_i = 11.441712311614; %'Na_i in component Na (mM)'

Ca_submem = 0.226941113355; %'Ca_submem in component Ca (uM)'
Ca_NSR = 104.450004990523; %'Ca_NSR in component Ca (uM)'
Ca_JSR = 97.505463697266; %'Ca_JSR in component Irel (uM)'
xir = 0.006679257264; %'xir in component Irel (uM_per_ms)'

tropi = 22.171689894953; %'tropi in component Ca (uM)'
trops = 19.864701949854; %'trops in component Ca (uM)'

%Constantes
R = 8.314472; %Constante de los gases R
T = 308;
F = 96.4853415;
K_o = 5.4;
Ca_o = 1.8;
Na_o = 136;
wca = 8;
stim_offset = 0;
stim_period = 400;
stim_duration = 3;
stim_amplitude = -15;
gna = 12;
gca = 182;
pca = 0.00054;
vth = 0;
s6 = 8;
vx = -40;
sx = 3;
vy = -40;
sy = 4;
vyr = -40;
syr = 11.32;
cat = 3;
cpt = 6.09365;
k2 = 1.03615e-4;
k1t = 0.00413;
k2t = 0.00224;
r1 = 0.3;
r2 = 3;
s1t = 0.00195;
tca = 78.0329;
taupo = 1;
tau3 = 3;
gkix = 0.3;
gkr = 0.0125;
gks = 0.1386;
gtos = 0.04;
gtof = 0.11;
gNaK = 1.5;
xkmko = 1.5;
xkmnai = 12;
gNaCa = 0.84;
xkdna = 0.3;
xmcao = 1.3;
xmnao = 87.5;
xmnai = 12.3;
xmcai = 0.0036;
cstar = 90;
gryr = 2.58079;
gbarsr = 26841.8;
gdyad = 9000;
ax = 0.3576;
ay = 0.05;
av = 11.3;
taua = 100;
taur = 30;
cup = 0.5;
kj = 50;
vup = 0.4;
gleak = 0.00002069;
bcal = 24;
xkcal = 7;
srmax = 47;
srkd = 0.6;
bmem = 15;
kmem = 0.3;
bsar = 42;
ksar = 13;
xkon = 0.0327;
xkoff = 0.0196;
btrop = 70;
taud = 4;
taups = 0.5;
K_i = 140;
prNaK = 0.01833;
FonRT = F./( R.*T);
s2t = ( (( s1t.*r1)./r2).*k2t)./k1t;
sigma = (exp(Na_o./67.3000) - 1.00000)./7.00000;
bv =  (1.00000 - av).*cstar - 50.0000;
ek =  (1.00000./FonRT).*log(K_o./K_i);
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

d/dt Ca_JSR = (Ca_NSR - Ca_JSR)./taua;

%%% Fast sodium current INa %%%
ah = piecewise({V< - 40.0000,  0.135000.*exp((80.0000+V)./ - 6.80000) }, 0.00000);
bh = piecewise({V< - 40.0000,  3.56000.*exp( 0.0790000.*V)+ 310000..*exp( 0.350000.*V) }, 1.00000./( 0.130000.*(1.00000+exp((V+10.6600)./ - 11.1000))));
d/dt xh =  ah.*(1.00000 - xh) -  bh.*xh;
aj = piecewise({V< - 40.0000, ( (  - 127140..*exp( 0.244400.*V) -  3.47400e-05.*exp(  - 0.0439100.*V)).*1.00000.*(V+37.7800))./(1.00000+exp( 0.311000.*(V+79.2300))) }, 0.00000);
bj = piecewise({V< - 40.0000, ( 0.121200.*exp(  - 0.0105200.*V))./(1.00000+exp(  - 0.137800.*(V+40.1400))) }, ( 0.300000.*exp(  - 2.53500e-07.*V))./(1.00000+exp(  - 0.100000.*(V+32.0000))));
d/dt xj =  aj.*(1.00000 - xj) -  bj.*xj;
am = piecewise({abs(V+47.1300)>0.00100000, ( 0.320000.*1.00000.*(V+47.1300))./(1.00000 - exp(  - 0.100000.*(V+47.1300))) }, 3.20000);
bm =  0.0800000.*exp( - V./11.0000);
d/dt xm =  am.*(1.00000 - xm) -  bm.*xm;
%%%%%%%%%%%%%%%

%%% The slow component of the delayed rectifier K1 current  Iks %%%
xs1ss = 1.00000./(1.00000+exp( - (V - 1.50000)./16.7000));
tauxs1 = piecewise({abs(V+30.0000)<0.00100000./0.0687000, 1.00000./(7.19000e-05./0.148000+0.000131000./0.0687000) }, 1.00000./(( 7.19000e-05.*(V+30.0000))./(1.00000 - exp(  - 0.148000.*(V+30.0000)))+( 0.000131000.*(V+30.0000))./(exp( 0.0687000.*(V+30.0000)) - 1.00000)));
d/dt xs1 = (xs1ss - xs1)./tauxs1;
%%%%%%%%%%%%%

%%% The rapid component of the delayed rectifier K+ current IKr %%%
xkrv1 = piecewise({abs(V+7.00000)>0.00100000, ( 0.00138000.*1.00000.*(V+7.00000))./(1.00000 - exp(  - 0.123000.*(V+7.00000))) }, 0.00138000./0.123000);
xkrv2 = piecewise({abs(V+10.0000)>0.00100000, ( 0.000610000.*1.00000.*(V+10.0000))./(exp( 0.145000.*(V+10.0000)) - 1.00000) }, 0.000610000./0.145000);
taukr = 1.00000./(xkrv1+xkrv2);
xkrinf = 1.00000./(1.00000+exp( - (V+50.0000)./7.50000));
d/dt xr = (xkrinf - xr)./taukr;
%%%%%%%%%%%

%%% The slow component of the delayed rectifier K1 current  Iks (Part 2) %%%
xs2ss = xs1ss;
tauxs2 =  4.00000.*tauxs1;
d/dt xs2 = (xs2ss - xs2)./tauxs2;
%%%%%%%%%%

%%% The slow component of the rapid outward K+ current (Ito,s) Parte X %%%
rt1 =  - (V+3.00000)./15.0000;
xtos_inf = 1.00000./(1.00000+exp(rt1));
txs = 9.00000./(1.00000+exp( - rt1))+0.500000;
d/dt xtos = (xtos_inf - xtos)./txs;
xtof_inf = xtos_inf;
%%%%%%%%%%%

%%% The fast component of the rapid inward K+ current (Ito,f) Parte X %%%
rt4 = ( ( - V./30.0000).*V)./30.0000;
txf =  3.50000.*exp(rt4)+1.50000;
d/dt xtof = (xtof_inf - xtof)./txf;
%%%%%%%%%%%

%%% Markovian model of the L-type Ca current %%%
poinf = 1.00000./(1.00000+exp( - (V - vth)./s6));
alpha = poinf./taupo;
beta = (1.00000 - poinf)./taupo;
fca = 1.00000./(1.00000+power(cat./Ca_dyad, 3.00000));
recov = 10.0000+ 4954.00.*exp(V./15.6000); %R(V)
tau_ca = tca./(1.00000+power(Ca_dyad./cpt, 4.00000))+0.100000;
Pr = 1.00000 - 1.00000./(1.00000+exp( - (V - vy)./sy));
tauca =  (recov - tau_ca).*Pr+tau_ca;
Ps = 1.00000./(1.00000+exp( - (V - vyr)./syr));
k6 = ( fca.*Ps)./tauca;
k5 = (1.00000 - Ps)./tauca;
tauba =  (recov - 450.000).*Pr+450.000;
k6t = Ps./tauba;
k5t = (1.00000 - Ps)./tauba;
d/dt c2 = ( beta.*c1+ k5.*xi2ca+ k5t.*xi2ba) -  (k6+k6t+alpha).*c2;
poi = 1.00000./(1.00000+exp( - (V - vx)./sx));
k3 = (1.00000 - poi)./tau3;
k1 =  0.0241680.*fca;
k4 = ( (( (( k3.*alpha)./beta).*k1)./k2).*k5)./k6;
d/dt xi2ca = ( k3.*xi1ca+ k6.*c2) -  (k5+k4).*xi2ca;
k3t = k3;
k4t = ( (( (( k3t.*alpha)./beta).*k1t)./k2t).*k5t)./k6t;
d/dt xi2ba = ( k3t.*xi1ba+ k6t.*c2) -  (k5t+k4t).*xi2ba;
po = (((((1.00000 - xi1ca) - xi2ca) - xi1ba) - xi2ba) - c1) - c2;
d/dt c1 = ( alpha.*c2+ k2.*xi1ca+ k2t.*xi1ba+ r2.*po) -  (beta+r1+k1t+k1).*c1;
s1 =  0.0182688.*fca;
s2 = ( (( s1.*r1)./r2).*k2)./k1;
d/dt xi1ca = ( k1.*c1+ k4.*xi2ca+ s1.*po) -  (k3+k2+s2).*xi1ca;
d/dt xi1ba = ( k1t.*c1+ k4t.*xi2ba+ s1t.*po) -  (k3t+k2t+s2t).*xi1ba;
%%%%%%%%%%%%%%%%%

%%% The slow component of the rapid outward K+ current (Ito,s) Parte Y %%%
rt2 = (V+33.5000)./10.0000;
ytos_inf = 1.00000./(1.00000+exp(rt2));
rt3 = (V+60.0000)./10.0000;
tys = 3000.00./(1.00000+exp(rt3))+30.0000;
d/dt ytos = (ytos_inf - ytos)./tys;
ytof_inf = ytos_inf;
%%%%%%%%%%%%

%%% The fast component of the rapid inward K+ current (Ito,f) Parte Y %%%
rt5 = (V+33.5000)./10.0000;
tyf = 20.0000./(1.00000+exp(rt5))+20.0000;
d/dt ytof = (ytof_inf - ytof)./tyf;
%%%%%%%%%%

%%% The SERCA (uptake) pump %%%
jup = ( vup.*Ca_i.*Ca_i)./( Ca_i.*Ca_i+ cup.*cup);
%%%%%%%%%

%%% The SR leak flux %%%
jleak =  (( gleak.*Ca_NSR.*Ca_NSR)./( Ca_NSR.*Ca_NSR+ kj.*kj)).*( Ca_NSR.*16.6670 - Ca_i);
%%%%%%%%%

%%% Nonlinear buffering (Beta_i) %%%
bpxi = ( bcal.*xkcal)./( (xkcal+Ca_i).*(xkcal+Ca_i));
spxi = ( srmax.*srkd)./( (srkd+Ca_i).*(srkd+Ca_i));
mempxi = ( bmem.*kmem)./( (kmem+Ca_i).*(kmem+Ca_i));
sarpxi = ( bsar.*ksar)./( (ksar+Ca_i).*(ksar+Ca_i));
dciib = 1.00000./(1.00000+bpxi+spxi+mempxi+sarpxi);
xbi =  xkon.*Ca_i.*(btrop - tropi) -  xkoff.*tropi;
jd = (Ca_submem - Ca_i)./taud;
d/dt Ca_i =  dciib.*(((jd - jup)+jleak) - xbi);
d/dt tropi = xbi;
xbs =  xkon.*Ca_submem.*(btrop - trops) -  xkoff.*trops;
d/dt trops = xbs;
%%%%%%%%%%%%%%%%%%% 

%%% Equations for Ca cycling %%%
dCa_JSR = ( - xir+jup) - jleak;
d/dt Ca_NSR = dCa_JSR;
Qr0 = piecewise({Ca_JSR>50.0000&Ca_JSR<cstar, (Ca_JSR - 50.0000)./1.00000 , Ca_JSR>=cstar,  av.*Ca_JSR+bv }, 0.00000);
Qr = ( Ca_NSR.*Qr0)./cstar;
csm = Ca_submem./1000.00;
za =  V.*2.00000.*FonRT;
rxa = piecewise({abs(za)<0.00100000, ( 4.00000.*pca.*F.*FonRT.*( csm.*exp(za) -  0.341000.*Ca_o))./( 2.00000.*FonRT) }, ( 4.00000.*pca.*V.*F.*FonRT.*( csm.*exp(za) -  0.341000.*Ca_o))./(exp(za) - 1.00000));
sparkV = exp(  - ay.*(V+30.0000))./(1.00000+exp(  - ay.*(V+30.0000)));
spark_rate =  (gryr./1.00000).*po.*abs(rxa).*sparkV;
d/dt xir =  spark_rate.*Qr - ( xir.*(1.00000 - ( taur.*dCa_JSR)./Ca_NSR))./taur;
%%%%%%%%%%%%%%%%%%%%%%

%%% Averaged Ca dynamics in the dyadic space %%% ????
xirp = ( (( po.*Qr.*abs(rxa).*gbarsr)./1.00000).*exp(  - ax.*(V+30.0000)))./(1.00000+exp(  - ax.*(V+30.0000))); %%% División entre 1??? XDD
xicap =  po.*gdyad.*abs(rxa); 
xiryr = xirp+xicap; 
d/dt Ca_dyad = xiryr - (Ca_dyad - Ca_submem)./taups;
%%%%%%%%%%%%%%%%%%%%%%

%%% The L-type Ca current flux %%%
jca =  gca.*po.*rxa;
%%%%%%%%%%%%%%%%%%%%%%%

%%% NaCa exchange flux %%%
aloss = 1.00000./(1.00000+power(xkdna./Ca_submem, 3.00000));
zw3 =  power(Na_i, 3.00000).*Ca_o.*exp( V.*0.350000.*FonRT) -  power(Na_o, 3.00000).*csm.*exp( V.*(0.350000 - 1.00000).*FonRT);
zw4 = 1.00000+ 0.200000.*exp( V.*(0.350000 - 1.00000).*FonRT);
yz1 =  xmcao.*power(Na_i, 3.00000)+ power(xmnao, 3.00000).*csm;
yz2 =  power(xmnai, 3.00000).*Ca_o.*(1.00000+csm./xmcai);
yz3 =  xmcai.*power(Na_o, 3.00000).*(1.00000+power(Na_i./xmnai, 3.00000));
yz4 =  power(Na_i, 3.00000).*Ca_o+ power(Na_o, 3.00000).*csm;
zw8 = yz1+yz2+yz3+yz4;
jNaCa = ( gNaCa.*aloss.*zw3)./( zw4.*zw8);
%%%%%%%%%%%%%%%%%%%%%%%

%%% Nonlinear buffering (Beta_s) %%%
bpxs = ( bcal.*xkcal)./( (xkcal+Ca_submem).*(xkcal+Ca_submem));
spxs = ( srmax.*srkd)./( (srkd+Ca_submem).*(srkd+Ca_submem));
mempxs = ( bmem.*kmem)./( (kmem+Ca_submem).*(kmem+Ca_submem));
sarpxs = ( bsar.*ksar)./( (ksar+Ca_submem).*(ksar+Ca_submem));
dcsib = 1.00000./(1.00000+bpxs+spxs+mempxs+sarpxs);
d/dt Ca_submem =  dcsib.*( 50.0000.*(((xir - jd) - jca)+jNaCa) - xbs); %% dcs/dt
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% The Na-K pump current (INaK) %%%
fNaK = 1.00000./(1.00000+ 0.124500.*exp(  - 0.100000.*V.*FonRT)+ 0.0365000.*sigma.*exp(  - V.*FonRT));
xiNaK = ( (( gNaK.*fNaK.*Na_i)./(Na_i+xkmnai)).*K_o)./(K_o+xkmko);
%%%%%%%%%%%%%%%%%%%%%%%%

%%% Sodium Calcium current (INaCa) %%%
xiNaCa =  wca.*jNaCa;
%%%%%%%%%%%%%%%%%

%%% The fast sodium current (INa) %%%
ena =  (1.00000./FonRT).*log(Na_o./Na_i);
xina =  gna.*xh.*xj.*xm.*xm.*xm.*(V - ena);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Na dynamics %%%
d/dt Na_i =  - (xina+ 3.00000.*xiNaK+ 3.00000.*xiNaCa)./( wca.*1000.00);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%% Inward rectifier K+ current (Ik1) %%%
aki = 1.02000./(1.00000+exp( 0.238500.*((V - ek) - 59.2150)));
bki = ( 0.491240.*exp( 0.0803200.*((V - ek)+5.47600))+ 1.00000.*exp( 0.0617500.*((V - ek) - 594.310)))./(1.00000+exp(  - 0.514300.*((V - ek)+4.75300)));
xkin = aki./(aki+bki);
xik1 =  gkix.*power((K_o./5.40000), 1.0 ./ 2).*xkin.*(V - ek);
%%%%%%%%%%%%%%%%%%%%%%%

%%% The slow component of the rapid outward K+ current (Ito,s) %%%
rs_inf = 1.00000./(1.00000+exp(rt2));
xitos =  gtos.*xtos.*(ytos+ 0.500000.*rs_inf).*(V - ek);
%%%%%%%%%%%%%%%%%%%%

%%% The fast component of the rapid inward K+ current (Ito,f) %%%
xitof =  gtof.*xtof.*ytof.*(V - ek);
%%%%%%%%%%%%%%%%%%%%%%

xito = xitos+xitof; %%% La suma de las 2 Ito

%%% Ica %%%
xica =  2.00000.*wca.*jca;
%%%%%%%%%%%%%%%%%%

%%% The rapid component of the delayed rectifier K+ current(Ikr) %%%
rg = 1.00000./(1.00000+exp((V+33.0000)./22.4000)); % R(V)
xikr =  gkr.*power((K_o./5.40000), 1.0 ./ 2).*xr.*rg.*(V - ek);
%%%%%%%%%%%%%%%%%%%%%%

%%% The slow component of the delayed rectifier K+ current (Iks) %%%
eks =  (1.00000./FonRT).*log((K_o+ prNaK.*Na_o)./(K_i+ prNaK.*Na_i));
gksx = 1.00000+0.800000./(1.00000+power(0.500000./Ca_i, 3.00000));
xiks =  gks.*gksx.*xs1.*xs2.*(V - eks);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

past =  floor(VOI./stim_period).*stim_period; %% ???
i_Stim = piecewise({VOI - past>=stim_offset&VOI - past<=stim_offset+stim_duration, stim_amplitude }, 0.00000);
Itotal =  - (xina+xik1+xikr+xiks+xito+xiNaCa+xica+xiNaK+i_Stim);
d/dt V = Itotal;
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
ah = piecewise({V< - 40.0000,  0.135000.*exp((80.0000+V)./ - 6.80000) }, 0.00000);
bh = piecewise({V< - 40.0000,  3.56000.*exp( 0.0790000.*V)+ 310000..*exp( 0.350000.*V) }, 1.00000./( 0.130000.*(1.00000+exp((V+10.6600)./ - 11.1000))));
aj = piecewise({V< - 40.0000, ( (  - 127140..*exp( 0.244400.*V) -  3.47400e-05.*exp(  - 0.0439100.*V)).*1.00000.*(V+37.7800))./(1.00000+exp( 0.311000.*(V+79.2300))) }, 0.00000);
bj = piecewise({V< - 40.0000, ( 0.121200.*exp(  - 0.0105200.*V))./(1.00000+exp(  - 0.137800.*(V+40.1400))) }, ( 0.300000.*exp(  - 2.53500e-07.*V))./(1.00000+exp(  - 0.100000.*(V+32.0000))));
am = piecewise({abs(V+47.1300)>0.00100000, ( 0.320000.*1.00000.*(V+47.1300))./(1.00000 - exp(  - 0.100000.*(V+47.1300))) }, 3.20000);
bm =  0.0800000.*exp( - V./11.0000);
xs1ss = 1.00000./(1.00000+exp( - (V - 1.50000)./16.7000));
tauxs1 = piecewise({abs(V+30.0000)<0.00100000./0.0687000, 1.00000./(7.19000e-05./0.148000+0.000131000./0.0687000) }, 1.00000./(( 7.19000e-05.*(V+30.0000))./(1.00000 - exp(  - 0.148000.*(V+30.0000)))+( 0.000131000.*(V+30.0000))./(exp( 0.0687000.*(V+30.0000)) - 1.00000)));
xkrv1 = piecewise({abs(V+7.00000)>0.00100000, ( 0.00138000.*1.00000.*(V+7.00000))./(1.00000 - exp(  - 0.123000.*(V+7.00000))) }, 0.00138000./0.123000);
xkrv2 = piecewise({abs(V+10.0000)>0.00100000, ( 0.000610000.*1.00000.*(V+10.0000))./(exp( 0.145000.*(V+10.0000)) - 1.00000) }, 0.000610000./0.145000);
taukr = 1.00000./(xkrv1+xkrv2);
xkrinf = 1.00000./(1.00000+exp( - (V+50.0000)./7.50000));
xs2ss = xs1ss;
tauxs2 =  4.00000.*tauxs1;
rt1 =  - (V+3.00000)./15.0000;
xtos_inf = 1.00000./(1.00000+exp(rt1));
txs = 9.00000./(1.00000+exp( - rt1))+0.500000;
xtof_inf = xtos_inf;
rt4 = ( ( - V./30.0000).*V)./30.0000;
txf =  3.50000.*exp(rt4)+1.50000;
poinf = 1.00000./(1.00000+exp( - (V - vth)./s6));
alpha = poinf./taupo;
beta = (1.00000 - poinf)./taupo;
fca = 1.00000./(1.00000+power(cat./Ca_dyad, 3.00000));
recov = 10.0000+ 4954.00.*exp(V./15.6000);
tau_ca = tca./(1.00000+power(Ca_dyad./cpt, 4.00000))+0.100000;
Pr = 1.00000 - 1.00000./(1.00000+exp( - (V - vy)./sy));
tauca =  (recov - tau_ca).*Pr+tau_ca;
Ps = 1.00000./(1.00000+exp( - (V - vyr)./syr));
k6 = ( fca.*Ps)./tauca;
k5 = (1.00000 - Ps)./tauca;
tauba =  (recov - 450.000).*Pr+450.000;
k6t = Ps./tauba;
k5t = (1.00000 - Ps)./tauba;
poi = 1.00000./(1.00000+exp( - (V - vx)./sx));
k3 = (1.00000 - poi)./tau3;
k1 =  0.0241680.*fca;
k4 = ( (( (( k3.*alpha)./beta).*k1)./k2).*k5)./k6;
k3t = k3;
k4t = ( (( (( k3t.*alpha)./beta).*k1t)./k2t).*k5t)./k6t;
po = (((((1.00000 - xi1ca) - xi2ca) - xi1ba) - xi2ba) - c1) - c2;
s1 =  0.0182688.*fca;
s2 = ( (( s1.*r1)./r2).*k2)./k1;
rt2 = (V+33.5000)./10.0000;
ytos_inf = 1.00000./(1.00000+exp(rt2));
rt3 = (V+60.0000)./10.0000;
tys = 3000.00./(1.00000+exp(rt3))+30.0000;
ytof_inf = ytos_inf;
rt5 = (V+33.5000)./10.0000;
tyf = 20.0000./(1.00000+exp(rt5))+20.0000;
jup = ( vup.*Ca_i.*Ca_i)./( Ca_i.*Ca_i+ cup.*cup);
jleak =  (( gleak.*Ca_NSR.*Ca_NSR)./( Ca_NSR.*Ca_NSR+ kj.*kj)).*( Ca_NSR.*16.6670 - Ca_i);
bpxi = ( bcal.*xkcal)./( (xkcal+Ca_i).*(xkcal+Ca_i));
spxi = ( srmax.*srkd)./( (srkd+Ca_i).*(srkd+Ca_i));
mempxi = ( bmem.*kmem)./( (kmem+Ca_i).*(kmem+Ca_i));
sarpxi = ( bsar.*ksar)./( (ksar+Ca_i).*(ksar+Ca_i));
dciib = 1.00000./(1.00000+bpxi+spxi+mempxi+sarpxi);
xbi =  xkon.*Ca_i.*(btrop - tropi) -  xkoff.*tropi;
jd = (Ca_submem - Ca_i)./taud;
xbs =  xkon.*Ca_submem.*(btrop - trops) -  xkoff.*trops;
dCa_JSR = ( - xir+jup) - jleak;
Qr0 = piecewise({Ca_JSR>50.0000&Ca_JSR<cstar, (Ca_JSR - 50.0000)./1.00000 , Ca_JSR>=cstar,  av.*Ca_JSR+bv }, 0.00000);
Qr = ( Ca_NSR.*Qr0)./cstar;
csm = Ca_submem./1000.00;
za =  V.*2.00000.*FonRT;
rxa = piecewise({abs(za)<0.00100000, ( 4.00000.*pca.*F.*FonRT.*( csm.*exp(za) -  0.341000.*Ca_o))./( 2.00000.*FonRT) }, ( 4.00000.*pca.*V.*F.*FonRT.*( csm.*exp(za) -  0.341000.*Ca_o))./(exp(za) - 1.00000));
sparkV = exp(  - ay.*(V+30.0000))./(1.00000+exp(  - ay.*(V+30.0000)));
spark_rate =  (gryr./1.00000).*po.*abs(rxa).*sparkV;
xirp = ( (( po.*Qr.*abs(rxa).*gbarsr)./1.00000).*exp(  - ax.*(V+30.0000)))./(1.00000+exp(  - ax.*(V+30.0000)));
xicap =  po.*gdyad.*abs(rxa);
xiryr = xirp+xicap;
jca =  gca.*po.*rxa;
aloss = 1.00000./(1.00000+power(xkdna./Ca_submem, 3.00000));
zw3 =  power(Na_i, 3.00000).*Ca_o.*exp( V.*0.350000.*FonRT) -  power(Na_o, 3.00000).*csm.*exp( V.*(0.350000 - 1.00000).*FonRT);
zw4 = 1.00000+ 0.200000.*exp( V.*(0.350000 - 1.00000).*FonRT);
yz1 =  xmcao.*power(Na_i, 3.00000)+ power(xmnao, 3.00000).*csm;
yz2 =  power(xmnai, 3.00000).*Ca_o.*(1.00000+csm./xmcai);
yz3 =  xmcai.*power(Na_o, 3.00000).*(1.00000+power(Na_i./xmnai, 3.00000));
yz4 =  power(Na_i, 3.00000).*Ca_o+ power(Na_o, 3.00000).*csm;
zw8 = yz1+yz2+yz3+yz4;
jNaCa = ( gNaCa.*aloss.*zw3)./( zw4.*zw8);
bpxs = ( bcal.*xkcal)./( (xkcal+Ca_submem).*(xkcal+Ca_submem));
spxs = ( srmax.*srkd)./( (srkd+Ca_submem).*(srkd+Ca_submem));
mempxs = ( bmem.*kmem)./( (kmem+Ca_submem).*(kmem+Ca_submem));
sarpxs = ( bsar.*ksar)./( (ksar+Ca_submem).*(ksar+Ca_submem));
dcsib = 1.00000./(1.00000+bpxs+spxs+mempxs+sarpxs);
fNaK = 1.00000./(1.00000+ 0.124500.*exp(  - 0.100000.*V.*FonRT)+ 0.0365000.*sigma.*exp(  - V.*FonRT));
xiNaK = ( (( gNaK.*fNaK.*Na_i)./(Na_i+xkmnai)).*K_o)./(K_o+xkmko);
xiNaCa =  wca.*jNaCa;
ena =  (1.00000./FonRT).*log(Na_o./Na_i);
xina =  gna.*xh.*xj.*xm.*xm.*xm.*(V - ena);
aki = 1.02000./(1.00000+exp( 0.238500.*((V - ek) - 59.2150)));
bki = ( 0.491240.*exp( 0.0803200.*((V - ek)+5.47600))+ 1.00000.*exp( 0.0617500.*((V - ek) - 594.310)))./(1.00000+exp(  - 0.514300.*((V - ek)+4.75300)));
xkin = aki./(aki+bki);
xik1 =  gkix.*power((K_o./5.40000), 1.0 ./ 2).*xkin.*(V - ek);
rs_inf = 1.00000./(1.00000+exp(rt2));
xitos =  gtos.*xtos.*(ytos+ 0.500000.*rs_inf).*(V - ek);
xitof =  gtof.*xtof.*ytof.*(V - ek);
xito = xitos+xitof;
xica =  2.00000.*wca.*jca;
rg = 1.00000./(1.00000+exp((V+33.0000)./22.4000));
xikr =  gkr.*power((K_o./5.40000), 1.0 ./ 2).*xr.*rg.*(V - ek);
eks =  (1.00000./FonRT).*log((K_o+ prNaK.*Na_o)./(K_i+ prNaK.*Na_i));
gksx = 1.00000+0.800000./(1.00000+power(0.500000./Ca_i, 3.00000));
xiks =  gks.*gksx.*xs1.*xs2.*(V - eks);
past =  floor(VOI./stim_period).*stim_period;
i_Stim = piecewise({VOI - past>=stim_offset&VOI - past<=stim_offset+stim_duration, stim_amplitude }, 0.00000);
Itotal =  - (xina+xik1+xikr+xiks+xito+xiNaCa+xica+xiNaK+i_Stim);
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