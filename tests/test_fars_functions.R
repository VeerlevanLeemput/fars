## This file contains a test for the fars package

library(testthat)

test_that("Filename is a character string", expect_that(fars::make_filename(2014), is_a("character")))

