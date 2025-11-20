library(shiny)
library(bslib)

ui <- page_sidebar(
  title = "Mi primera app",
  sidebar = sidebar(
    sliderInput("nrand", "Simulaciones", min = 50, max = 100, value = 70),
    selectInput("col", "Color", c("red", "blue", "black")),
    checkboxInput("punto", "Puntos:", value = FALSE)
  ),
  plotOutput("grafico")
)

server <- function(input, output) {
  output$grafico <- renderPlot({
    set.seed(123)
    x <- rnorm(input$nrand)
    t <- ifelse(input$punto, "b", "l")
    plot(x, type = t, col = input$col)
  })
}

shinyApp(ui, server)