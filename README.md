
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
#>   `Case Ref#` `Start Time`        `Stop Time`         Difference
#>   <chr>       <dttm>              <dttm>              <chr>     
#> 1 Other       2023-07-17 10:18:17 2023-07-17 12:02:39 01:44:22  
#> 2 Meeting     2023-07-17 11:30:44 2023-07-17 12:03:00 00:32:16  
#> 3 Meeting     2023-07-17 12:03:03 2023-07-17 13:59:55 01:56:52  
#> 4 Other       2023-07-17 14:26:33 2023-07-17 14:43:05 00:16:32  
#> 5 Review      2023-07-17 17:28:10 2023-07-17 18:28:12 01:00:03  
#> 6 Review      2023-07-17 18:28:14 2023-07-17 19:09:28 00:41:14
```

Wrangle the data with timetracker.

``` r
time <- timetracker::wrangle(raw)

tail(time)
#> # A tibble: 6 × 5
#>   date       case_ref_number start_time          stop_time           difference 
#>   <date>     <chr>           <dttm>              <dttm>              <drtn>     
#> 1 2023-07-17 Other           2023-07-17 10:18:17 2023-07-17 12:02:39 1.7394133 …
#> 2 2023-07-17 Meeting         2023-07-17 11:30:44 2023-07-17 12:03:00 0.5378278 …
#> 3 2023-07-17 Meeting         2023-07-17 12:03:03 2023-07-17 13:59:55 1.9478808 …
#> 4 2023-07-17 Other           2023-07-17 14:26:33 2023-07-17 14:43:05 0.2754378 …
#> 5 2023-07-17 Review          2023-07-17 17:28:10 2023-07-17 18:28:12 1.0007322 …
#> 6 2023-07-17 Review          2023-07-17 18:28:14 2023-07-17 19:09:28 0.6872436 …
```

Analyze the data with familiar tidyverse packages.

``` r
# Time spent by task recently
time |>
  summarise(spent = sum(difference), .by = c("case_ref_number", "date")) |> 
  tail()
#> # A tibble: 6 × 3
#>   case_ref_number                 date       spent          
#>   <chr>                           <date>     <drtn>         
#> 1 TiltDevProjectMGMT#115 estimate 2023-07-13 2.9069869 hours
#> 2 TiltDevProjectMGMT#115 estimate 2023-07-14 6.9995194 hours
#> 3 Other                           2023-07-14 0.6927558 hours
#> 4 Other                           2023-07-17 2.0909328 hours
#> 5 Meeting                         2023-07-17 2.4857086 hours
#> 6 Review                          2023-07-17 1.6879758 hours

# Time spent across all tasks recently
time |>
  summarise(spent = sum(difference), .by = "date") |> 
  tail()
#> # A tibble: 3 × 2
#>   date       spent         
#>   <date>     <drtn>        
#> 1 2023-07-13 6.215569 hours
#> 2 2023-07-14 7.692275 hours
#> 3 2023-07-17 6.264617 hours
```
