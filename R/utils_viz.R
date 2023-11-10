prepare_data_for_treemap_echart <- function(dataset, x_var, color = "trait_dimension") {
  if (nrow(dataset) > 0) {
    if (color == "trait_dimension") {
      trait_dimension_colors_fix <- trait_dimension_colors |>
        dplyr::mutate(trait_dimension = stringr::str_replace_all(trait_dimension, "_", " "))

      dataset_colors <- dataset |>
        dplyr::left_join(trait_dimension_colors_fix, by = "trait_dimension") |>
        dplyr::mutate(
          color = dplyr::if_else(is.na(color), "gray", color)
        )

      # dataset_colors |>
      #   dplyr::filter(color == "gray") |>
      #   dplyr::count(trait_dimension)
    } else {
      dataset_colors <- dataset |>
        dplyr::mutate(color = "grey")
    }

    data_prepared <- dataset_colors |>
      dplyr::rename(tree_var = {{ x_var }}) |>
      dplyr::distinct(code, tree_var, color) |>
      dplyr::mutate(tree_var = stringr::str_to_title(tree_var) |>
        stringr::str_replace_all("_", " ")) |>
      tidyr::drop_na(tree_var) |>
      dplyr::filter(tree_var != "Na|NA|na") |>
      dplyr::count(tree_var, color) |>
      dplyr::arrange(n) |>
      dplyr::rename(name = tree_var, value = n) |>
      dplyr::group_by(name, color) |>
      dplyr::summarise(value = sum(value))

    data_prepared
  }
}

treemap_echart <- function(data_prepared,
                           tree_var = "name",
                           title_lab = "") {
  if (nrow(data_prepared) > 0) {
    data_prepared |>
      dplyr::select(name, value, color) |>
      dplyr::ungroup() |>
      echarts4r::e_chart(x = name) |>
      echarts4r::e_treemap() |>
      echarts4r::e_tooltip() |>
      echarts4r::e_toolbox_feature(feature = c("saveAsImage")) |>
      echarts4r::e_title(text = title_lab |>
        stringr::str_wrap(width = 60)) |>
      echarts4r::e_add_nested("itemStyle", color)
  }
}

prepare_data_for_bar_echart <- function(dataset, x_var) {
  if (nrow(dataset) > 0) {
    if (x_var == "trait_dimension") {
      dataset <- dataset |>
        dplyr::left_join(trait_dimension_colors, by = "trait_dimension")
    } else {
      dataset <- dataset |>
        dplyr::mutate(color = "grey")
    }
    data_prepared <- dataset |>
      dplyr::rename(bar_var = {{ x_var }}) |>
      dplyr::distinct(code, bar_var, color) |>
      dplyr::mutate(bar_var = stringr::str_to_title(bar_var) |>
        stringr::str_replace_all("_", " ") |>
        stringr::str_wrap(width = 15)) |>
      dplyr::count(bar_var, color) |>
      dplyr::arrange(n)
  }
}

bar_echart <- function(data_prepared, x_lab = "", y_lab = "",
                       title_lab = "") {
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
      echart_theme() |>
      echarts4r::e_axis_labels(
        x = x_lab, y = y_lab
      ) |>
      echarts4r::e_title(text = title_lab |>
        stringr::str_wrap(width = 60)) |>
      echarts4r::e_y_axis(
        nameLocation = "middle",
        nameGap = 90
      ) |>
      echarts4r::e_x_axis(
        nameLocation = "middle",
        nameGap = 30
      )
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
