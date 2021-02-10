require(binance)
require(DBI)
require(odbc)

db <- DBI::dbConnect(odbc::odbc(),
                     Driver = "SQL Server",
                     Server = "DESKTOP-MTCGC1L",
                     Database = "binance",
                     UID = "reto",
                     PWD = "Retoliusienchen29")

sleep_time <- 10
symb <- c("BTC", "EGLD", "DATA", "XRP", "DOGE", "ETH")

while (TRUE) {
  d <- lapply(symb, function(s) {
    getOrderBook(symbol = s) %>%
      group_by(TYPE) %>%
      summarise(QUANTITY = sum(QUANTITY),
                PRICE = sum(PRICE * QUANTITY) / sum(QUANTITY),
                PRICE_MIN = min(PRICE),
                PRICE_MAX = max(PRICE),
                .groups = "drop") %>%
      ungroup() %>%
      mutate(SYMBOL = s)
  }) %>% 
    bind_rows()
  
  d2 <- lapply(symb, function(s) {
    data.frame(
      SYMBOL = s,
      PRICE = getPrice(s)
    )
  }) %>% 
    bind_rows()
  current_time <- Sys.time()
  d$TIME <- current_time
  d2$TIME <- current_time
  
  dbWriteTable(db, Id(schema = "warehouse", table = "order_book_summarised"), d, append = TRUE)
  dbWriteTable(db, Id(schema = "warehouse", table = "price"), d2, append = TRUE)
  
  Sys.sleep(sleep_time)
}



