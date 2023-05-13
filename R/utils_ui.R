picker_input <- function(...){
  shinyWidgets::pickerInput(
    options = list(
      `actions-box` = TRUE),
    multiple = TRUE,
    ...
  )
}
