connect_db <- function(
    password = Sys.getenv("ZOOTRAITS_DB_PASSWORD")) {
  DBI::dbConnect(
    drv = RPostgres::Postgres(),
    dbname = "hngemnap",
    host = "silly.db.elephantsql.com",
    port = 5432,
    user = "hngemnap",
    password = password
  )
}
