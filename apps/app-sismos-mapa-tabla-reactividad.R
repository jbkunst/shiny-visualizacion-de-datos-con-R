# Ejercio inicial de la clase 3
library(shiny)
library(leaflet)
library(rvest)
library(dplyr)
library(janitor)
library(tidyverse)
library(lubridate)
library(DT)
library(bslib)

descarga_sismos_por_dia <- function(fecha_string){
  
  message(fecha_string)
  
  fecha <- ymd(fecha_string)
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
    ) |> 
    mutate(
      # convertir magnitud_2 a numerico
      magnitud_2 = as.numeric(str_remove(magnitud_2, " Ml"))
    )
  datos
}

ui <- navbarPage(
  theme = bs_theme(
    "navbar-light-bg"  = "#002884",
    primary = "#5583ff",
    base_font = font_google("Nunito")
  ),
  # "VerSismos", 
  tags$span(
    "Sismos en ",
    tags$img(src = "https://portales.bancochile.cl/uploads/000/035/565/2ca8e2c5-606c-47f4-80ef-03bec528775d/original/bch-inverse.svg"),  
  ),
  tabPanel(
    "Sismos",
    sidebarLayout(
      sidebarPanel(
        width = 2,
        dateInput(
          "fecha",
          label = h5("Seleccione fecha por favor"),
          max = Sys.Date()
        ),
        sliderInput("filtro_magnitud", label = "filtrar magnitud", min = 3, max = 10, value = 10),
        actionButton("primary", "Primary", icon("r-project"), class = "btn-primary m-2")
      ),
      mainPanel(
        width = 10,
        fluidRow(
          column(width = 4, leafletOutput("mapa")),
          column(width = 8, DTOutput("tabla"))
        )
      )
    )
  )
)

server <- function(input, output){
  
  dataSismos <- reactive({
    
    datos <- descarga_sismos_por_dia(input$fecha)
    datos
    
  })
  
  output$mapa <- renderLeaflet({
    
    datos <- dataSismos()
    
    leaflet(datos) |>
      addTiles() |>
      addMarkers(
        lng = ~longitud,
        lat = ~latitud,
        popup = ~as.character(magnitud_2),
        label = ~as.character(`fecha_local_lugar`)
      )
  })
  
  output$tabla <- renderDataTable({

    datos <- dataSismos()
    mmax <- input$filtro_magnitud
    
    datos_filtrados <- datos |> 
      filter(magnitud_2 <= mmax)
    
    datatable(datos_filtrados)
  })
  
  
  
  
  
  
  
  
  
  
}


shinyApp(ui, server)