# 2022 World Cup Data ----
# Goal: Compare team statistics vs average team age

# Step 1: Load Packages ----
## Needed Packages: tidyverse, knitr, rvest, kableExtra, readxl, janitor,
##                  dplyr, kableExtra, ggrepel, viridis
library(tidyverse)
library(knitr)
library(rvest)
library(kableExtra)
library(readxl)
library(janitor)
library(ggrepel)
library(viridis)

# Step 2: Load Data ----
worldCupRaw <- read_xlsx("/Users/riyadsouza/Downloads/worldCup.xlsx")

worldCupRaw <- read_xlsx("/Users/rythe/Downloads/worldCup2022.xlsx")

# Step 3: Tidy the dataset ----
worldCupClean <- worldCupRaw %>%
  
  clean_names() %>%
  
  filter(
    !is.na(squad),
    squad != "Squad",
    !str_detect(squad, "Playing")
  ) %>%
  
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
  ) %>%
  
  mutate(across(-squad, ~as.numeric(as.character(.)))) %>%
  drop_na(age, goals_plus_assists)

View(worldCupClean)

# Step 4: Create Plot 1 ----

ggplot(worldCupClean, aes(x = age, y = goals_plus_assists, color = squad)) +
  
  geom_point(size = 3) +
  
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  
  labs(
    title = "Age vs Performance",
    x = "Average Team Age",
    y = "Goals + Assists",
    color = "Team"
  ) +
  
  geom_text_repel(
    data = worldCupClean %>% slice_max(goals_plus_assists, n = 10),
    aes(label = squad),
    size = 4,
    max.overlaps = Inf
  ) +
  
  scale_color_viridis_d(option = "D") +
  
  theme_minimal()

ggsave("worldcup_plot.png", width = 8, height = 5)

# Step 4A: Create Table 1A ----

avg_perf <- mean(worldCupClean$goals_plus_assists)
avg_age <- mean(worldCupClean$age)

top_table <- worldCupClean %>%
  arrange(desc(goals_plus_assists)) %>%
  mutate(
    Rank = row_number(),
    Performance_vs_Avg = round(goals_plus_assists - avg_perf, 1),
    Age_vs_Avg = round(age - avg_age, 1),
  ) %>%
  select(
    Rank,
    Team = squad,
    Age = age,
    `Goals + Assists` = goals_plus_assists,
    `Performance vs Avg` = Performance_vs_Avg,
    `Age vs Avg` = Age_vs_Avg,
  )

kable(
  top_table,
  caption = "<span style='font-size:20px; font-weight:bold; color:black;'>Top World Cup Teams- Offensive Performance and Possession Compared to Average</span>",
  escape = FALSE
) %>%
  kable_styling(
    full_width = FALSE,
    position = "center",
    bootstrap_options = c("striped", "hover", "condensed")
  )

write.csv(top_table, "worldcup_table.csv", row.names = FALSE)

##Step 4B: Create Table 1B ----

corr <- cor(worldCupClean$age, worldCupClean$goals_plus_assists, use = "complete.obs")

model <- lm(goals_plus_assists ~ age, data = worldCupClean)

simple_table <- data.frame(
  Metric = c("Average Age", 
             "Average Goals + Assists", 
             "Correlation (Age vs Performance)", 
             "Slope (Age Effect)"),
  
  Value = c(round(avg_age, 2),
            round(avg_perf, 2),
            round(corr, 2),
            round(coef(model)[2], 2))
)

kable(
  simple_table,
  caption = "Impact of Age on Offensive Performance",
) %>%
  kable_styling(
    full_width = FALSE,
    position = "center",
    bootstrap_options = c("striped", "hover", "condensed")
  )

# Step 5: Create Plot 2 ----

ggplot(worldCupClean, aes(x = poss, y = goals_plus_assists, color = squad)) +
  geom_point(size = 3) +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  labs(
    title = "Possession vs Performance",
    x = "Possession Percentage",
    y = "Goals + Assists",
    color = "Team"
  ) +
  geom_text_repel(
    data = worldCupClean %>% slice_max(goals_plus_assists, n = 10),
    aes(label = squad),
    size = 4,
    max.overlaps = Inf
  ) +
  scale_color_viridis_d(option = "D") +
  theme_minimal()

# Step 5A: Create Table 2A ----

avg_perf <- mean(worldCupClean$goals_plus_assists)
avg_poss <- mean(worldCupClean$poss)

top_table <- worldCupClean %>%
  arrange(desc(goals_plus_assists)) %>%
  mutate(
    Rank = row_number(),
    Performance_vs_Avg = round(goals_plus_assists - avg_perf, 1),
    Poss_vs_Avg = round(poss - avg_poss, 1),
  ) %>%
  select(
    Rank,
    Team = squad,
    Possession = poss,
    `Goals + Assists` = goals_plus_assists,
    `Performance vs Avg` = Performance_vs_Avg,
    `Possession vs Avg` = Poss_vs_Avg,
  )

kable(
  top_table,
  caption = "<span style='font-size:20px; font-weight:bold; color:black;'>Offensive Performance Compared to Possession Percentage</span>",
  escape = FALSE
) %>%
  kable_styling(
    full_width = FALSE,
    position = "center",
    bootstrap_options = c("striped", "hover", "condensed")
  )

write.csv(top_table, "worldcup_table.csv", row.names = FALSE)

##Step 5B: Create Table 2B ----

corr <- cor(worldCupClean$poss, worldCupClean$goals_plus_assists)

model <- lm(goals_plus_assists ~ poss, data = worldCupClean)

simple_table <- data.frame(
  Metric = c("Average Possession", 
             "Average Goals + Assists", 
             "Correlation (Possession vs Performance)", 
             "Slope (Possession Effect)"),
  
  Value = c(round(avg_poss, 2),
            round(avg_perf, 2),
            round(corr, 2),
            round(coef(model)[2], 2))
)

kable(
  simple_table,
  caption = "Impact of Age on Offensive Performance",
) %>%
  kable_styling(
    full_width = FALSE,
    position = "center",
    bootstrap_options = c("striped", "hover", "condensed")
  )

# Step 6: Create Plot 3 ----

ggplot(worldCupClean, aes(x = players, y = goals_plus_assists, color = squad)) +
  geom_point(size = 3) +
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  labs(
    title = "Number of Players vs Performance",
    x = "Number of Players",
    y = "Goals + Assists",
    color = "Team"
  ) +
  geom_text_repel(
    data = worldCupClean %>% slice_max(goals_plus_assists, n = 10),
    aes(label = squad),
    size = 4,
    max.overlaps = Inf
  ) +
  scale_color_viridis_d(option = "D") +
  theme_minimal()

# Step 5A: Create Table 3A ----

avg_perf <- mean(worldCupClean$goals_plus_assists)
avg_players <- mean(worldCupClean$players)

top_table <- worldCupClean %>%
  arrange(desc(goals_plus_assists)) %>%
  mutate(
    Rank = row_number(),
    Performance_vs_Avg = round(goals_plus_assists - avg_perf, 1),
    Players_vs_Avg = round(players - avg_players, 1),
  ) %>%
  select(
    Rank,
    Team = squad,
    Players = players,
    `Goals + Assists` = goals_plus_assists,
    `Performance vs Avg` = Performance_vs_Avg,
    `Players vs Avg` = Players_vs_Avg,
  )

kable(
  top_table,
  caption = "<span style='font-size:20px; font-weight:bold; color:black;'>Offensive Performance Compared to Number of Players</span>",
  escape = FALSE
) %>%
  kable_styling(
    full_width = FALSE,
    position = "center",
    bootstrap_options = c("striped", "hover", "condensed")
  )

kable(top_table)

write.csv(top_table, "worldcup_table.csv", row.names = FALSE)

##Step 5B: Create Table 3B ----

corr <- cor(worldCupClean$players, worldCupClean$goals_plus_assists)

model <- lm(goals_plus_assists ~ players, data = worldCupClean)

simple_table <- data.frame(
  Metric = c("Average Number of Players", 
             "Average Goals + Assists", 
             "Correlation (Number of Players vs Performance)", 
             "Slope (Number of Players Effect)"),
  
  Value = c(round(avg_players, 2),
            round(avg_perf, 2),
            round(corr, 2),
            round(coef(model)[2], 2))
)

kable(
  simple_table,
  caption = "Impact of The Number of Players on Offensive Performance",
) %>%
  kable_styling(
    full_width = FALSE,
    position = "center",
    bootstrap_options = c("striped", "hover", "condensed")
  )