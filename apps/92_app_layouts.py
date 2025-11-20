from shiny import App, ui, render
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

datos = np.random.normal(loc=0, scale=1, size=100)

app_ui = ui.page_sidebar(
    ui.sidebar(
        ui.input_slider("nrand", "Simulaciones", min=50, max=100, value=70),
        ui.input_select(
            "col",
            "Color",
            choices=["red", "blue", "black"],
        ),
        ui.input_checkbox("punto", "Puntos:", value=False),
    ),
    ui.navset_card_underline(
        ui.nav_panel("Lineas", ui.output_plot("grafico")),
        ui.nav_panel("Histograma", ui.output_plot("grafico2")),
        ui.nav_panel("Tabla", ui.output_table("tabla")),
        title="Resultados",
    ),
    title="Mi primera app",
)

def server(input, output, session):

    @output
    @render.plot
    def grafico():
        x = datos[: input.nrand()]
        fig, ax = plt.subplots()
        if input.punto():
            ax.plot(x, color=input.col(), marker="o")
        else:
            ax.plot(x, color=input.col())
        ax.set_title("Simulación de normales")
        ax.set_xlabel("Índice")
        ax.set_ylabel("Valor")
        return fig

    @output
    @render.plot
    def grafico2():
        x = datos[: input.nrand()]
        fig, ax = plt.subplots()
        ax.hist(x, color=input.col(), edgecolor="black")
        ax.set_title("Histograma")
        ax.set_xlabel("Valor")
        ax.set_ylabel("Frecuencia")
        return fig

    @output
    @render.table
    def tabla():
        x = datos[: input.nrand()]
        df = pd.DataFrame(
            {
                "mean": [float(np.mean(x))],
                "sd": [float(np.std(x, ddof=1))],
                "n": [len(x)],
            }
        )
        return df

app = App(app_ui, server)
