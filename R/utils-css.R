create_theme_css <- function() {
  fresh::create_theme(
    fresh::bs4dash_yiq(
      contrasted_threshold = 100,
      text_dark = "#000000",
      text_light = "#ffffff"
    ),
    fresh::bs4dash_status(
      info = color_for_status("info"),
      secondary = color_for_status("secondary"),
      primary = color_for_status("primary"),
      success = color_for_status("success"),
      warning = color_for_status("warning"),
      danger = color_for_status("danger")
    ),
    fresh::bs4dash_color(
      lightblue = color_for_status("info"),
      gray_800 = "#495961",
      blue = color_for_status("primary"),
      green = color_for_status("success"),
      yellow = color_for_status("warning")
    )
  )
}

color_for_status <- function(status) {
  switch(status,
    info = "#0f7cbf",
    secondary = "#495961",
    primary = "#003366",
    success = "#7AD151",
    warning = "#ffcd37",
    danger = "#BF616A"
  )
}
