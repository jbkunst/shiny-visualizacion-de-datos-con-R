library(shiny)
library(ggplot2)
library(bslib)

ui <- fluidPage(
  theme = bs_theme(
    bg = "#FFFDD0",
    fg = "#202A44",
    heading_font = font_google("Mouse Memoirs"),
    base_font = font_google("Uchen")
    ),
  titlePanel("Old Faithful Geyser Data"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins","Number of bins:", min = 1, max = 50, value = 30),
      textInput("titulo", "Ingrese titulo"),
      actionButton("boton", "No hago nada", class = "btn-primary")
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
