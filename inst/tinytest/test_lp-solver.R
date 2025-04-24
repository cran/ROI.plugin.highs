if (FALSE) {
    library("tinytest")
    Sys.setenv("ROI_LOAD_PLUGINS" = FALSE)
    library("ROI")
    library("ROI.plugin.highs")
}

solver <- "highs"

## LP - Example - 1
## max:  2 x_1 + 4 x_2 + 3 x_3
## s.t.
## 3 x_1  +  4 x_2  +  2 x_3  <= 60
## 2 x_1  +    x_2  +  2 x_3  <= 40
##   x_1  +  3 x_2  +  2 x_3  <= 80 
## x_1, x_2, x_3 >= 0
writeLines("## LP - Example - 1 - 1")
local({
  mat <- matrix(c(3, 4, 2,
                  2, 1, 2,
                  1, 3, 2), nrow=3, byrow=TRUE)
  x <- OP(objective = c(2, 4, 3),
          constraints = L_constraint(L = mat,
                                    dir = c("<=", "<=", "<="),
                                    rhs = c(60, 40, 80)),
          bounds = V_bound(ui = seq_len(3), ub = c(1000, Inf, 1000), nobj = 3),
          maximum = TRUE)

  opt <- ROI_solve(x, solver = solver)
  tinytest::expect_equal(opt$solution, c(0, 20/3, 50/3), tolerance = 1e-4)
  tinytest::expect_equal(opt$objval, 230 / 3, tolerance = 1e-4)
})

writeLines("## LP - Example - 1 - 2")
local({
  mat <- matrix(c(3, 4, 2,
                    2, 1, 2,
                    1, 3, 2), nrow=3, byrow=TRUE)
  x <- OP(objective = c(2, 4, 3),
          constraints = L_constraint(L = mat,
                                    dir = c("<=", "<=", "<="),
                                    rhs = c(60, 40, 80)),
          maximum = TRUE)

  opt <- ROI_solve(x, solver = solver)
  tinytest::expect_equal(opt$solution, c(0, 20/3, 50/3), tolerance = 1e-4)
  tinytest::expect_equal(opt$objval, 230 / 3, tolerance = 1e-4)
})

## Test if ROI can handle empty constraint matrix.
writeLines("## LP - Example - 2")
local({
  x <- OP(objective = c(2, 4, 3),
          constraints = L_constraint(L=matrix(0, nrow=0, ncol=3), 
                                      dir=character(), rhs=double()),
          maximum = FALSE)

  opt <- ROI_solve(x, solver = solver)
  tinytest::expect_equal(opt$solution, c(0, 0, 0), tolerance = 1e-4)
  tinytest::expect_equal(opt$objval, 0, tolerance = 1e-4)
})

## Test if ROI can handle when the constraint is equal to NULL.
writeLines("## LP - Example - 3")
local({
  x <- OP(objective = c(2, 4, 3), constraints = NULL, maximum = FALSE)

  opt <- ROI_solve(x, solver = solver)
  tinytest::expect_equal(opt$solution, c(0, 0, 0), tolerance = 1e-4)
  tinytest::expect_equal(opt$objval, 0, tolerance = 1e-4)
})


## MILP - Example - 1
## min:  3 x + 1 y + 3 z
## s.t.
##      -1 x  +    y  +   z  <=  4
##               4 y  - 3 z  <=  2
##         x  -  3 y  + 2 z  <=  3
##     x, z \in Z_+
##     y >= 0
local({
  obj <- c(3, 1, 3)
  A <- rbind(c(-1,  2,  1),
             c( 0,  4, -3),
             c( 1, -3,  2))
  b <- c(4, 2, 3)
  bounds <- V_bound(li = c(1L, 3L), ui = c(1L, 2L),
                    lb = c(-Inf, 2), ub = c(4, 100))

  x <- OP(objective = obj,
        constraints = L_constraint(L = A,
                                   dir = c("<=", "<=", "<="),
                                   rhs = b),
        types = c("I", "C", "I"),
        bounds = bounds,
        maximum = TRUE)

  control <- list()
  opt <- ROI_solve(x, solver=solver, control=control)

  tinytest::expect_equal(opt$solution , c(4, 2.5, 3), tolerance = 1e-01)
})


## MILP - Example - 2
## min:  3 x + 1 y + 3 z
## s.t.
##      -1 x  +    y  +   z  <=  4
##               4 y  - 3 z  <=  2
##         x  -  3 y  + 2 z  <=  3
##     x, z \in Z_+
##     y >= 0
local({
  obj <- c(3, 1, 3)
  A <- rbind(c(-1,  2,  1),
             c( 0,  4, -3),
             c( 1, -3,  2))
  b <- c(4, 2, 3)

  x <- OP(objective = obj,
          constraints = L_constraint(L = A,
                                     dir = c("<=", "<=", "<="),
                                     rhs = b),
        types = c("I", "C", "I"),
        maximum = TRUE)

  opt <- ROI_solve(x, solver=solver)
  
  tinytest::expect_equal(all(A %*% opt$solution <= b), TRUE)
  tinytest::expect_equal(opt$solution , c(5, 2.75, 3), tolerance = 1e-01)
})
