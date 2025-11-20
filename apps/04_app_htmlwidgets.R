library(shiny)
library(bslib)
library(highcharter)
library(DT)

datos <- rnorm(100)

ui <- page_sidebar(
  title = "Mi primera app",
  sidebar = sidebar(
    sliderInput("nrand", "Simulaciones", min = 50,
                max = 100, value = 70),             
    selectInput("col", "Color", c("red", "blue", "black")),   
    # checkboxInput("punto", "Puntos:", value = FALSE)
  ),
  navset_card_underline(
    title = "Resultados",
    nav_panel("Lineas", highchartOutput("grafico")),
    nav_panel("Histograma", highchartOutput("grafico2")),
    nav_panel("Tabla", DTOutput("tabla"))
  )   
)

server <- function(input, output) {
  output$grafico <- renderHighchart({
    hchart(
      ts(head(datos, input$nrand)),
      name = "Datos",
      color = input$col
    )
  })
  output$grafico2 <- renderHighchart({
    hchart(head(datos, input$nrand), color = input$col)
  })
  output$tabla <- renderDT({
    x <- head(datos, input$nrand)
    data.frame(mean(x), sd(x), length(x))  
  })
}

shinyApp(ui, server)