bar_echart <- function(dataset, x_var, x_lab = "", y_lab = "") {
  if(nrow(dataset) > 0){
    data_prepared <- dataset |>
      dplyr::rename(bar_var = {{x_var}}) |>
      dplyr::distinct(code, bar_var) |>
      dplyr::mutate(bar_var = stringr::str_to_title(bar_var) |>
                      stringr::str_replace_all("_", " "))
    #  dplyr::mutate(bar_var_lumped = forcats::fct_lump(bar_var, prop = 0.02))

    data_prepared |>
      dplyr::count(bar_var) |>
      #  dplyr::slice_max(order_by = n, n = 10) |>
      dplyr::arrange(n) |>
      echarts4r::e_chart(x = bar_var) |>
      echarts4r::e_bar(
        serie = n,
        legend = FALSE
      ) |>
      echarts4r::e_flip_coords() |>
      echarts4r::e_grid(left = "20%") |>
      echarts4r::e_tooltip()
  }
}
