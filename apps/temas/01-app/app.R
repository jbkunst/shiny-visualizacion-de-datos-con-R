library(shiny)
library(ggplot2)

ui <- fluidPage(
  titlePanel("Old Faithful Geyser Data"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins","Number of bins:", min = 1, max = 50, value = 30),
      textInput("titulo", "Ingrese titulo")
    ),
    mainPanel(plotOutput("distPlot"))
  )
)

server <- function(input, output) {
  output$distPlot <- renderPlot({
    qplot(faithful[, 2], geom = "histogram", bins = input$bins + 1) + ggtitle(input$titulo)
  })
}

shinyApp(ui = ui, server = server)