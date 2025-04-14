
![logo for NAI package](inst/nai-logo.png) \# howoldru

The goal of howoldru is to predict your age via DNAme data

## Installation

You can install the development version of howoldru like so:

``` r
devtools::install_github("BacZemin/howoldru")
#> Downloading GitHub repo BacZemin/howoldru@HEAD
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#>      checking for file ‘/private/var/folders/dx/m03lf1sn56l6727mnb34gx1w0000gr/T/RtmpESoJEc/remotes12a9426d05cd4/BacZemin-howoldru-be86211/DESCRIPTION’ ...  ✔  checking for file ‘/private/var/folders/dx/m03lf1sn56l6727mnb34gx1w0000gr/T/RtmpESoJEc/remotes12a9426d05cd4/BacZemin-howoldru-be86211/DESCRIPTION’ (633ms)
#>   ─  preparing ‘howoldru’:
#>      checking DESCRIPTION meta-information ...  ✔  checking DESCRIPTION meta-information
#>   ─  checking for LF line-endings in source and make files and shell scripts (904ms)
#>   ─  checking for empty or unneeded directories
#> ─  building ‘howoldru_0.0.0.9000.tar.gz’
#>      
#> 
```

## Main function

``` r
library(howoldru)
set.seed(42)

# Create some example data
required_probes <- howoldru_data$probe_list

DNAme_matrix <- matrix(runif(length(required_probes) * 2),
                   nrow = length(required_probes), ncol = 2,
                   dimnames = list(required_probes, c("S1", "S2")))

# Estimate age
howoldru(DNAme_matrix)
#> [1] "Number of represented howoldru CpGs: 221 out of 221"
#>       S1       S2 
#> 46.11436 61.25904
```

## Vignette / Detailed Example

A detailed example demonstrating how to download data, run the
`howoldru` clock, and compare results is available in the package
vignette.

**View the rendered vignette directly on GitHub:**
**[howoldru_introduction.html](/doc/howoldru_introduction.html)**

back up link: <https://rpubs.com/BacZemin/1297456>

``` r
browseVignettes("howoldru")
```
