# plotly ------------------------------------------------------------------
library(ggplot2)
library(plotly)

data(iris)

p <- ggplot(iris, aes(Sepal.Length, Sepal.Width)) +
  geom_point() +
  geom_smooth(method = "lm") + 
  facet_wrap(vars(Species))

ggplotly(p)


# higcharter --------------------------------------------------------------
library(highcharter)
library(forecast)

data("AirPassengers")

hchart(AirPassengers, name = "Serie temporal", color = "red")

modelo <- forecast(auto.arima(AirPassengers))

hchart(modelo)


# DT ----------------------------------------------------------------------
library(DT)
library(rvest)   # descargar datos de paginas web

url <- "http://www.sismologia.cl"

datos <- read_html(url)|> 
  html_table()|> 
  dplyr::first()

datatable(datos)

# leaflet -----------------------------------------------------------------
library(leaflet)
data("quakes")

quakes

leaflet(quakes)|>
  addTiles()|>  
  addMarkers(
    lng = ~long, 
    lat = ~lat,
    popup = ~as.character(mag),
    label = ~as.character(depth)
  )

