# remotes::install_github("posit-dev/r-shinylive")
library(shinylive)

# Crear un directorio
fs::dir_create("exported")

# Exportar la aplicación Shiny a un directorio
shinylive::export("apps/ejemplo/", "exported/")

# Para testear
httpuv::runStaticServer("exported/")