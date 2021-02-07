getData <- function(endpoint, version = "v3", args = list()) {
  if (length(args) > 0) {
    args <- paste(sapply(1:length(args), function(i) {
      paste0(names(args)[i], "=", args[i])
    }), collapse = "&")
  } else {
    args <- ""
  }
  url <- "https://api.binance.com/api/{version}/{endpoint}?{args}"
  url %>%
    str_glue() %>%
    GET() %>%
    content(type = "application/json")
}
