auth_google_sheets <- function() {
  env_var <- Sys.getenv("TOKEN_GOOGLESHEETS_ZOOTRAITS")

  env_var |>
    stringr::str_trunc(width = 100) |>
    print()

  if (env_var == "") {
    stop(
      "Please set the environment variable TOKEN_GOOGLESHEETS_ZOOTRAITS with the credentials to access the Google Sheet."
    )
  }

  googlesheets4::gs4_auth(path = env_var)
}
