library(shiny)
library(bslib)
library(ggplot2)
library(ragg) # Activa renderizado moderno
library(thematic)
options(shiny.useragg = TRUE) # Obliga a Shiny a usar ragg para plotear

datos <- rnorm(100)

tema_custom <- bs_theme(
  bg = "#e5e5e5", fg = "#0d0c0c", primary = "#dd2020",
  base_font = font_google("Press Start 2P"),
  code_font = font_google("Press Start 2P"),
  "font-size-base" = "0.75rem", "enable-rounded" = FALSE
)

thematic_shiny(font = "auto") # Hace funcionar a thematic

ui <- page_sidebar(
  title = "Mi primera app",
  theme = tema_custom,
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
    d <- data.frame(x = 1:input$nrand, y = head(datos, input$nrand))
    p <- ggplot(d, aes(x, y)) +
      geom_line(color = input$col) +
      theme(
        text = element_text(size = 18),
        plot.title = element_text(size = 24, face = "bold"),
        axis.title = element_text(size = 18),
        axis.text = element_text(size = 14)
      )
    if(input$punto)
      p <- p + geom_point(color = input$col)
    p
  })
  
  output$grafico2 <- renderPlot({
    d <- data.frame(y = head(datos, input$nrand))
    ggplot(d, aes(y)) +
      geom_histogram(fill = input$col, color = "gray80") +
      theme(
        text = element_text(size = 18),
        plot.title = element_text(size = 24, face = "bold"),
        axis.title = element_text(size = 18),
        axis.text = element_text(size = 14)
      )
  })
  
  output$tabla <- renderTable({
    x <- head(datos, input$nrand)
    data.frame(mean(x), sd(x), length(x))
  })
  
}

shinyApp(ui, server)
