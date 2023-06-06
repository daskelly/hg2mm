# hg2mm

An R package to convert between human and mouse gene orthologs

## Package development cheatsheet:

https://raw.githubusercontent.com/rstudio/cheatsheets/main/package-development.pdf

## Orthologs file

File is from Mouse Genome Informatics and is called HOM_MouseHumanSequence.rpt. 
Download from https://www.informatics.jax.org/downloads/reports/index.html#homology.
Browse at https://www.informatics.jax.org/downloads/reports/HOM_MouseHumanSequence.rpt.
I gzipped the file to save space in repo `gzip HOM_MouseHumanSequence.rpt`.

## Installing the package

```r
remotes::install_github("daskelly/hg2mm")
```

## Building the package

```r
library(devtools)
library(roxygen2)

setwd("~/repos")
create("hg2mm")
use_r("load_data")
use_r("hg2mm")
# Export functions for users by placing @export in their
# roxygen comments

usethis::use_testthat(3)   # see https://r-pkgs.org/testing-basics.html
use_test("hg2mm")

# Import packages that your package requires to work: 
#use_package(x, type = "imports")
usethis::use_package("assertthat", "Imports")
usethis::use_package("readr", "Imports")
usethis::use_package("tibble", "Imports")
usethis::use_package("dplyr", "Imports")
usethis::use_package("tidyr", "Imports")

setwd('./hg2mm')
document()
```

When coming back to add new functions:
```r
# Add functions to R/
# When referring to internal functions no need for :: or :::
# rm -f NAMESPACE
library(devtools)
document()
```

When working on the package locally you use:
```r
setwd("~/repos/hg2mm")
library(devtools)
load_all()
```
