library(shiny)
library(bslib)

ui <- fluidPage(
  theme = bs_theme(
    bg = "#f9f9f9",
    fg = "#202A44",
    heading_font = font_google("Mouse Memoirs"),
    base_font = font_google("Uchen")
    ),
  titlePanel("Old Faithful Geyser Data"),
  sidebarLayout(
    sidebarPanel(
      sliderInput("bins","Number of bins:", min = 1, 
                  max = 50, value = 30)
    ),
    mainPanel(plotOutput("distPlot"))
  )
)

server <- function(input, output) {
  
  output$distPlot <- renderPlot({
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    hist(x, breaks = bins, col = 'darkgray', border = 'white',
         xlab = 'Waiting time to next eruption (in mins)',
         main = 'Histogram of waiting times')
  })
}

shinyApp(ui = ui, server = server)
