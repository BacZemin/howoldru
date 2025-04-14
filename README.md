
![Alternative text for screen readers (describe the
image)](inst/nai-logo.png) \# howoldru

The goal of howoldru is to predict your age via DNAme data

## Installation

You can install the development version of howoldru like so:

``` r
devtools::install_github("BacZemin/howoldru")
#> Skipping install of 'howoldru' from a github remote, the SHA1 (28435eb4) has not changed since last install.
#>   Use `force = TRUE` to force installation
```

## Main function

``` r
library(howoldru)

# Create some example data
required_probes <- howoldru_data$probe_list
example_probes <- c(required_probes[1:min(50, length(required_probes))])

DNAme_matrix <- matrix(runif(length(example_probes) * 2),
                   nrow = length(example_probes), ncol = 2,
                   dimnames = list(example_probes, c("S1", "S2")))

# Estimate age
howoldru(DNAme_matrix)
#> [1] "Number of represented howoldru CpGs: 50 out of 221"
#> Warning in howoldru(DNAme_matrix): Only 50 out of 221 required CpGs were found
#> in the data matrix. Results may be less accurate.
#>       S1       S2 
#> 28.80886 35.73996
```
