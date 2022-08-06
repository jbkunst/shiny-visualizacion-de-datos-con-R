library(shiny)
library(ggplot2)
library(bslib)
library(thematic)

thematic_shiny(font = "Press Start 2P")

ui <- fluidPage(
  theme = bs_theme(
    bg = "#f5f5f5",
    fg = "#202A44",
    primary = "#8B0000",
    heading_font = font_google("Mouse Memoirs"),
    base_font = font_google("Press Start 2P")
  ),
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
