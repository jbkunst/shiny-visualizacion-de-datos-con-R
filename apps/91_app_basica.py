from shiny import App, ui, render
import matplotlib.pyplot as plt
import numpy as np

app_ui = ui.page_sidebar(  
    ui.sidebar(
        ui.input_slider("n", "N", 0, 100, 20),
        bg="#f8f8f8" 
    ),
    ui.output_plot("histogram")
)  

def server(input, output, session):
    
    @render.plot(alt="A histogram")
    def histogram():
        np.random.seed(19680801)
        x = 100 + 15 * np.random.randn(437)
        plt.hist(x, input.n(), density=True)

app = App(app_ui, server)
