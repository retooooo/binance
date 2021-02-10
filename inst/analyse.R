require(binance)
require(DBI)
require(odbc)
require(ggplot2)
require(grid.extr)

db <- DBI::dbConnect(odbc::odbc(),
                     Driver = "SQL Server",
                     Server = "DESKTOP-MTCGC1L",
                     Database = "binance",
                     UID = "reto",
                     PWD = Sys.getenv("SQL_PASSWORD"))


x <-  dbGetQuery(db, "SELECT * FROM warehouse.price")
d <- x %>% 
  arrange(TIME) %>% 
  group_by(SYMBOL) %>% 
  mutate(PRICE_NORM = PRICE / first(PRICE)) %>% 
  ungroup()


ggplot(d, aes(x = TIME, y = PRICE_NORM, col = SYMBOL))+
  geom_line(size = 1)
