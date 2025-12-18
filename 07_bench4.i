[Mesh]
  type = GeneratedMesh
  dim = 2
  xmin = 0
  xmax = 4.0
  ymin = 0
  ymax = 0.2
  nx = 200
  ny = 10
[]

[GlobalParams]
  PorousFlowDictator = dictator
[]

[Variables]
  [pwater]
     initial_condition = 0
  []
  [temperature]
    initial_condition = 273
  []
[]

[Kernels]
  [null_pwater_box]
    type = NullKernel
    variable = pwater
   []
  [energy_dot]
    type = PorousFlowEnergyTimeDerivative
    variable = temperature 
  []
   [heat_conduction]
    type = PorousFlowHeatConduction
    variable = temperature
  []
[]

[UserObjects]
  [dictator]
    type = PorousFlowDictator
    porous_flow_vars = 'pwater temperature'
    number_fluid_phases = 1
    number_fluid_components = 0
  []
[]

[FluidProperties]
  [water]
    type = SimpleFluidProperties
    bulk_modulus = 1.5#2.2e9
    density0 = 10#1000
    viscosity = 2e-3 #1e-3
    cp = 100 #1000
  []
[]

[BCs]
  [spit_heat]
    type = DirichletBC
    variable = temperature
    boundary = left
    value = 373
  []
[]

[Materials]
  [temperature]
    type = PorousFlowTemperature
    temperature = temperature
  []
    [rock_heats]
    type = PorousFlowMatrixInternalEnergy
    specific_heat_capacity = 0
    density = 1700
  []
  [porosity_frac]
    type = PorousFlowPorosityConst
    porosity = 1e-4 #porosity 1*aperture 1e-4
  []
  [simple_fluid]
    type = PorousFlowSingleComponentFluid
    fp = water
    phase = 0
  []
  [PS]
    type = PorousFlow1PhaseFullySaturated
    porepressure = pwater
  []
  [lambda_frac]
    type = PorousFlowThermalConductivityFromPorosity
    lambda_s = '0 0 0  0 0 0  0 0 0'
    lambda_f = '1.0 0 0  0 1.0 0  0 0 0'
          []
 #lambda_frac2
 #  type = PorousFlowThermalConductivityIdeal
 #  dry_thermal_conductivity = '1.0e-4 0 0  0 1.0e-4 0  0 0 0'        []
[]

[Preconditioning]
  active = basic
  [basic]
    type = SMP
    full = true
    petsc_options = '-ksp_diagonal_scale -ksp_diagonal_scale_fix'
    petsc_options_iname = '-pc_type -sub_pc_type -sub_pc_factor_shift_type -pc_asm_overlap'
    petsc_options_value = ' asm      lu           NONZERO                   2'
  []
  [preferred_but_might_not_be_installed]
    type = SMP
    full = true
    petsc_options_iname = '-pc_type -pc_factor_mat_solver_package'
    petsc_options_value = ' lu       mumps'
  []
[]

[Executioner]
  type = Transient
  solve_type = NEWTON
  end_time = 100
 ## scheme = bdf2
 # compute_scaling_once = false
 # [TimeStepper]
 #   type = IterationAdaptiveDT
 #   #optimal_iterations = 10
 #   growth_factor = 2
    dt = 1   #[]
#  dtmax = 1e-1
#  dtmin=1e-8
  nl_rel_tol = 1e-7
  nl_abs_tol = 1e-9
  nl_forced_its = 1
 # #automatic_scaling = true 
[]

[Outputs]
[exodus_all_time]
  type = Exodus
  file_base = result_time_step
[]
[]
