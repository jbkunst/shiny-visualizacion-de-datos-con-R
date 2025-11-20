library(shiny)
library(bslib)
library(ggplot2)

datos <- rnorm(100)

tema_nes <- bs_theme(
  bg = "#e5e5e5", fg = "#0d0c0c", primary = "#dd2020",
  base_font = font_google("Press Start 2P"),
  code_font = font_google("Press Start 2P"),
  "font-size-base" = "0.75rem", "enable-rounded" = FALSE
)

tema_santander <- bs_theme(
  version = 5,
  primary     = "#EC0000",   # Rojo Santander
  secondary   = "#F5F5F5",   # Gris claro
  bg          = "white",
  fg          = "#333333",
  base_font   = font_google("Roboto"),
  heading_font = font_google("Montserrat"),
  # Navbar del color primario
  navbar_bg   = "#EC0000",
  navbar_fg   = "white"
)

tema_falabella <- bs_theme(
  version = 5,
  primary     = "#78BE20",   # Verde Falabella
  secondary   = "#4A4A4A",   # Gris oscuro
  bg          = "white",
  fg          = "#333333",
  base_font   = font_google("Lato"),
  heading_font = font_google("Nunito Sans"),
  # Navbar del color primario
  navbar_bg   = "#78BE20",
  navbar_fg   = "white"
)

tema_cencosud <- bs_theme(
  version = 5,
  primary     = "#005EB8",    # Azul Cencosud
  secondary   = "#F28C00",    # Naranjo corporativo
  bg          = "white",
  fg          = "#222222",
  base_font   = font_google("Inter"),
  heading_font = font_google("Poppins"),
  # Navbar del color primario
  navbar_bg   = "#005EB8",
  navbar_fg   = "white"
)


ui <- page_sidebar(
  title = "Mi primera app",
  theme = tema_nes,
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
