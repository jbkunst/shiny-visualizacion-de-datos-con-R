from shiny import App, ui, render

app_ui = ui.page_fluid(
    ui.h2("Hola desde Shiny para Python 😄"),
    ui.input_slider("n", "Cantidad de puntos", 10, 100, 30),
    ui.output_text_verbatim("texto")
)

def server(input, output, session):
    @output
    @render.text
    def texto():
        return f"Has elegido {input.n()} puntos."

app = App(app_ui, server)
