objeto <- rsconnect::accountInfo(name = "ecofun")
secret <- as.character(objeto$secret)
token <- as.character(objeto$token)
