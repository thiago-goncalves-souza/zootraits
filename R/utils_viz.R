bar_echart <- function(dataset, x_var) {
  dataset |>
    dplyr::rename(bar_var = {{x_var}}) |>
    dplyr::distinct(code, bar_var) |>
    dplyr::count(bar_var) |>
    dplyr::arrange(n) |>
    dplyr::mutate(bar_var = forcats::fct_lump(bar_var, w = n, prop = 0.03)) |>
    echarts4r::e_chart(x = bar_var) |>
    echarts4r::e_bar(
      serie = n,
      legend = FALSE
    ) |>
    echarts4r::e_flip_coords() |>
    echarts4r::e_grid(left = "20%")
}
