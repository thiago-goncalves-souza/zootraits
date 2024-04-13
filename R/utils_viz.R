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

prepare_data_for_line_graph <- function(dataset, color_var){
   if (nrow(dataset) > 0) {
    if (color_var == "trait_dimension") {
      dataset <- dataset |>
        dplyr::left_join(trait_dimension_colors, by = "trait_dimension")
    } else {
      dataset <- dataset |>
        dplyr::mutate(color = "grey")
    }
    data_prepared <- dataset |>
      dplyr::rename(line_var = {{ color_var }}) |>
      dplyr::distinct(code, line_var, color, year) |>
      dplyr::mutate(line_var = stringr::str_to_title(line_var) |>
        stringr::str_replace_all("_", " ") |>
        stringr::str_wrap(width = 15)) |>
      dplyr::count(line_var, year, color) |>
        dplyr::group_by(color) |>
        tidyr::complete(
          year,
          line_var,
          fill = list(n = 0)) |>
        dplyr::ungroup() |>
        dplyr::arrange(year) |>
        dplyr::group_by(line_var) |>
        dplyr::mutate(cumulative_sum_n = cumsum(n))

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

bar_linechart <- function(data_for_series_plot,
                         title_lab = "Number of papers published - Most frequent taxonomic groups",
                         x_lab = "Year",
                         y_lab = "Cumulative sum of papers"){
  if (nrow(data_for_series_plot) > 0) {

    data_for_series_plot |>
      echarts4r::e_chart(x = year_date) |>
      echarts4r::e_line(
        serie = cumulative_sum_n,
        legend = TRUE
      ) |>
      echarts4r::e_datazoom(
        type = "slider",
      ) |>
      echarts4r::e_grid(left = "10%", bottom = "25%", top = "20%") |>
      echarts4r::e_tooltip(trigger = "item") |>
     echart_lineplot_theme() |>
      echarts4r::e_axis_labels(
        x = x_lab, y = y_lab
      ) |>
      echarts4r::e_title(text = title_lab |>
        stringr::str_wrap(width = 60)) |>
      echarts4r::e_y_axis(
        nameLocation = "middle",
        nameGap = 40
      ) |>
      echarts4r::e_x_axis(
        nameLocation = "middle",
        nameGap = 30
      ) |>
      echarts4r::e_legend(top = "7%")
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

echart_lineplot_theme <- function(plot) {

  # colors <- viridis::viridis(10, begin = 0.1, end = 0.9)

  echarts4r::e_theme_custom(
    plot,
    '{"color":["#482576FF","#424086FF", "#375A8CFF", "#2D718EFF", "#25858EFF", "#1E9B8AFF", "#29AF7FFF", "#4EC36BFF", "#81D34DFF", "#BBDF27FF"]}'
  #  '{"color":[  ]}'
  ) |>
    echarts4r::e_toolbox_feature(feature = c("saveAsImage"))
}
