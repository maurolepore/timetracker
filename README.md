
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
#> ! Using an auto-discovered, cached token.
#>   To suppress this message, modify your code or options to clearly consent to
#>   the use of a cached token.
#>   See gargle's "Non-interactive auth" vignette for more details:
#>   <https://gargle.r-lib.org/articles/non-interactive-auth.html>
#> ℹ The googlesheets4 package is using a cached token for
#>   'maurolepore@gmail.com'.
#> ✔ Reading from "bit.ly/mauro-time".
#> ✔ Range 'timetracker'.

tail(raw)
#> # A tibble: 6 × 4
#>   `Case Ref#`           `Start Time`        `Stop Time`         Difference
#>   <chr>                 <dttm>              <dttm>              <chr>     
#> 1 tilt#29, architecture 2023-08-06 16:23:05 2023-08-06 16:45:02 00:21:57  
#> 2 tilt#29, architecture 2023-08-06 18:54:24 2023-08-06 20:20:47 01:26:23  
#> 3 tilt#29, architecture 2023-08-07 05:12:16 2023-08-07 05:39:29 00:27:13  
#> 4 Other                 2023-08-07 09:45:55 2023-08-07 09:52:09 00:06:15  
#> 5 tilt#31, architecture 2023-08-07 10:15:12 2023-08-07 10:15:15 00:00:02  
#> 6 Other                 2023-08-07 10:15:17 NA                  <NA>
```

Wrangle the data with timetracker.

``` r
time <- timetracker::wrangle(raw)

tail(time)
#> # A tibble: 6 × 5
#>   date       case_ref_number  start_time          stop_time           difference
#>   <date>     <chr>            <dttm>              <dttm>              <drtn>    
#> 1 2023-08-04 tiltData#265, t… 2023-08-04 11:26:08 2023-08-04 12:00:01 0.5646591…
#> 2 2023-08-06 tilt#29, archit… 2023-08-06 16:23:05 2023-08-06 16:45:02 0.3657244…
#> 3 2023-08-06 tilt#29, archit… 2023-08-06 18:54:24 2023-08-06 20:20:47 1.4397338…
#> 4 2023-08-07 tilt#29, archit… 2023-08-07 05:12:16 2023-08-07 05:39:29 0.4536219…
#> 5 2023-08-07 Other            2023-08-07 09:45:55 2023-08-07 09:52:09 0.1040491…
#> 6 2023-08-07 tilt#31, archit… 2023-08-07 10:15:12 2023-08-07 10:15:15 0.0006816…
```

Time spent by task recently

``` r
time |> 
  filter(date >= "2023-08-07") |>
  summarise(spent = sum(difference), .by = c("case_ref_number")) |> 
  tail()
#> # A tibble: 3 × 2
#>   case_ref_number       spent             
#>   <chr>                 <drtn>            
#> 1 tilt#29, architecture 0.4536219445 hours
#> 2 Other                 0.1040491666 hours
#> 3 tilt#31, architecture 0.0006816667 hours
```

Time spent across all tasks recently

``` r
time |>
  summarise(spent = sum(difference), .by = "date") |> 
  tail()
#> # A tibble: 6 × 2
#>   date       spent          
#>   <date>     <drtn>         
#> 1 2023-08-01 6.3057353 hours
#> 2 2023-08-02 0.7505556 hours
#> 3 2023-08-03 8.6283528 hours
#> 4 2023-08-04 2.0020936 hours
#> 5 2023-08-06 1.8054583 hours
#> 6 2023-08-07 0.5583528 hours
```
