library(reactlog)

# tell shiny to log all reactivity
reactlog_enable()

reactlogReset()

# run a shiny app
shiny::runApp("apps/reactividad/app-01/app.R")

# once app has closed, display reactlog from shiny
shiny::reactlogShow()

# run a shiny app
shiny::runApp("apps/reactividad/app-02/app.R")

# once app has closed, display reactlog from shiny
shiny::reactlogShow()
