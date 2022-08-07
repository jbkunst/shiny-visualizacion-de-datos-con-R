library(shiny)
library(leaflet)
library(rvest)
library(dplyr)
library(janitor)
library(tidyverse)
library(lubridate)
library(DT)

ui <- navbarPage(
  "VerSismos", 
  tabPanel(
    "Sismos",
    sidebarLayout(
      sidebarPanel(
        dateInput(
          "fecha",
          label = h3("Seleccione fecha por favor"),
          max = Sys.Date()
        )
      ),
      mainPanel(
        fluidRow(
          column(width = 4, leafletOutput("mapa")),
          column(width = 8, DTOutput("tabla"))
          )
        )
      )
    )
  )

server <- function(input, output){
  
  output$mapa <- renderLeaflet({
    
    fecha <- ymd(input$fecha)
    y <- year(fecha)
    m <- format(fecha, "%m")  
    d <- format(fecha, "%Y%m%d")  
    
    url <- str_glue("https://www.sismologia.cl/sismicidad/catalogo/{y}/{m}/{d}.html")
    
    datos <- read_html(url) |>
      html_table() |>
      dplyr::nth(2) |>
      janitor::clean_names() |>
      tidyr::separate(latitud_longitud, into = c("latitud", "longitud"),
                      sep = " ", convert = TRUE
      )
    
    leaflet(datos) |>
      addTiles() |>
      addMarkers(
        lng = ~longitud,
        lat = ~latitud,
        popup = ~as.character(magnitud_2),
        label = ~as.character(`fecha_local_lugar`)
      )
    
  })
  
  output$tabla <- renderDT({
    
    fecha <- ymd(input$fecha)
    y <- year(fecha)
    m <- format(fecha, "%m")  
    d <- format(fecha, "%Y%m%d")  
    
    url <- str_glue("https://www.sismologia.cl/sismicidad/catalogo/{y}/{m}/{d}.html")
    
    datos <- read_html(url) |>
      html_table() |>
      dplyr::nth(2) |>
      janitor::clean_names() |>
      tidyr::separate(latitud_longitud, into = c("latitud", "longitud"),
                      sep = " ", convert = TRUE
      )
    
    datatable(datos)
    
  })
  
}

shinyApp(ui, server)
