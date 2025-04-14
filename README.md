
![logo for NAI package](inst/nai-logo.png) \# howoldru

The goal of howoldru is to predict your age via DNAme data

## Installation

You can install the development version of howoldru like so:

``` r
devtools::install_github("BacZemin/howoldru")
#> Downloading GitHub repo BacZemin/howoldru@HEAD
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#>      checking for file ‘/private/var/folders/dx/m03lf1sn56l6727mnb34gx1w0000gr/T/Rtmp0b3yNT/remotesf50c703494e6/BacZemin-howoldru-af5c159/DESCRIPTION’ ...  ✔  checking for file ‘/private/var/folders/dx/m03lf1sn56l6727mnb34gx1w0000gr/T/Rtmp0b3yNT/remotesf50c703494e6/BacZemin-howoldru-af5c159/DESCRIPTION’ (1.4s)
#>   ─  preparing ‘howoldru’: (634ms)
#>      checking DESCRIPTION meta-information ...  ✔  checking DESCRIPTION meta-information
#>   ─  checking for LF line-endings in source and make files and shell scripts (691ms)
#>   ─  checking for empty or unneeded directories
#> ─  building ‘howoldru_0.0.0.9000.tar.gz’
#>      
#> 
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
#> 19.20345 27.51028
```

## Vignette / Detailed Example

A detailed example demonstrating how to download data, run the
`howoldru` clock, and compare results is available in the package
vignette.

``` r
library(howoldru)
browseVignettes("howoldru")
#> No vignettes found by browseVignettes("howoldru")
```
