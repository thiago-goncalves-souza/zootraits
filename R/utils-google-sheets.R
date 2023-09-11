auth_google_sheets <- function() {
  token <- Sys.getenv("TOKEN_GOOGLESHEETS_ZOOTRAITS")
  googlesheets4::gs4_auth(path = token)
}
