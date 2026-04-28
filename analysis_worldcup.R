# 2022 World Cup Data ----
# Goal: Compare team statistics vs average team age

# Step 1: Load Packages ----
library(tidyverse)
library(knitr)
library(rvest)
library(kableExtra)
library(readxl)
library(janitor)

# Step 2: Load Data ----
worldCupRaw <- read_xlsx("/Users/riyadsouza/Downloads/worldCup.xlsx")

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

# Step 4: Create a Plot ----
ggplot(worldCupClean, aes(x = age, y = goals_plus_assists, color = poss)) +
  
  geom_point(size = 3) +
  
  geom_smooth(method = "lm", se = FALSE, color = "black") +
  
  scale_color_gradient(low = "lightblue", high = "darkblue") +
  
  labs(
    title = "Age vs Performance",
    subtitle = "Darker color indicates higher possession",
    x = "Average Team Age",
    y = "Goals + Assists",
    color = "Possession Percentage"
  ) +
  
  geom_text(
    data = worldCupClean %>% top_n(5, goals_plus_assists),
    aes(label = squad),
    vjust = -1,
    size = 4
  )
  
  theme_minimal()
  
  ggsave("worldcup_plot.png", width = 8, height = 5)
  
  # Step 4: Create a Table ----
  
  library(dplyr)
  library(knitr)
  
  avg_perf <- mean(worldCupClean$goals_plus_assists)
  avg_poss <- mean(worldCupClean$poss)
  
  top_table <- worldCupClean %>%
    arrange(desc(goals_plus_assists)) %>%
    slice(1:6) %>%
    mutate(
      Rank = row_number(),
      Performance_vs_Avg = round(goals_plus_assists - avg_perf, 1),
      Possession_vs_Avg = round(poss - avg_poss, 1)
    ) %>%
    select(
      Rank,
      Team = squad,
      Age = age,
      `Goals + Assists` = goals_plus_assists,
      `Performance vs Avg` = Performance_vs_Avg,
      `Possession vs Avg` = Possession_vs_Avg
    )
  
  library(kableExtra)
  
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
  
  kable(top_table)
  
  write.csv(top_table, "worldcup_table.csv", row.names = FALSE)