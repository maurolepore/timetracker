
<!-- README.md is generated from README.Rmd. Please edit that file -->

# timetracker

<!-- badges: start -->

[![R-CMD-check](https://github.com/maurolepore/timetracker/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/maurolepore/timetracker/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

The goal of timetracker is to help you work with data from the
[GoogleSheets extension “Time
Tracker”](https://workspace.google.com/marketplace/app/time_tracker/182790105381).

## Installation

You can install the development version of timetracker with:

``` r
# install.packages("pak")
pak::pak("maurolepore/timetracker")
```

## Example

``` r
library(dplyr, warn.conflicts = FALSE)
library(googlesheets4)
library(timetracker)
```

Read your google sheet with googlesheets4.

``` r
url <- "https://docs.google.com/spreadsheets/d/1yz1j_CuLVwQwkzxW_6kuZH1mCEWuD-n-rCy70aORyc0/edit?usp=sharing"
raw <- read_sheet(url)
#> ℹ Suitable tokens found in the cache, associated with these emails:
#> • 'mauro@2degrees-investing.org'
#> • 'maurolepore@gmail.com'
#>   Defaulting to the first email.
#> ! Using an auto-discovered, cached token.
#>   To suppress this message, modify your code or options to clearly consent to
#>   the use of a cached token.
#>   See gargle's "Non-interactive auth" vignette for more details:
#>   <https://gargle.r-lib.org/articles/non-interactive-auth.html>
#> ℹ The googlesheets4 package is using a cached token for
#>   'mauro@2degrees-investing.org'.
#> ✔ Reading from "bit.ly/mauro-time".
#> ✔ Range 'timetracker'.
```

``` r

tail(raw)
#> # A tibble: 6 × 4
#>   `Case Ref#`    `Start Time`        `Stop Time`         Difference
#>   <chr>          <dttm>              <dttm>              <chr>     
#> 1 tiltWebTool#79 2024-06-25 11:20:07 2024-06-25 17:52:44 06:32:37  
#> 2 tiltWebTool#91 2024-06-26 04:59:05 2024-06-26 10:45:32 05:46:26  
#> 3 tiltWebTool#83 2024-06-26 10:45:33 2024-06-26 13:05:09 02:19:37  
#> 4 tiltWebTool#83 2024-06-26 13:21:43 2024-06-26 13:23:31 00:01:48  
#> 5 Help Kalash    2024-06-26 13:23:32 2024-06-26 15:11:32 01:48:00  
#> 6 <NA>           2024-06-26 15:11:34 NA                  <NA>
```

Wrangle the data with timetracker.

``` r
time <- timetracker::wrangle(raw)

tail(time)
#> # A tibble: 6 × 5
#>   date       case_ref_number start_time          stop_time           difference 
#>   <date>     <chr>           <dttm>              <dttm>              <drtn>     
#> 1 2024-06-25 Review          2024-06-25 09:05:49 2024-06-25 11:18:17 2.20776917…
#> 2 2024-06-25 tiltWebTool#79  2024-06-25 11:20:07 2024-06-25 17:52:44 6.54360722…
#> 3 2024-06-26 tiltWebTool#91  2024-06-26 04:59:05 2024-06-26 10:45:32 5.77399333…
#> 4 2024-06-26 tiltWebTool#83  2024-06-26 10:45:33 2024-06-26 13:05:09 2.32688611…
#> 5 2024-06-26 tiltWebTool#83  2024-06-26 13:21:43 2024-06-26 13:23:31 0.02997028…
#> 6 2024-06-26 Help Kalash     2024-06-26 13:23:32 2024-06-26 15:11:32 1.79992222…
```

Analyze the data with familiar tidyverse packages.

``` r
# Time spent by task in the last week
week <- 7
time |>
  filter(date == tail(unique(date), week)) |>
  summarise(spent = sum(difference), .by = c("case_ref_number", "date"))
#> # A tibble: 6 × 3
#>   case_ref_number      date       spent          
#>   <chr>                <date>     <drtn>         
#> 1 Meeting              2024-06-18 1.0004019 hours
#> 2 tiltWebTool#70       2024-06-19 0.2742353 hours
#> 3 st setup copilot     2024-06-20 2.0009028 hours
#> 4 st admin             2024-06-21 1.0031956 hours
#> 5 tiltWebTool planning 2024-06-24 1.9782328 hours
#> 6 Help Kalash          2024-06-26 1.7999222 hours
```

``` r

# Time spent across all tasks the last day
time |>
  filter(date == last(date)) |>
  summarise(spent = sum(difference), .by = "date")
#> # A tibble: 1 × 2
#>   date       spent         
#>   <date>     <drtn>        
#> 1 2024-06-26 9.930772 hours
```
