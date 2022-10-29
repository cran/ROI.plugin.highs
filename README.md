
<!-- README.md is generated from README.Rmd. Please edit that file -->

# **ROI** HIGHS Interface

This repository contains an **R** interface to the **HiGHS** solver. The
[HiGHS](https://github.com/ERGO-Code/HiGHS) solver, is a
**high**-performance open-source **solver** for solving linear
programming (LP), mixed-integer programming (MIP) and quadratic
programming (QP) optimization problems.

## Installation

``` r
remotes::install_gitlab("roigrp/solver/roi.plugin.highs")
```

## Basic usage

``` r
library("ROI")
```

### LP

``` r
# Minimize
#  x_0 +  x_1 + 3
# Subject to
#                 x_1 <= 7
#  5 <=   x_0 + 2 x_1 <= 15
#  6 <= 3 x_0 + 2 x_1
#  0 <=   x_0         <= 4
#  1 <=           x_1
op <- OP(
  objective = L_objective(c(1.0, 1)),
  constraints = L_constraint(
    L = rbind(c(0, 1), c(1, 2), c(1, 2), c(3, 2)),
    dir = c("<=", ">=", "<=", ">="),
    rhs = c(7, 5, 15, 6)
  ),
  bounds = V_bound(lb = c(0, 1), ub = c(4, Inf))
)

s <- ROI_solve(op, "highs")
solution(s)
#> [1] 0.50 2.25
```

## QP

``` r
# Minimize
#  2 x_0^2 + x_1^2 + x_0 x_1 + x_1 + x_2
# Subject to
#  x_0 + x_1 = 1
#  x_0, x_1 >= 0
op <- OP(
  objective = Q_objective(rbind(c(2, .5), c(.5, 1)), c(1, 1)),
  constraints = L_constraint(
    L = rbind(c(1, 1)),
    dir = "==",
    rhs = 1
  )
)

s <- ROI_solve(op, "highs")
solution(s)
#> [1] 0.25 0.75
```

For additional information on the **HiGHS** solver see the [HiGHS
homepage](https://highs.dev/), for additional information on **ROI** see
the [ROI homepage](http://roi.r-forge.r-project.org/).
