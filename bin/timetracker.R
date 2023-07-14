library(dplyr, warn.conflicts = FALSE)
library(googlesheets4)
library(timetracker)

url <- "https://docs.google.com/spreadsheets/d/1Pz9_Dn24DPpWpEXFggSwZJWSp0DHtYbgpeS1_90KtEA/edit?usp=sharing"
raw <- read_sheet(url) |> suppressMessages()
time <- wrangle(raw)

week <- 7
by_task <- time |>
  filter(date == tail(unique(date), week)) |>
  summarise(spent = sum(difference), .by = c("case_ref_number", "date"))
message(toupper("Each task, last week"))
by_task

message("")
message(toupper("All tasks, last day"))
time |>
  filter(date == last(date)) |>
  summarise(spent = sum(difference), .by = "date")
