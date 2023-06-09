testthat::test_that("fix_doi works", {
  testthat::expect_equal(
    fix_doi("doi.org/10.1016/j.ecss.2020.106726"),
    "https://doi.org/10.1016/j.ecss.2020.106726"
  )


  testthat::expect_equal(
    fix_doi("[10.1111/ecog.02701]."),
    "https://doi.org/10.1111/ecog.02701"
  )


  testthat::expect_equal(
    fix_doi("[10.1111/oik.03176]."),
    "https://doi.org/10.1111/oik.03176"
  )


  testthat::expect_equal(
    fix_doi("-"),
    NA_character_
  )

  testthat::expect_equal(
    fix_doi("NA"),
    NA_character_
  )


  testthat::expect_equal(
    fix_doi("10.1899/0887-3593(2006)025[0730:FTNONA]2.0.CO;2"),
    "https://doi.org/10.1899/0887-3593(2006)025[0730:FTNONA]2.0.CO;2"
  )

  testthat::expect_equal(
    fix_doi("doi.org/10.1016/j.ecss.2020.106726"),
    "https://doi.org/10.1016/j.ecss.2020.106726"
  )



  testthat::expect_equal(
    fix_doi("dx.doi.org/10.1016/j.jembe.2017.03.005"),
    "https://dx.doi.org/10.1016/j.jembe.2017.03.005"
  )


  testthat::expect_equal(
    fix_doi("doi: 10.1111/jeb.12486"),
    "https://doi.org/10.1111/jeb.12486"
  )

  testthat::expect_equal(
    fix_doi("hdl.handle.net/20.500.12008/24446"),
    "https://hdl.handle.net/20.500.12008/24446"
  )


  testthat::expect_equal(
    fix_doi("10.1002/ ecs2.2566/full"),
    "https://doi.org/10.1002/ecs2.2566/full"
  )
})
