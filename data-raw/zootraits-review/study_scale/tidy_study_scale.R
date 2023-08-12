review_map_regional <- readr::read_csv("data-raw/zootraits-review/study_scale/FunctionalTraitData_regional.csv")

review_map_local <- readr::read_csv("data-raw/zootraits-review/study_scale/FunctionalTraitData_local.csv")

review_map_global <- readr::read_csv("data-raw/zootraits-review/study_scale/FunctionalTraitData_global.csv")

missing_wheres <- tibble::tribble(
  ~"where", ~"latitude", ~"longitude",
  "Mediterranean Sea", 34.54548658745733, 18.052644689697757,
  "Europe", 54.6440886101563, 15.191379445465172,
  "Baltic Sea", 58.713408537408405, 20.0825429377914,
  "North Atlantic", 36.903345005661095, -39.763179315323356,
  "Arctic Ocean", 65.24813987169915, -60.46312898266632,
  "Canary Islands", 28.291104049293185, -16.627242839129128,
  "Pacific Ocean", -8.783362412995317, -124.50766549637353,
  "Americas", 54.42159654342914, -103.76097778613806,
  "Global", 0, -30,
  "New World", 31.525840441817326, -90.71350373337613,
  "North America", 31.525840441817326, -90.71350373337613,
  "Atlantic Ocean", -15.085912202047036, -27.455072861650248,
  "Atlatic ocean", -15.085912202047036, -27.455072861650248,
  "Atlantic ocean", -15.085912202047036, -27.455072861650248,
  "Atlantic sea", -15.085912202047036, -27.455072861650248,
  "Barents Sea", 74.98779924272161, 37.11185851862456,
  "Indian Ocean", -33.136681760495925, 81.82651464420782,
  "Neotropical Region", 12.69734521256976, -85.47636564991078,
  "Northeast Pacific", 3.5949427197121264, -154.16147808146923,
  "Northwest Atlantic", 47.62581798133698, -126.21179071131628,
  "Red Sea", 19.976428301287637, 38.78442150184498,
  "South America", -8.713176246419867, -54.923755464159164,
  "Southern Africa", -26.082354989626143, 15.67902129343094,
  "Taiwan", 23.059786246094525, 120.7069929035721,
  "Arabian Sea", 11.91920329612618, 65.24953064153938,
  "California", 36.30639523954953, -119.66800694060443,
  "Caribbean", 14.978398886637743, -75.12483015598443,
  "Celtic Sea", 49.00017500675439, -8.028765959072798,
  "Central-Eastern Mediterranean", 33.26660826389885, 33.2022235205528,
  "Chagos", -6.36041932866884, 71.74125859593613,
  "Curacao", 12.182076091833933, -68.96253862905373,
  "Eastern English Channel", 50.07165479631966, -0.2991287133367694,
  "Holartic region", 64.25441892621745, -34.97197803190138,
  "Korea No Mans Area", 38.28549478353815, 127.2289422293421,
  "North Pacific", 31.450594881815565, -171.17441832792503,
  "North Sea", 56.48405089238342, 3.6678744352014454,
  "Northern Europe", 59.92849895318174, 3.004918242883972,
  "Saint Helena", -15.968651021149146, -5.711798392332217,
  "Southern Ocean", -68.43903797187745, -160.23743623108186,
  "Tropical Ocean Atlantic", 0.5301500988542861, -42.14885523592035,
  "Western Hemisphere", 39.29038332918302, -72.42538759245211,
  "Western Mediterranean", 39.63221321517409, 6.107815959782425
) |>
  sf::st_as_sf(coords = c("longitude", "latitude")) |>
  dplyr::rename(NAME_ENGL = where) |>
  sf::st_set_crs(value = 4326)


countries <- giscoR::gisco_get_countries(
  year = "2020",
  spatialtype = "LB",
  epsg = "4326"
) |>
  dplyr::bind_rows(missing_wheres)



missing_wheres |>
  leaflet::leaflet() |>
  leaflet::addProviderTiles(provider = leaflet::providers$OpenStreetMap) |>
  leaflet::addMarkers(
    clusterOptions = leaflet::markerClusterOptions()
  )


local <- review_map_local |>
  dplyr::select(code, where, scale)

# regional and local without lat/long
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
  dplyr::select(code, id, where, scale_color, geometry, CNTR_ID)


review_map_data |>
  dplyr::filter(sf::st_is_empty(geometry)) |>
  dplyr::count(where) |>
  dplyr::arrange(where) |>
  View()

usethis::use_data(review_map_data, overwrite = TRUE)
