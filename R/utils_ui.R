picker_input <- function(...) {
  column(width = 4,
         shinyWidgets::pickerInput(
           options = list(`actions-box` = TRUE),
           multiple = TRUE,
           ...
         ))
}


options_input <- function(col) {
  stringr::str_to_title(as.character(sort(unique(col))))
}
