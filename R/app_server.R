#' The application server-side
#'
#' @param input,output,session Internal parameters for {shiny}.
#'     DO NOT REMOVE.
#' @import shiny
#' @noRd
app_server <- function(input, output, session) {
  mod_data_exploration_server("data_exploration_1")
  mod_about_server("about_1")
  mod_review_metadata_server("review_metadata_1")
}
