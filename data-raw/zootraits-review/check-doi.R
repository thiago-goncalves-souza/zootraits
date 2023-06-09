devtools::load_all()

tab_doi <- fs::dir_ls("data-raw/zootraits-review/doi_check/", glob = "*.xlsx") |>
  purrr::map(readxl::read_excel) |>
  purrr::map(~dplyr::select(.x, -group, -need_fixing)) |>
  purrr::list_rbind()


doi_prepare_check <- tab_doi |>
  dplyr::filter(status_code_doi %in% c("404", "503", "1000")) |>
  dplyr::select(code, doi, doi_url)

doi_prepare_check |>
  writexl::write_xlsx("doi_check.xlsx")

# original
# doi_prepare_check <- review_data |>
#   dplyr::distinct(code, doi) |>
#   dplyr::mutate(doi_url = fix_doi(doi)) |>
#   tidyr::drop_na(doi_url)


check_status <- function(url_check){
  url_check |>
    httr::GET() |>
    purrr::pluck("status_code")
}

execute_check_status <- function(df){
  df_status <- df |>
   dplyr::mutate(status_code_doi = purrr::map_vec(doi_url, possibly_check_status, .progress = TRUE))


  df_status |>
    writexl::write_xlsx(path = paste0("data-raw/zootraits-review/doi_check/temp_",
                        unique(df$group),
                        ".xlsx"))
}

possibly_check_status <- purrr::possibly(check_status, 1000)

prepare_doi <- doi_prepare_check |>
  tibble::rowid_to_column() |>
  dplyr::mutate(group = ceiling(rowid/50)) |>
 # dplyr::mutate(group = paste0("fix_", group)) |>
  dplyr::group_split(group)


prepare_doi |>
  purrr::map(execute_check_status, .progress = TRUE)

# table to check - first 404

doi_to_fix <- readxl::read_excel("data-raw/zootraits-review/doi_check/temp_fix_1.xlsx") |>
  dplyr::filter(status_code_doi != 200)


