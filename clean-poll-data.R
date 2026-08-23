# Master script for poll cleaning
# This will serve as a fully reproducible record of the steps taken from raw data to clean data.
# You can have a separate file for the subsequent EDA of polling data.
# 1. Setup 

library(tidyverse)
library(here)

raw_dir <- here("data", "raw")
clean_dir <- here("data", "clean")
dir.create(clean_dir, recursive = TRUE, showWarnings = FALSE)

election_day <- c(
  "2012" = as.Date("2012-11-06"),
  "2016" = as.Date("2016-11-08")
)

candidate_cols_2012 <- c("Obama", "Romney", "Undecided", "Other")
candidate_cols_2016 <- c("Trump", "Clinton", "Johnson",
                         "McMullin", "Other", "Undecided")

# 2. Import raw data 

polls_2012_raw <- read_csv(file.path(raw_dir, "state_polls_2012.csv"))
polls_2016_raw <- read_csv(file.path(raw_dir, "state_polls_2016.csv"))

glimpse(polls_2012_raw)

# 3. Clean poll-level data

clean_poll_data <- function(data, election_year) {
  data |>
    extract(
      poll_info,
      into = c("year", "state", "contest"),
      regex = "^(\\d{4})-(.*?)-(president|presidential-general-election)-.*$",
      remove = FALSE
    ) |>
    mutate(
      # Standardise identifiers and dates.
      year = as.integer(year),
      state = str_replace(state, "^washington-d-c$", "washington-dc"),
      poll_id = as.character(poll_id),
      start_date = as.Date(start_date),
      end_date = as.Date(end_date),
      days_to_election = as.integer(
        election_day[as.character(election_year)] - end_date
      ),
      
      # Recode known non-response / sentinel values.
      sample_size = as.integer(na_if(sample_size, -1)),
      Other = as.numeric(na_if(Other, "Not included in poll")),
      
      # NA is not applicable for nonpartisan polls, so label it explicitly.
      partisan_affiliation = case_when(
        partisanship == "Nonpartisan" & is.na(partisan_affiliation) ~ "None",
        TRUE ~ partisan_affiliation
      ),
      
      # poll_id can repeat across states; this identifies one state-poll.
      poll_key = str_c(year, poll_id, state, sep = "_")
    ) |>
    select(-contest)
}

polls_2012_clean <- clean_poll_data(polls_2012_raw, 2012)
polls_2016_clean <- clean_poll_data(polls_2016_raw, 2016)


# 4. Reshape to long format

polls_2012_long <- polls_2012_clean |>
  pivot_longer(
    cols = all_of(candidate_cols_2012),
    names_to = "candidate",
    values_to = "pct"
  ) |>
  mutate(
    party_group = case_when(
      candidate == "Obama" ~ "Democrat",
      candidate == "Romney" ~ "Republican",
      candidate == "Undecided" ~ "Undecided",
      TRUE ~ "Other"
    )
  )

polls_2016_long <- polls_2016_clean |>
  pivot_longer(
    cols = all_of(candidate_cols_2016),
    names_to = "candidate",
    values_to = "pct"
  ) |>
  mutate(
    party_group = case_when(
      candidate == "Clinton" ~ "Democrat",
      candidate == "Trump" ~ "Republican",
      candidate == "Undecided" ~ "Undecided",
      TRUE ~ "Other"
    )
  )


# 5. Validate cleaning

# State extraction should succeed for every row.
stopifnot(
  !anyNA(polls_2012_clean$state),
  !anyNA(polls_2016_clean$state)
)

# Each state-poll key should be unique in the wide data.
stopifnot(
  !anyDuplicated(polls_2012_clean$poll_key),
  !anyDuplicated(polls_2016_clean$poll_key)
)

# Reported candidate percentages must be between 0 and 100.
stopifnot(
  all(is.na(polls_2012_long$pct) |
        between(polls_2012_long$pct, 0, 100)),
  all(is.na(polls_2016_long$pct) |
        between(polls_2016_long$pct, 0, 100))
)

# Flag unusual totals for review; do not automatically delete them.
unusual_totals <- bind_rows(
  polls_2012_clean |>
    mutate(
      reported_total = rowSums(
        across(all_of(candidate_cols_2012)),
        na.rm = TRUE
      )
    ),
  polls_2016_clean |>
    mutate(
      reported_total = rowSums(
        across(all_of(candidate_cols_2016)),
        na.rm = TRUE
      )
    )
) |>
  filter(reported_total > 102) |>
  select(year, poll_key, poll_info, reported_total)


# 6. Combine 2012 and 2016

# Wide: one row per state-poll; use for poll counts, timing and coverage.
polls_clean <- bind_rows(
  polls_2012_clean,
  polls_2016_clean
)

# Long: one row per state-poll-candidate; use for candidate-level analysis.
polls_long <- bind_rows(
  polls_2012_long,
  polls_2016_long
)


# 7. Save clean datasets

write_csv(
  polls_2012_clean,
  file.path(clean_dir, "state_polls_2012_clean.csv")
)

write_csv(
  polls_2016_clean,
  file.path(clean_dir, "state_polls_2016_clean.csv")
)

write_csv(
  polls_clean,
  file.path(clean_dir, "state_polls_combined_clean.csv")
)

write_csv(
  polls_long,
  file.path(clean_dir, "state_polls_combined_long.csv")
)

#Check the result dataset:
glimpse(result_1976_2024_raw)
# Missing values
result_1976_2024_raw |>
  summarise(across(everything(), ~ sum(is.na(.))))

# Exact duplicates
sum(duplicated(result_1976_2024_raw))

# Years available
sort(unique(result_1976_2024_raw$year))

# Party categories
unique(result_1976_2024_raw$party_simplified)
