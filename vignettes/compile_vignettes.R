# Compile vignettes
knitr::knit("vignettes/baldur_yeast_tutorial.Rmd.orig",
            "vignettes/baldur_yeast_tutorial.Rmd", envir = new.env()
)
knitr::knit("vignettes/baldur_ups_tutorial.Rmd.orig",
            "vignettes/baldur_ups_tutorial.Rmd", envir = new.env()
)

# Change image path in compiled vignettes
for(i in list.files("./vignettes/", pattern = "Rmd$", full.names = TRUE)) {
  tx  <- readLines(i)
  tx2  <- gsub(pattern = "\\]\\(vignettes/", replace = "\\]\\(", x = tx)
  writeLines(tx2, i)
}

rm(tx, tx2, i)
