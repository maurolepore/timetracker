
<!-- README.md is generated from README.Rmd. Please edit that file -->

# tiltSprint

<!-- badges: start -->
<!-- badges: end -->

The goal of tiltSprint is to help you manage your tilt sprints.

## Installation

You can install the development version of tiltSprint with:

``` r
# install.packages("pak")
pak::pak("maurolepore/tiltSprint")
```

## Example

``` r
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
library(googlesheets4)
library(tiltSprint)
```

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
```

``` r
time <- raw |> 
  # Wrangle
  janitor::clean_names() |>
  # Pick done
  filter(!is.na(start_time), !is.na(stop_time)) |> 
  mutate(difference = make_difftime(stop_time - start_time, units = "hour")) |> 
  # Add date
  mutate(date = date(start_time))
time
#> # A tibble: 21 × 5
#>    case_ref_number start_time          stop_time           difference date      
#>    <chr>           <dttm>              <dttm>              <drtn>     <date>    
#>  1 Meeting         2023-07-13 05:00:00 2023-07-13 05:40:00 0.6666666… 2023-07-13
#>  2 Other           2023-07-13 05:40:00 2023-07-13 05:51:10 0.1861219… 2023-07-13
#>  3 Other           2023-07-13 05:53:23 2023-07-13 05:53:25 0.0004794… 2023-07-13
#>  4 Meeting         2023-07-13 07:31:11 2023-07-13 09:48:35 2.2900258… 2023-07-13
#>  5 Other           2023-07-13 10:04:58 2023-07-13 10:14:53 0.1652886… 2023-07-13
#>  6 TiltDevProject… 2023-07-13 10:52:17 2023-07-13 11:58:49 1.1088472… 2023-07-13
#>  7 TiltDevProject… 2023-07-13 14:00:00 2023-07-13 15:30:00 1.5000000… 2023-07-13
#>  8 TiltDevProject… 2023-07-13 16:12:42 2023-07-13 16:30:36 0.2981397… 2023-07-13
#>  9 TiltDevProject… 2023-07-14 06:07:39 2023-07-14 06:08:12 0.0091425… 2023-07-14
#> 10 TiltDevProject… 2023-07-14 06:08:14 2023-07-14 06:44:46 0.6089452… 2023-07-14
#> # ℹ 11 more rows
```

``` r
time |> 
  group_by(case_ref_number, date) |> 
  summarise(difference = sum(difference))
#> `summarise()` has grouped output by 'case_ref_number'. You can override using
#> the `.groups` argument.
#> # A tibble: 4 × 3
#> # Groups:   case_ref_number [3]
#>   case_ref_number                 date       difference     
#>   <chr>                           <date>     <drtn>         
#> 1 Meeting                         2023-07-13 2.9566925 hours
#> 2 Other                           2023-07-13 0.3518900 hours
#> 3 TiltDevProjectMGMT#115 estimate 2023-07-13 2.9069869 hours
#> 4 TiltDevProjectMGMT#115 estimate 2023-07-14 0.7933917 hours
```
