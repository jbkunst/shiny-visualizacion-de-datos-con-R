library(shiny)
library(bslib)
library(rvest) 
library(tidyverse)
library(leaflet)
library(DT)

get_data_fecha <- function(fecha = "2024-11-01"){
 
  f <- ymd(fecha)
  
  url <- str_glue("https://www.sismologia.cl/sismicidad/catalogo/{year(fecha)}/{month(fecha)}/{format(f, '%Y%m%d')}.html")
  # url <- as.character(url)

  print(url)
  
  datos <- read_html(url) |>
    html_table() |>
    dplyr::nth(2) |>
    janitor::clean_names() |>
    tidyr::separate(
      latitud_longitud,
      into = c("latitud", "longitud"),
      sep = " ", convert = TRUE
    )
  
  datos
  
}


# tabla
# grafico
# cambiar tema (bslib bs_theme())
# plublicar

tema_app <- bs_theme(
  primary = "#eb6123",
  heading_font = font_google("Sansita"),
  base_font = font_google("Sansita")
)

ui <- page_navbar(
  title = "Sismología versión número dos",
  theme = tema_app,
  sidebar = sidebar(
    dateInput("fecha", "Seleccionar fecha", max = Sys.Date() - 1, value = Sys.Date() - 1),
    sliderInput("slider", "Slider", min = 0, max = 10, value = 5),
    actionButton("button", "Botón", class = "btn-primary")
  ),
  nav_panel(
    title = "Principal",
    layout_columns(
      card(
        card_header("Mapa"),
        leafletOutput("mapa"),
        full_screen = TRUE, 
        card_footer("datos de sismología")
        ),
      layout_columns(
        card(card_header("Tabla"), DTOutput("tabla"), full_screen = TRUE),
        card(card_header("Grafico")),
        col_widths = c(12, 12)
        )
      )
    )
  )

server <- function(input, output) {
  
  output$mapa <- renderLeaflet({
    datos <- get_data_fecha(input$fecha)
    
    leaflet(datos) |>
      addTiles() |>
      addMarkers(
        lng = ~longitud,
        lat = ~latitud,
        popup = ~as.character(magnitud_2),
        label = ~as.character(`fecha_local_lugar`)
      ) |>
      addProviderTiles("Esri.WorldImagery")
    
  })
  
  output$tabla <- renderDT({
    get_data_fecha(input$fecha)
  })

}

# shinyApp(ui = ui, server = server, options = list(host = "192.168.1.46"))
