source("https://git.io/xaringan2pdf")

rmarkdown::render("slide-01.Rmd")
rmarkdown::render("slide-02.Rmd")
rmarkdown::render("slide-03.Rmd")
rmarkdown::render("slide-04.Rmd")

xaringan_to_pdf("slide-01.html")
xaringan_to_pdf("slide-02.html")
xaringan_to_pdf("slide-03.html")
xaringan_to_pdf("slide-04.html")