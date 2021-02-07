getOrderBook <- function(symbol = "BTC", symbol_base = "USDT", limit = 1000) {
  tmp <- getData("depth", args = list(symbol = paste0(symbol, symbol_base), limit = limit))
  ##TODO: write cpp version of this lapply
  lapply(1:limit, function(i) {
    data.frame(
      TYPE = c("BID", "ASK"),
      QUANTITY = as.numeric(c(tmp$bids[[i]][[2]], tmp$asks[[i]][[2]])),
      PRICE = as.numeric(c(tmp$bids[[i]][[1]], tmp$asks[[i]][[1]]))
    )
  }) %>%
    bind_rows()
}
