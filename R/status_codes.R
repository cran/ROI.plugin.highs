
.add_status_codes <- function(solver) {
    codes <- list(
        list(symbol = "NOTSET", id = 0, msg = "Not Set"),
        list(symbol = "LOADERROR", id = 1, msg = "Load error"),
        list(symbol = "MODELERROR", id = 2, msg = "Model error"),
        list(symbol = "PRESOLVEERROR", id = 3, msg = "Presolve error"),
        list(symbol = "SOLVEERROR", id = 4, msg = "Solve error"),
        list(symbol = "POSTSOLVEERROR", id = 5, msg = "Postsolve error"),
        list(symbol = "MODELEMPTY", id = 6, msg = "Empty"),
        list(symbol = "OPTIMAL", id = 7, msg = "Optimal"),
        list(symbol = "INFEASIBLE", id = 8, msg = "Infeasible"),
        list(symbol = "UNBOUNDEDORINFEASIBLE", id = 9, msg = "Primal infeasible or unbounded"),
        list(symbol = "UNBOUNDED", id = 10, msg = "Unbounded"),
        list(symbol = "OBJECTIVEBOUND", id = 11, msg = "Bound on objective reached"),
        list(symbol = "OBJECTIVETARGET", id = 12, msg = "Target for objective reached"),
        list(symbol = "TIMELIMIT", id = 13, msg = "Time limit reached"),
        list(symbol = "ITERATIONLIMIT", id = 14, msg = "Iteration limit reached"),
        list(symbol = "UNKNOWN", id = 15, msg = "Unknown")
    )

    for (i in seq_along(codes)) {
        status_code <- codes[[i]]
        success <- c("OPTIMAL")
        roi_code <- if (status_code[["symbol"]] %in% success) 0L else 1L
        ROI_plugin_add_status_code_to_db(solver, as.integer(status_code[["id"]]),
                                         status_code[["symbol"]], status_code[["msg"]],
                                         roi_code)
    }
    invisible(TRUE)
}
