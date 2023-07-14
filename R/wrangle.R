#' Wrangle "Time Tracker" data
#'
#' @param data A data frame as produced with "Time Tracker".
#'
#' @return A data frame.
#' @export
#'
#' @examples
#' # wrangle(googlesheets4::read_sheet("your/url"))
wrangle <- function(data) {
  data |>
    clean_names() |>
    filter(!is.na(start_time), !is.na(stop_time)) |>
    mutate(difference = make_difftime(stop_time - start_time, units = "hour")) |>
    mutate(date = date(start_time)) |>
    relocate(date)
}
