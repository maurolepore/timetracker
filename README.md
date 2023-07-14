
<!-- README.md is generated from README.Rmd. Please edit that file -->

# timetracker

<!-- badges: start -->
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
url <- "https://docs.google.com/spreadsheets/d/1Pz9_Dn24DPpWpEXFggSwZJWSp0DHtYbgpeS1_90KtEA/edit?usp=sharing"
raw <- read_sheet(url)
#> ! Using an auto-discovered, cached token.
#>   To suppress this message, modify your code or options to clearly consent to
#>   the use of a cached token.
#>   See gargle's "Non-interactive auth" vignette for more details:
#>   <https://gargle.r-lib.org/articles/non-interactive-auth.html>
#> ℹ The googlesheets4 package is using a cached token for
#>   'maurolepore@gmail.com'.
#> ✔ Reading from "time-tracker".
#> ✔ Range 'Sheet1'.

tail(raw)
#> # A tibble: 6 × 4
#>   `Case Ref#`                 `Start Time`        `Stop Time`         Difference
#>   <chr>                       <dttm>              <dttm>              <chr>     
#> 1 TiltDevProjectMGMT#115 est… 2023-07-14 10:14:31 2023-07-14 12:49:57 02:35:25  
#> 2 TiltDevProjectMGMT#115 est… 2023-07-14 12:49:59 2023-07-14 13:54:40 01:04:41  
#> 3 TiltDevProjectMGMT#115 est… 2023-07-14 13:55:48 2023-07-14 16:28:03 02:32:16  
#> 4 Other                       2023-07-14 17:01:16 2023-07-14 17:25:33 00:24:17  
#> 5 Other                       2023-07-14 17:25:44 2023-07-14 17:27:13 00:01:30  
#> 6 <NA>                        2023-07-14 17:27:16 NA                  <NA>
```

Wrangle the data with timetracker.

``` r
time <- timetracker::wrangle(raw)

tail(time)
#> # A tibble: 6 × 5
#>   date       case_ref_number  start_time          stop_time           difference
#>   <date>     <chr>            <dttm>              <dttm>              <drtn>    
#> 1 2023-07-14 TiltDevProjectM… 2023-07-14 10:10:28 2023-07-14 10:14:29 0.0668311…
#> 2 2023-07-14 TiltDevProjectM… 2023-07-14 10:14:31 2023-07-14 12:49:57 2.5903547…
#> 3 2023-07-14 TiltDevProjectM… 2023-07-14 12:49:59 2023-07-14 13:54:40 1.0780719…
#> 4 2023-07-14 TiltDevProjectM… 2023-07-14 13:55:48 2023-07-14 16:28:03 2.5377011…
#> 5 2023-07-14 Other            2023-07-14 17:01:16 2023-07-14 17:25:33 0.4048222…
#> 6 2023-07-14 Other            2023-07-14 17:25:44 2023-07-14 17:27:13 0.0248936…
```

Analyze the data with familiar tidyverse packages.

``` r
# Time spent by task in the last week
week <- 7
time |>
  filter(date == tail(unique(date), week)) |>
  summarise(spent = sum(difference), .by = c("case_ref_number", "date"))
#> # A tibble: 5 × 3
#>   case_ref_number                 date       spent           
#>   <chr>                           <date>     <drtn>          
#> 1 Meeting                         2023-07-13 0.66666667 hours
#> 2 Other                           2023-07-13 0.16576806 hours
#> 3 TiltDevProjectMGMT#115 estimate 2023-07-13 1.50000000 hours
#> 4 TiltDevProjectMGMT#115 estimate 2023-07-14 5.84217972 hours
#> 5 Other                           2023-07-14 0.02489361 hours

# Time spent across all tasks the last day
time |>
  filter(date == last(date)) |>
  summarise(spent = sum(difference), .by = "date")
#> # A tibble: 1 × 2
#>   date       spent         
#>   <date>     <drtn>        
#> 1 2023-07-14 7.429235 hours
```
