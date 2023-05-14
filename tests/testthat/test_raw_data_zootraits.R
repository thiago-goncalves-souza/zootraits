review_data_raw <- readxl::read_xlsx("data-raw/zootraits-review/ZooTraits_review_data_may23.xlsx") |> janitor::clean_names()

# testthat::test_that("ZooTraits data: every line have data", {
#  # TO DO
#   col_names <- review_data_raw |> names()
#
#     purrr::map(col_names,
#    ~   test_missing(review_data_raw, .x)
#  )
#
# })

testthat::test_that("ZooTraits data: every line have information for 'year'", {
  test_missing(review_data_raw, year)
})

testthat::test_that("ZooTraits data: every line have information for 'DOI'", {
  test_missing(review_data_raw, doi)
})

testthat::test_that("ZooTraits data: every line have information for 'taxunit'", {
  test_missing(review_data_raw, taxunit)
})

testthat::test_that("ZooTraits data: every line have information for 'taxunit'", {
  test_missing(review_data_raw, taxon)
})





testthat::test_that("ZooTraits data: every line have information for 'ecosystem'", {
  missing_ecosystem <-  review_data_raw |>
    dplyr::mutate(sum_ecosystem = freshwater  + marine + terrestrial) |>
    dplyr::filter(sum_ecosystem == 0 | is.na(sum_ecosystem)) |>
    dplyr::select(code, reference, doi, freshwater, marine, terrestrial)

  testthat::expect_equal(nrow(missing_ecosystem), 0)
})


testthat::test_that("ZooTraits data: every line have information for 'study_scale'", {
  missing_scale <-  review_data_raw |>
    dplyr::mutate(sum_scale = local + regional + global) |>
    dplyr::filter(sum_scale == 0 | is.na(sum_scale)) |>
    dplyr::select(code, reference, doi, local, regional, global)

  testthat::expect_equal(nrow(missing_scale), 0)
})
