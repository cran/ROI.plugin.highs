

OP_transform_highs <- function(x) {
    obj <- terms(objective(x))
    bnds <- as.data.frame(bounds(x))
    vtypes <- types(x)
    for (i in which(vtypes == "B")) {
        vtypes[i] <- "I"
        bnds[[i, 1]] <- 0
        bnds[[i, 2]] <- 1
    }
    list(
        Q = if (NROW(obj$Q) > 0L) obj$Q else NULL,
        L = as.vector(obj$L),
        lower = bnds$lower,
        upper = bnds$upper,
        A = constraints(x)$L,
        lhs = ifelse(constraints(x)$dir == "<=", -Inf, constraints(x)$rhs),
        rhs = ifelse(constraints(x)$dir == ">=",  Inf, constraints(x)$rhs),
        types = vtypes,
        maximum = maximum(x)
    )
}


# attach(OP_transform_highs(x))
solve_OP <- function(x, control = list()) {
    m <- c(list(highs::highs_solve), OP_transform_highs(x), control = list(control))
    mode(m) <- "call"

    if (isTRUE(control[["dry_run"]])) {
        return(m)
    }

    msg <- eval(m)
    msg$objval <- objective(x)(msg$primal_solution)

    ROI_plugin_canonicalize_solution(solution = msg$primal_solution, optimum = msg$objective_value,
                                     status = msg$status, solver = "highs", message = msg)

}
