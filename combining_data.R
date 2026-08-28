##X1976_2024_president data cleaning??

library(tidyverse)
library(here)

clean_dir <- here("data", "clean")
dir.create(clean_dir, recursive = TRUE, showWarnings = FALSE)

##import data sets
X1976_2024_president <- read.csv(file = "data/raw/1976-2024-president.csv")
state_polls_combined_long <- read.csv(file = "data/clean/state_polls_combined_long.csv")

##working w/ election data

##isolate 2012, 2016 elections (remove 1976 - 2008 (rows 1 - 3079), 2020-2024 (rows 3741-4822))
president_2012_2016 <- filter(X1976_2024_president, year %in% c(2012, 2016))

##simplify data set by removing duplicate information 
##and columns that contain the same number for the whole data set
president_2012_2016_simple <- select(president_2012_2016, -c("party_detailed", "office", "state_po", "state_fips", "state_cen", "state_ic", "notes", "version"))

##add a column that displays percentage of votes for candidate
president_2012_2016_simple_pct <- mutate(president_2012_2016_simple, election_pct = round(candidatevotes/totalvotes, digits = 4)*100)

##party_simplified: - libertarians become OTHER
president_2012_2016_simple <- mutate(president_2012_2016_simple, party_simplified = str_replace_all(party_simplified, "LIBERTARIAN", "OTHER"))

##combine all OTHER entries into a singular entry per state
result <- president_2012_2016_simple |>
  group_by(year, state, party_simplified, totalvotes) |>
  summarise(across(c(candidatevotes), sum))

##add column of percentages
result_pct <- mutate(result, election_pct = round(candidatevotes/totalvotes, digits = 4)*100)

##working w/ pollster data

##state: removing hyphens, and washington-dc == district of columbia
Xstate_polls_combined_long <- mutate(state_polls_combined_long, state = str_replace_all(state, "washington-dc", "district of columbia"))
Xstate_polls_combined_long <- mutate(Xstate_polls_combined_long, state = str_replace_all(state, "new-hampshire", "new hampshire"))
Xstate_polls_combined_long <- mutate(Xstate_polls_combined_long, state = str_replace_all(state, "new-jersey", "new jersey"))
Xstate_polls_combined_long <- mutate(Xstate_polls_combined_long, state = str_replace_all(state, "new-mexico", "new mexico"))
Xstate_polls_combined_long <- mutate(Xstate_polls_combined_long, state = str_replace_all(state, "new-york", "new york"))
Xstate_polls_combined_long <- mutate(Xstate_polls_combined_long, state = str_replace_all(state, "north-carolina", "north carolina"))
Xstate_polls_combined_long <- mutate(Xstate_polls_combined_long, state = str_replace_all(state, "north-dakota", "north dakota"))
Xstate_polls_combined_long <- mutate(Xstate_polls_combined_long, state = str_replace_all(state, "rhode-island", "rhode island"))
Xstate_polls_combined_long <- mutate(Xstate_polls_combined_long, state = str_replace_all(state, "south-carolina", "south carolina"))
Xstate_polls_combined_long <- mutate(Xstate_polls_combined_long, state = str_replace_all(state, "south-dakota", "south dakota"))
Xstate_polls_combined_long <- mutate(Xstate_polls_combined_long, state = str_replace_all(state, "west-virginia", "west virginia"))

##columns needing capitalisation (state, party_group)
caps_state_polls_combined_long <- mutate(Xstate_polls_combined_long, state = str_to_upper(state))
caps_state_polls_combined_long <- mutate(caps_state_polls_combined_long, party_group = str_to_upper(party_group))

##rename party_group column to party_simplified
caps_state_polls_combined_long <- rename(caps_state_polls_combined_long, party_simplified = party_group)

##creating a combined dataframe
combined_polls <-left_join(caps_state_polls_combined_long, result_pct, relationship =
                       "many-to-many", by = join_by(year, state, party_simplified))

##write .csv
write_csv(combined_polls, file.path(clean_dir, "combined_polls.csv"))

