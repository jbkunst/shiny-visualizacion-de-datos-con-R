library(shiny)
library(bslib)

datos <- rnorm(100)

ui <- page_sidebar(
  title = "Mi primera app",
  sidebar = sidebar(
    sliderInput("nrand", "Simulaciones", min = 50, max = 100, value = 70),             
    selectInput("col", "Color", c("red", "blue", "black")),   
    checkboxInput("punto", "Puntos:", value = FALSE)
  ),
  navset_card_underline(
    title = "Resultados",
    nav_panel("Lineas", plotOutput("grafico")),
    nav_panel("Histograma", plotOutput("grafico2")),
    nav_panel("Tabla", tableOutput("tabla"))
  )
)

server <- function(input, output) {
  output$grafico <- renderPlot({                               
    plot(head(datos, input$nrand), type =  ifelse(input$punto, "b", "l"), col = input$col)
  })
  
  output$grafico2 <- renderPlot({
    hist(head(datos, input$nrand), col = input$col)
  })
  
  output$tabla <- renderTable({
    x <- head(datos, input$nrand)
    data.frame(mean(x), sd(x), length(x))
  })
  
}

shinyApp(ui, server)