review_map_regional <- readr::read_csv("data-raw/zootraits-review/study_scale/FunctionalTraitData_regional.csv")

review_map_local <- readr::read_csv("data-raw/zootraits-review/study_scale/FunctionalTraitData_local.csv")

review_map_global <- readr::read_csv("data-raw/zootraits-review/study_scale/FunctionalTraitData_global.csv")

countries <- giscoR::gisco_get_countries(year = "2020", spatialtype = "LB")


# local
# local_temp <- review_map_local |>
#   dplyr::mutate(lat = lat_GD |>
#                   readr::parse_number() ,
#                   lat = dplyr::case_when(lat > 90 ~ NA_integer_,
#                                          lat < -90 ~ NA_integer_,
#                                          TRUE ~ lat),
#                 lon = long_GD |>
#                   readr::parse_number(),
#                 lon = dplyr::case_when(lon > 180 ~ NA_integer_,
#                                        lon < -180 ~ NA_integer_,
#                                        TRUE ~ lon)) |>
#   dplyr::select(-lat_GD, -long_GD)
#
#
# local_temp |>
#   dplyr::filter(!is.na(lat), !is.na(lon)) |>
#   dplyr::mutate(geometry = sf::st_point(c(lat, lon)))

local <- review_map_local |>
  dplyr::select(code, where, scale)

# regional and local withot lat/long
review_map_data <-
  review_map_regional |>
  dplyr::bind_rows(local) |>
  dplyr::bind_rows(review_map_global) |>
  dplyr::mutate(id = as.character(code)) |>
  dplyr::mutate(scale_color = dplyr::case_match(
    scale,
    "regional" ~ "blue",
    "local" ~ "green",
    "global" ~ "orange"
  )) |>
  dplyr::mutate(where_fixed = dplyr::case_match(
    where,
    "United States of America" ~ "United States",
    "Czech Republic" ~ "Czechia",
    "The Bahamas" ~ "Bahamas",
    "Swaziland" ~ "Eswatini",
    "Russia" ~ "Russian Federation",
    "Republic of Serbia" ~ "Serbia",
    "Macedonia" ~ "North Macedonia",
    "Turkey" ~ "Türkiye",
    "Ivory Coast" ~ "Côte D’Ivoire",
    "Guinea Bissau" ~ "Guinea-Bissau",
    "Democratic Republic of the Congo" ~ "Democratic Republic of The Congo",
    "Republic of the Congo" ~ "Congo",
    "Sao Tome and Principe" ~ "São Tomé and Príncipe",
    .default = where
  )) |>
  dplyr::left_join(countries,
    by = c("where_fixed" = "NAME_ENGL"),
    copy = TRUE
  ) |>
  tidyr::drop_na(code) |>
  sf::st_as_sf() |>
  dplyr::select(code, id, where_fixed, scale_color, geometry, CNTR_ID)

# dplyr::left_join(review_data, by = "code", relationship =
#                    "many-to-many") |>
# dplyr::distinct(code, scale, id, scale_color, where_fixed,
#                 CNTR_ID,
#                 reference, year, doi_html, geometry)



review_map_data |>
  dplyr::filter(is.na(CNTR_ID)) |>
  dplyr::count(where_fixed, sort = TRUE) |>
  View()

#
# leaflet::leaflet(data = pol_review_map)  |>
#   leaflet::setView(lng = 0, lat = 0, zoom = 1) |>
#   leaflet::addProviderTiles(provider = leaflet::providers$OpenStreetMap) |>
#   leaflet::addAwesomeMarkers(popup = ~ id,
#                              icon = leaflet::awesomeIcons(
#                                markerColor = ~scale_color,
#                                icon = 'search',
#                                iconColor = 'white',
#                                library = 'ion'
#                              ),
#                       clusterOptions = leaflet::markerClusterOptions()
#                      )



usethis::use_data(review_map_data, overwrite = TRUE)
