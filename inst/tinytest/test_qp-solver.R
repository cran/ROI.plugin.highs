if (FALSE) {
    library("tinytest")
    Sys.setenv("ROI_LOAD_PLUGINS" = FALSE)
    library("ROI")
    library("ROI.plugin.highs")
}

solver <- "highs"

# Test unconstrained QP
# minimize -x_2 - 3x_3 + (1/2)(2x_1^2 - 2x_1x_3 + 0.2x_2^2 + 2x_3^2)
L <- c(0, -1, -3)
Q <- rbind(c(2, 0.0, -1), c(0, 0.2, 0), c(-1, 0.0, 2))
x <- OP(objective = Q_objective(Q = Q, L = L),
        bounds = V_bound(ld = -Inf, nobj = 3),
        maximum = FALSE)
opt <- ROI_solve(x, solver = solver)
tinytest::expect_equal(opt$objval, -5.5)


# Test constrained QP
# minimize -x_2 - 3x_3 + (1/2)(2x_1^2 - 2x_1x_3 + 0.2x_2^2 + 2x_3^2)
# subject to x_1 + x_3 <= 2; x>=0
A <- rbind(c(1, 0, 1))
x <- OP(objective = Q_objective(Q = Q, L = L),
        constraints = L_constraint(L = A, dir = "<=", rhs = 2),
        bounds = V_bound(ld = 0, nobj = 3),
        maximum = FALSE)

opt <- ROI_solve(x, solver = solver)
tinytest::expect_equal(opt$objval, -5.25)
