prepare_data_for_treemap_echart <- function(dataset, x_var) {
  if (nrow(dataset) > 0) {
    data_prepared <- dataset |>
      dplyr::rename(tree_var = {{ x_var }}) |>
      dplyr::distinct(code, tree_var) |>
      dplyr::mutate(tree_var = stringr::str_to_title(tree_var) |>
        stringr::str_replace_all("_", " ")) |>
      tidyr::drop_na(tree_var) |>
      dplyr::filter(tree_var != "Na|NA|na") |>
      dplyr::count(tree_var) |>
      dplyr::mutate(tree_var = dplyr::if_else(n < 10, "Other", tree_var)) |>
      dplyr::arrange(n) |>
      dplyr::rename(name = tree_var, value = n) |>
      dplyr::group_by(name) |>
      dplyr::summarise(value = sum(value))

    data_prepared
  }
}

treemap_echart <- function(data_prepared, x_lab = "", y_lab = "") {
  if (nrow(data_prepared) > 0) {
    data_prepared |>
      echarts4r::e_chart(x = tree_var) |>
      echarts4r::e_treemap() |>
      echarts4r::e_tooltip() |>
      echarts4r::e_toolbox_feature(feature = c("saveAsImage")) |>
      echarts4r::e_color(color = c("#440154FF", "#3B528BFF", "#21908CFF",
                                   "#5DC863FF")
                         # viridis::viridis(n = 4)
                         )
  }
}

prepare_data_for_bar_echart <- function(dataset, x_var) {
  if (nrow(dataset) > 0) {
    data_prepared <- dataset |>
      dplyr::rename(bar_var = {{ x_var }}) |>
      dplyr::distinct(code, bar_var) |>
      dplyr::mutate(bar_var = stringr::str_to_title(bar_var) |>
        stringr::str_replace_all("_", " ")) |>
      dplyr::count(bar_var) |>
      dplyr::arrange(n)
  }
}

bar_echart <- function(data_prepared, x_lab = "", y_lab = "") {
  if (nrow(data_prepared) > 0) {
    data_prepared |>
      echarts4r::e_chart(x = bar_var) |>
      echarts4r::e_bar(
        serie = n,
        legend = FALSE
      ) |>
      echarts4r::e_flip_coords() |>
      echarts4r::e_grid(left = "20%") |>
      echarts4r::e_tooltip() |>
      echart_theme()
  }
}

# wordcloud_chart <- function(dataset, var){
#   dataset |>
#     dplyr::rename(var = {{var}}) |>
#     dplyr::distinct(code, var) |>
#     dplyr::count(var) |>
#     tidyr::drop_na() |>
#     dplyr::filter(var != "NA") |>
#     dplyr::rename(word = var, freq = n) |>
#   wordcloud2::wordcloud2()
# }

echart_theme <- function(plot) {
  echarts4r::e_theme_custom(plot, '{"color":["#01274c","#ffca06"]}') |>
    echarts4r::e_toolbox_feature(feature = c("saveAsImage"))
}
