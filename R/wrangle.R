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
    filter(!is.na(.data$start_time), !is.na(.data$stop_time)) |>
    mutate(difference = make_difftime(
        .data$stop_time - .data$start_time, units = "hour"
    )) |>
    mutate(date = date(.data$start_time)) |>
    relocate("date")
}
