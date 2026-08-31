library(tidyverse)
library(ggplot2)

##pollster error graph
combined_polls <- read.csv(file = "pollster error graph/combined_polls.csv")

##removing undecided responses (have no corollary to election results)
combined_polls_other <- filter(combined_polls, party_simplified %in% c("DEMOCRAT", "REPUBLICAN", "OTHER"))

##create new column variable of error between pollster results and election result
combined_polls_error <- mutate(combined_polls_other, error = abs(election_pct - pct))


##number of polls per pollster
state_polls_combined_clean <- read_csv(file = "data/clean/state_polls_combined_clean.csv")

state_polls_combined <- mutate(state_polls_combined_clean, count = 1 )

count <- state_polls_combined|>
  group_by(pollster) |>
  summarise(across(c(count), sum))

##number of polls per pollster
ggplot(state_polls_combined, aes(y = pollster)) +
  geom_bar()

##remove all na entries
combined_polls_error <- filter(combined_polls_error, !is.na(error))

##average error by pollster
pollster_error <- combined_polls_error |>
  group_by(pollster) |>
  summarise(across(c(error), mean))

pollster_error <- mutate(pollster_error, error = round(error, digit = 2))

pollster_error <- left_join(pollster_error, count, by = join_by(pollster))

##pollsters involved in <100 polls, error = abs(election% - pollster%)
##5 most prolific pollsters
pollster_error_100 <- filter(pollster_error, count >= 100 )

ggplot(pollster_error_100, aes(x = error, y = pollster)) +
  geom_col() +
  geom_text(aes(label = error), nudge_x = -.2, size = 3, colour = "white", fontface = "bold") +
  labs(title = "Polling accurary by pollster", 
       x = "Mean absolute polling error (percentage)", 
       y = "Pollster")
