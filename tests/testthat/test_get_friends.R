context("get_friends")

test_that("get_friends returns tibble with ids", {
	skip_on_cran()

	token <- readRDS("twitter_tokens")
	f <- get_friends("kearneymw", token = token)

	expect_true(is.data.frame(f))
  expect_named(f, "ids")
  expect_gt(nrow(f), 200)
})
