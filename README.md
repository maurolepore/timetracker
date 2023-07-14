
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
  mutate(date = date(start_time)) |> 
  relocate(date)
time
#> # A tibble: 21 × 5
#>    date       case_ref_number start_time          stop_time           difference
#>    <date>     <chr>           <dttm>              <dttm>              <drtn>    
#>  1 2023-07-13 Meeting         2023-07-13 05:00:00 2023-07-13 05:40:00 0.6666666…
#>  2 2023-07-13 Other           2023-07-13 05:40:00 2023-07-13 05:51:10 0.1861219…
#>  3 2023-07-13 Other           2023-07-13 05:53:23 2023-07-13 05:53:25 0.0004794…
#>  4 2023-07-13 Meeting         2023-07-13 07:31:11 2023-07-13 09:48:35 2.2900258…
#>  5 2023-07-13 Other           2023-07-13 10:04:58 2023-07-13 10:14:53 0.1652886…
#>  6 2023-07-13 TiltDevProject… 2023-07-13 10:52:17 2023-07-13 11:58:49 1.1088472…
#>  7 2023-07-13 TiltDevProject… 2023-07-13 14:00:00 2023-07-13 15:30:00 1.5000000…
#>  8 2023-07-13 TiltDevProject… 2023-07-13 16:12:42 2023-07-13 16:30:36 0.2981397…
#>  9 2023-07-14 TiltDevProject… 2023-07-14 06:07:39 2023-07-14 06:08:12 0.0091425…
#> 10 2023-07-14 TiltDevProject… 2023-07-14 06:08:14 2023-07-14 06:44:46 0.6089452…
#> # ℹ 11 more rows
```

``` r
time |> 
  group_by(case_ref_number) |> 
  summarise(difference = sum(difference))
#> # A tibble: 3 × 2
#>   case_ref_number                 difference    
#>   <chr>                           <drtn>        
#> 1 Meeting                         2.956692 hours
#> 2 Other                           0.351890 hours
#> 3 TiltDevProjectMGMT#115 estimate 3.700379 hours
```
