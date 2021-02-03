
library(remotes)
library(data.table)
library(ggplot2)
remotes::install_github("jplecavalier/tidynhl")
library(tidynhl)
library(scales)


merge_moved_teams <- function(dt) {
  
  dt[team_abbreviation %in% c("WPG", "ATL"), team_abbreviation := "WPG/ATL"]
  dt[team_abbreviation %in% c("PHX", "ARI"), team_abbreviation := "ARI/PHX"]
  
}


dt_draft <- tidy_draft(c(2005:2015), keep_id = TRUE)
dt_draft <- merge_moved_teams(dt_draft)
dt_draft <- dt_draft[!is.na(player_id),]

#dt_stats <- tidy_players_stats(unique(dt_draft$player_id), playoffs = FALSE, keep_id = TRUE)

# Petit correctifs

#fwrite(dt_stats, "content/blog/2021-02-01-tidynhl-analyse/dt_stats.csv")
dt_stats <- fread("content/blog/2021-02-01-tidynhl-analyse/dt_stats.csv")
dt_stats <- merge_moved_teams(dt_stats)


dt_stats_agg <- dt_stats[, .(total_pts = sum(skater_points), total_games = sum(skater_games)), by = .(player_id, team_played = team_abbreviation)]

dt_draft <- merge(dt_draft, dt_stats_agg, by= c("player_id"), all.x = TRUE)
dt_draft[, drafted_team := FALSE]
dt_draft[team_abbreviation == team_played, drafted_team := TRUE]

dt_stats_team <- dt_draft[, .(nb_games = sum(total_games, na.rm = TRUE), nb_points = sum(total_pts, na.rm = TRUE)), by = .(team_abbreviation, drafted_team)]

dt_stats_team2 <- dt_stats_team[,.(nb_games = sum(total_games, na.rm = TRUE), nb_points = sum(total_pts, na.rm = TRUE)), by = .(team_abbreviation)]
dt_stats_team2


# Drafted players games played --------------------------------------------


ggplot(
  data = dt_stats_team, 
  mapping = aes(
    x = reorder(as.factor(team_abbreviation), pts_per_game), 
    y = pts_per_game 
  )
) +
  geom_bar(stat = "identity") +
  scale_x_discrete("Équipe") +
  scale_y_continuous("Nombre de matchs joués dans la NHL") +
  coord_flip() +
  theme_classic()



# Points for players drafted ----------------------------------------------

test <- dt_draft[draft_round %in% c(6, 7), .(nb_games = sum(total_games, na.rm = TRUE), nb_points = sum(total_pts, na.rm = TRUE)), by = .(team_abbreviation, drafted_team)]
ggplot(
  data = dt_stats_team, 
  mapping = aes(
    x = nb_points, 
    y = reorder(as.factor(team_abbreviation), nb_points),
    fill = drafted_team
  )
) +
  geom_col() +
  scale_fill_discrete(
    name = "Équipe originale", 
    labels = c("TRUE" = "Oui","FALSE" = "Non")
  ) +
  theme_classic() +
  theme(axis.title.y = element_blank(),
        legend.position = "bottom") +
  labs(
    title = "Nombre de points réalisés pour les joueurs repêchés par équipe",
    subtitle = "Saisons 2005 à 2015 (saison régulière seulement)",
    x = "Nombre de points"
  )




# Number of picks ---------------------------------------------------------

dt_picks <- dt_draft[, .(nb_picks = .N, nb_1st_round_picks = uniqueN(.SD[draft_round == 1]$player_id)), by = .(team_abbreviation)]

ggplot(
  data = dt_picks,
  mapping = aes(
    x = nb_picks,
    y = reorder(as.factor(team_abbreviation), nb_picks), 
  )
) +
  geom_col() +
  geom_point(
    mapping = aes(
      x = nb_1st_round_picks,
      color = "Nombre de joueurs choisi en 1er ronde"
    )
  ) +
  scale_color_manual(name = "", values = c("Nombre de joueurs choisi en 1er ronde" = "red")) +
  theme_classic() +
  theme(axis.title.y = element_blank(),
        legend.position = "bottom") +
  labs(
    title = "Nombre de joueurs repêchés par équipe",
    subtitle = "Saisons 2005 à 2015",
    x = "Nombre de joueurs "
  )
