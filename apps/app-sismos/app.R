library(shiny)
library(bslib)
library(highcharter)
library(leaflet)
library(DT)

library(rvest)  
library(janitor)
library(tidyverse)

descargar_data <- function(fecha = "20251118") {
  url <- format(
    ymd(fecha),
    "https://www.sismologia.cl/sismicidad/catalogo/%Y/%m/%Y%m%d.html"
  )
  datos <- read_html(url) |>
    html_table() |>
    nth(2) |>
    clean_names() |>
    separate(
      latitud_longitud,
      into = c("latitud", "longitud"),
      sep = " ",
      convert = TRUE
    ) 
  datos
}

ui <- page_sidebar(
  title = "Sismos",
  sidebar = sidebar(
    dateInput("fecha", "Seleccione fecha")
  ),
  layout_columns(
    card(leafletOutput("mapa")),
    card(DTOutput("tabla")),
    col_widths = 12
    )
  )

server <-  function(input, output){
  
  output$mapa <- renderLeaflet({
    datos <- descargar_data(input$fecha)
    leaflet(datos) |>
      addTiles() |>
      addMarkers(
        lng = ~longitud, lat = ~latitud,
        popup = ~as.character(magnitud_2),
        label = ~as.character(`fecha_local_lugar`)
      ) |>
      addProviderTiles("Esri.WorldImagery")
  })
    
  output$tabla <- renderDataTable({
    descargar_data(input$fecha)
  })

}

shinyApp(ui, server)




