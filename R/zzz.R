make_highs_signatures <- function() {
    rbind(ROI_plugin_make_signature(objective = c("L"),
                                    constraints = c("X", "L"),
                                    types = c("C", "I", "B", "CI", "CB", "IB", "CIB"),
                                    bounds = c("X", "V"),
                                    cones = c("X"),
                                    maximum = c(TRUE, FALSE)),
          ROI_plugin_make_signature(objective = c("Q"),
                                    constraints = c("X", "L"),
                                    types = c("C"),
                                    bounds = c("X", "V"),
                                    cones = c("X"),
                                    maximum = c(TRUE, FALSE))
    )
}


.add_controls <- function(solver) {
    ROI_plugin_register_solver_control(solver, "log_to_console", "verbose")
    ROI_plugin_register_solver_control(solver, "time_limit", "max_time")

    var_names <- c("write_solution_to_file", "output_flag",
        "run_crossover", "allow_unbounded_or_infeasible",
        "use_implied_bounds_from_presolve", "lp_presolve_requires_basis_postsolve",
        "mps_parser_type_free", "simplex_initial_condition_check",
        "no_unnecessary_rebuild_refactor", "less_infeasible_DSE_check",
        "less_infeasible_DSE_choose_row", "use_original_HFactor_logic",
        "mip_detect_symmetry",
        ##
        "log_dev_level", "random_seed", "threads", "highs_debug_level",
        "highs_analysis_level", "simplex_strategy", "simplex_scale_strategy",
        "simplex_crash_strategy", "simplex_dual_edge_weight_strategy",
        "simplex_primal_edge_weight_strategy", "simplex_iteration_limit",
        "simplex_update_limit", "simplex_min_concurrency", "simplex_max_concurrency",
        "ipm_iteration_limit", "write_solution_style", "keep_n_rows",
        "cost_scale_factor", "allowed_matrix_scale_factor", "allowed_cost_scale_factor",
        "simplex_dualise_strategy", "simplex_permute_strategy",
        "max_dual_simplex_cleanup_level", "max_dual_simplex_phase1_cleanup_level",
        "simplex_price_strategy", "simplex_unscaled_solution_strategy",
        "presolve_substitution_maxfillin", "mip_max_nodes", "mip_max_stall_nodes",
        "mip_max_leaves", "mip_lp_age_limit", "mip_pool_age_limit",
        "mip_pool_soft_limit", "mip_pscost_minreliable", "mip_report_level",
        ##
        "infinite_cost", "infinite_bound", "small_matrix_value",
        "large_matrix_value", "primal_feasibility_tolerance",
        "dual_feasibility_tolerance", "ipm_optimality_tolerance",
        "objective_bound", "objective_target", "simplex_initial_condition_tolerance",
        "rebuild_refactor_solution_error_tolerance",
        "dual_steepest_edge_weight_log_error_threshold",
        "dual_simplex_cost_perturbation_multiplier",
        "primal_simplex_bound_perturbation_multiplier",
        "dual_simplex_pivot_growth_tolerance", "presolve_pivot_threshold",
        "factor_pivot_threshold", "factor_pivot_tolerance", "start_crossover_tolerance",
        "mip_feasibility_tolerance", "mip_heuristic_effort",
        ##
        "presolve", "solver", "parallel", "ranging", "solution_file", "log_file"
    )

    for (i in seq_along(var_names)) {
        ROI_plugin_register_solver_control(solver, var_names[i], "X")
    }

    invisible(TRUE)
}


.onLoad <- function(libname, pkgname) {
    solver <- "highs"
    if (!pkgname %in% ROI_registered_solvers()) {
        ## Register solver methods here.
        ## One can assign several signatures a single solver method
        ROI_plugin_register_solver_method(
            signatures = make_highs_signatures(),
            solver = solver,
            method = getFunction("solve_OP", where = getNamespace(pkgname))
        )
        .add_status_codes(solver)
        .add_controls(solver)
    }
}

