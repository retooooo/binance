d <- lapply(1:20, function(i) {
  x <- getOrderBook(symbol = "DATA") %>%
    group_by(TYPE) %>%
    summarise(QTY = sum(QUANTITY),
              PRICE = sum(PRICE * QUANTITY) / sum(QUANTITY),
              PRICE_MIN = min(PRICE),
              PRICE_MAX = max(PRICE)) %>%
    ungroup() %>%
    mutate(TIME = Sys.time())
  Sys.sleep(1)
  x
})

pd <- d %>%
  bind_rows() %>%
  mutate(PRICE = ifelse(TYPE == "ASK", PRICE_MIN, PRICE_MAX)) %>%
  pivot_longer(cols = c(QTY, PRICE), names_to = "INFO", values_to = "VALUE")

ggplot(pd, aes(x = TIME, y = VALUE, col = TYPE))+
  geom_line()+
  facet_grid(INFO ~ ., scales = "free")
