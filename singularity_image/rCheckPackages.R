suppressPackageStartupMessages(library(tidyverse))

pkgList <- read_lines("list_of_rpackages") %>% str_subset("^$", negate = TRUE)

fail <- pkgList

for(pkg in pkgList){
  check <- suppressPackageStartupMessages(require(pkg, character.only = TRUE, quietly = TRUE))
  if(check){
    fail <- fail %>% setdiff(pkg)
  }
}

if(length(fail) > 0){
  stop(paste("The following packages are not installed:", paste(fail, collapse = ", ")))
} else {
  message("All packages are installed.")
}
