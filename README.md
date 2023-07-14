
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
library(googlesheets4)
library(timetracker)
library(tidyverse)
#> ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
#> ✔ dplyr     1.1.2     ✔ readr     2.1.4
#> ✔ forcats   1.0.0     ✔ stringr   1.5.0
#> ✔ ggplot2   3.4.2     ✔ tibble    3.2.1
#> ✔ lubridate 1.9.2     ✔ tidyr     1.3.0
#> ✔ purrr     1.0.1     
#> ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
#> ✖ dplyr::filter() masks stats::filter()
#> ✖ dplyr::lag()    masks stats::lag()
#> ℹ Use the conflicted package (<http://conflicted.r-lib.org/>) to force all conflicts to become errors
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
#> 1 TiltDevProjectMGMT#115 est… 2023-07-14 06:56:04 2023-07-14 06:56:07 00:00:03  
#> 2 TiltDevProjectMGMT#115 est… 2023-07-14 10:09:45 2023-07-14 10:09:49 00:00:04  
#> 3 TiltDevProjectMGMT#115 est… 2023-07-14 10:10:28 2023-07-14 10:14:29 00:04:01  
#> 4 TiltDevProjectMGMT#115 est… 2023-07-14 10:14:31 2023-07-14 12:49:57 02:35:25  
#> 5 TiltDevProjectMGMT#115 est… 2023-07-14 12:49:59 2023-07-14 13:54:40 01:04:41  
#> 6 TiltDevProjectMGMT#115 est… 2023-07-14 13:55:48 2023-07-14 16:28:03 02:32:16
```

Wrangle the data with timetracker.

``` r
time <- timetracker::wrangle(raw)

tail(time)
#> # A tibble: 6 × 5
#>   date       case_ref_number  start_time          stop_time           difference
#>   <date>     <chr>            <dttm>              <dttm>              <drtn>    
#> 1 2023-07-14 TiltDevProjectM… 2023-07-14 06:56:04 2023-07-14 06:56:07 0.0008505…
#> 2 2023-07-14 TiltDevProjectM… 2023-07-14 10:09:45 2023-07-14 10:09:49 0.0011566…
#> 3 2023-07-14 TiltDevProjectM… 2023-07-14 10:10:28 2023-07-14 10:14:29 0.0668311…
#> 4 2023-07-14 TiltDevProjectM… 2023-07-14 10:14:31 2023-07-14 12:49:57 2.5903547…
#> 5 2023-07-14 TiltDevProjectM… 2023-07-14 12:49:59 2023-07-14 13:54:40 1.0780719…
#> 6 2023-07-14 TiltDevProjectM… 2023-07-14 13:55:48 2023-07-14 16:28:03 2.5377011…
```

Analyze the data with familiar tidyverse packages.

``` r
# Time spent by task in the last week
week <- 7
time |>
  filter(date == tail(unique(date), week)) |> 
  summarise(spent = sum(difference), .by = c("case_ref_number"))
#> # A tibble: 3 × 2
#>   case_ref_number                 spent          
#>   <chr>                           <drtn>         
#> 1 Meeting                         0.6666667 hours
#> 2 Other                           0.1657681 hours
#> 3 TiltDevProjectMGMT#115 estimate 7.3421797 hours

# Time spent across all tasks today
time |>
  filter(date == today()) |> 
  summarise(spent = sum(difference), .by = "date")
#> # A tibble: 1 × 2
#>   date       spent         
#>   <date>     <drtn>        
#> 1 2023-07-14 6.999519 hours
```
