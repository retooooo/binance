getOrderBook <- function(symbol = "BTC", symbol_base = "USDT", limit = 1000) {
  tmp <- getData("depth", args = list(symbol = paste0(symbol, symbol_base), limit = limit))
  if (is.null(tmp$bids)) {
    stop(str_glue("{symbol}{symbol_base} is not a valid symbol.")) 
  }
  ##TODO: write cpp version of this lapply
  limit <- length(tmp$bids)
  lapply(1:limit, function(i) {
    data.frame(
      TYPE = c("BID", "ASK"),
      QUANTITY = as.numeric(c(tmp$bids[[i]][[2]], tmp$asks[[i]][[2]])),
      PRICE = as.numeric(c(tmp$bids[[i]][[1]], tmp$asks[[i]][[1]]))
    )
  }) %>%
    bind_rows()
}
