# 2022 World Cup Data ----
## Get data from the 2022 World Cup and create plots showing statistics by
## team vs average team age

# Step 1: Load Packages ----
## Needed Packages: tidyverse, knitr, rvest, kableExtra, readxl
install.packages("readxl")
install.packages("gt")
library(tidyverse)
library(knitr)
library(rvest)
library(kableExtra)
library(readxl)
library(janitor)
library(dplyr)
library(gt)
library(ggplot2)
# Step 2: Load Data ----
## Needed data: World Cup Team Data

worldCupRaw <- read_xlsx(
  path = "Group project/worldCup2022.xlsx"
  )

View(worldCupRaw)
# Step 3: Tidy the data ----
worldCupClean <- worldCupRaw |>
  
  clean_names() |>
  
  filter(
    !is.na(squad),
    squad != "Squad",
    !str_detect(squad, "Playing")
  ) |>
  
  select(
    squad,
    players = number_pl,
    age,
    poss,
    matches_played = mp,
    starts,
    minutes = min,
    nineties = x90s,
    goals = gls_9,
    assists = ast_10,
    goals_plus_assists = g_a_11,
    goals_no_pk = g_pk_12,
    pk,
    pkatt = p_katt,
    yellow_cards = crd_y,
    red_cards = crd_r
  )
  
# Step 4: Make a plot ----
top8 <- worldCupClean |>
  filter(matches_played >= 5) |>
  mutate(
    goals = as.numeric(goals),
    matches_played = as.numeric(matches_played),
    age = as.numeric(age),
    avg_goals = goals / matches_played
  )

ggplot(top8, aes(x = age, y = avg_goals, color = squad)) +
  geom_point(size = 4) +
  labs(
    title = "Average Goals vs Age for Top 8 Teams",
    x = "Average Age",
    y = "Goals per Match",
    color = "Country"
  ) +
  theme_minimal()
## Step 4A: Make a table ----
top8 |>
  mutate(Rank = row_number()) |>
  select(Rank, squad, age, avg_goals) |>
  gt() |>
  cols_label(
    squad = "Team",
    age = "Age",
    avg_goals = "Goals per Match"
  ) |>
  tab_header(
    title = "Top 8 World Cup Teams - Average Goals Performance"
  ) |>
  fmt_number(
    columns = c(age, avg_goals),
    decimals = 2
  ) |>
  cols_align(align = "center") |>
  opt_row_striping()