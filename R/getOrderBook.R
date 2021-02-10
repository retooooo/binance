getOrderBook <- function(symbol = "BTC", symbol_base = "USDT", limit = 1000) {
  tmp <- getData("depth", args = list(symbol = paste0(symbol, symbol_base), limit = limit))
  if (is.null(tmp$bids)) {
    stop(str_glue("{symbol}{symbol_base} is not a valid symbol.")) 
  }
  ##TODO: write cpp version of this lapply
  bids <- lapply(1:length(tmp$bids), function(i) {
    data.frame(
      TYPE = "BID",
      QUANTITY = as.numeric(tmp$bids[[i]][[2]]),
      PRICE = as.numeric(tmp$bids[[i]][[1]])
    )
  }) %>%
    bind_rows()
  
  asks <- lapply(1:length(tmp$asks), function(i) {
    data.frame(
      TYPE = "ASK",
      QUANTITY = as.numeric(tmp$asks[[i]][[2]]),
      PRICE = as.numeric(tmp$asks[[i]][[1]])
    )
  }) %>%
    bind_rows()
  
  bind_rows(bids, asks)
}
