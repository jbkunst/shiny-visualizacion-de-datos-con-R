source("https://git.io/xaringan2pdf")

rmarkdown::render("slides-01.Rmd")
rmarkdown::render("slides-02.Rmd")
rmarkdown::render("slides-03.Rmd")
rmarkdown::render("slides-04.Rmd")

xaringan_to_pdf("slides-01.html", output_file = "extras/slides-01.pdf")
xaringan_to_pdf("slides-02.html", output_file = "extras/slides-02.pdf")
xaringan_to_pdf("slides-03.html", output_file = "extras/slides-03.pdf")
xaringan_to_pdf("slides-04.html", output_file = "extras/slides-04.pdf")