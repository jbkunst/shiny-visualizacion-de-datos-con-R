library(shiny)
library(bslib)
library(ggplot2)

datos <- rnorm(100)

ui <- page_sidebar(
  title = "Mi primera app",
  theme = bs_theme(bootswatch = "sketchy"),
  sidebar = sidebar(
    sliderInput("nrand", "Simulaciones", min = 50, max = 100, value = 70),             
    selectInput("col", "Color", c("red", "blue", "black")),   
    checkboxInput("punto", "Puntos:", value = FALSE),
    actionButton("id", "Boton", class = "btn-primary"),
    actionButton("id2", "Otro Boton", class = "btn-secondary")
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
    d <- data.frame(x = 1:input$nrand, y = head(datos, input$nrand))
    p <- ggplot(d, aes(x, y)) +
      geom_line(color = input$col)
    if(input$punto)
      p <- p + geom_point(color = input$col)
    p
  })
  
  output$grafico2 <- renderPlot({
    d <- data.frame(y = head(datos, input$nrand))
    ggplot(d, aes(y)) +
      geom_histogram(fill = input$col, color = "gray80")
  })
  
  output$tabla <- renderTable({
    x <- head(datos, input$nrand)
    data.frame(mean(x), sd(x), length(x))
  })
  
}

shinyApp(ui, server)
