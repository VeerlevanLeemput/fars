## This file contains a test for the fars package

source("R/fars_functions.R")
library(testthat)

test_that("Filename is a character string", expect_that(make_filename(2014), is_a("character")))

