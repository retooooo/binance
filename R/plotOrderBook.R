plotOrderBook <- function(symbol = "BTC", symbol_base = "USDT", limit = 1000) {
  d <- getOrderBook(symbol, symbol_base, limit)

  ggplot(d, aes(x = PRICE, y = QUANTITY, fill = TYPE))+
    geom_area()

}
