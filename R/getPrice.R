getPrice <- function(symbol, symbol_base = "USDT") {
  x <- getData(endpoint = "ticker/price", args = list(symbol = paste0(symbol, symbol_base)))
  if (is.null(x$price)) stop(str_glue("{symbol}{symbol_base} is not a valid symbol"))
  as.numeric(x$price)
}