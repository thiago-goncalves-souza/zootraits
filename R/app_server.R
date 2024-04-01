#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  auth_google_sheets()

  mod_review_data_exploration_server("review_data_exploration_1")
  mod_about_server("about_1")
  mod_homepage_server("homepage_1")
  mod_review_metadata_server("review_metadata_1")
  mod_get_trait_server("mod_get_trait_1", prepared_gt_otn)
  mod_review_add_paper_server("review_add_paper_1")
  mod_feedtrait_add_with_file_server("feedtrait_add_with_file_1")
}
