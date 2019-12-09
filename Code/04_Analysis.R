# This script produces several plots and a regression table.

#Reading the dataset and loading packages

fin_dat <- read.csv("Data/Final_Dataset.csv", stringsAsFactors = F)

library(ggplot2)
library(tidyverse)
library(stargazer)

#A Descriptive Chart: Percentage Change in AKP Votes by District
fin_dat0 <- fin_dat %>%
  group_by(NUTS_Region) %>% 
  mutate(Reg_MeanVote = mean(VotePercDiff)) %>%
  arrange(desc(Nov2015_votes))

plot_0 <- ggplot(data = fin_dat0, aes(x=VotePercDiff)) + 
  geom_histogram(binwidth = 0.06, fill="#990033") +
  xlim(0 , 0.6) +
  xlab("District's Change in Votes") +
  ylab("District Count") +
  ggtitle("Percentage Change in AKP Votes by District")

ggsave(filename = "plot_0.jpeg", plot=plot_0, scale=1, h=7, w=7, device = "jpeg")

#Plot_1: Change in Votes by Region
fin_dat1 <- fin_dat %>%
  group_by(NUTS_Region) %>% 
  mutate(Reg_MeanVote = mean(VotePercDiff)) %>%
  arrange(desc(Reg_MeanVote))

plot_1 <- ggplot(data = fin_dat1, aes(x = VotePercDiff, y = NUTS_Region)) + 
  geom_point() +
  geom_line() +
  xlab("Percentage Difference in AKP Votes") +
  ylab("Region") +
  ggtitle("Change in Votes by Region") +
  xlim(0, 0.75)

ggsave(filename = "plot_1.jpeg", plot=plot_1, scale=1, h=7, w=7, device = "jpeg")

#Plot_2: Distribution of Wartime Deaths by Region, between June-November 2015
fin_dat2 <- fin_dat %>%
  group_by(NUTS_Region) %>% 
  mutate(Reg_MeanDeath = mean(CityDeathPerc)) %>%
  arrange(desc(Reg_MeanDeath))

plot_2 <- ggplot(fin_dat2, aes(x = reorder(NUTS_Region, Reg_MeanDeath), y = Reg_MeanDeath)) +
  geom_col(fill="#990033") +
  xlab("Region") +
  ylab("Percentage Share of Casulties") +
  ggtitle("Dsitribution of Wartime Deaths by Region, between June-November 2015") +
  theme(axis.text.x = element_text(size = 8, angle=45, hjust = 1), axis.text.y = element_text(size = 8))

ggsave(filename = "plot_2.jpeg", plot=plot_2, scale=1, h=7, w=7, device = "jpeg")

#Plot_3: Increase in AKP Votes by Region's Share of Wartime Casulties
fin_dat3 <- fin_dat %>%
  group_by(NUTS_Region) %>% 
  mutate(Reg_MeanVote = mean(VotePercDiff)) %>%
  mutate(Reg_MeanDeath = mean(CityDeathPerc)) %>%
  arrange(desc(VotePercDiff))

plot_3 <- ggplot(data = fin_dat3, aes(x = Reg_MeanDeath, y = VotePercDiff, color=NUTS_Region)) + 
  geom_point() +
  geom_line() +
  xlab("Mean of Percentage Death by Region") +
  ylab("Increase in AKP Votes") +
  ggtitle("Increase in AKP Votes by Region's Share of Wartime Casulties") +
  ylim(0, 0.56) +
  xlim(0, 0.08)

ggsave(filename = "plot_3.jpeg", plot=plot_3, scale=1, h=5, w=7, device = "jpeg")

#Plot_4: Share of Deaths by District and Percentage Increase in AKP Votes
plot_4 <- ggplot(data = fin_dat3, aes(x = CityDeathPerc, y = VotePercDiff)) + 
  geom_point(color="#660033") + 
  xlab("Percentage Share of Deaths by District") +
  ylab("Percentage Increase in AKP Votes") +
  ggtitle("Share of Deaths by District and Percentage Increase in AKP Votes") +
  geom_smooth(method = lm, color="#990000", fill="#FF0033")

ggsave(filename = "plot_4.jpeg", plot=plot_4, scale=1, h=7, w=7, device = "jpeg")

#Plot_5: Share of Deaths by District and Percentage Increase in AKP Votes (Logged)
plot_5 <- ggplot(data = fin_dat3, aes(x = CityDeathPerc, y = VotePercDiff)) + 
  geom_point(color="#660033") + 
  scale_x_log10() +
  xlab("Percentage Share of Deaths by District") +
  ylab("Percentage Increase in AKP Votes") +
  ggtitle("Share of Deaths by District and Percentage Increase in AKP Votes (Logged)") +
  geom_smooth(method = lm, color="#990000", fill="#FF0033")

ggsave(filename = "plot_5.jpeg", plot=plot_5, scale=1, h=7, w=7, device = "jpeg")

#Regression Results

mod_1 <- lm(VotePercDiff ~ CityDeathPerc, data = fin_dat3)
mod_2 <- lm(VotePercDiff ~ CityDeathPerc + Reg_MeanDeath, data = fin_dat3)
mod_3 <- lm(VotePercDiff ~ CityDeathPerc + Reg_MeanDeath + NUTS_Region, data = fin_dat3)

Regression <- stargazer(mod_1, mod_2, mod_3,
                        title = "Regression Results" , type = "text",
                        covariate.labels = c("District's Share of Deaths", "Region's Share of Deaths", "West Anatolia" , "West Black Sea" , "West Marmara" , "East Black Sea" , "East Marmara" , "Aegean" , "SouthEast Anatolia" , "Istanbul" , "NorthEast Anatolia" , "Central Anatolia" , "CentralEast Anatolia"),
                        dep.var.labels = "Percentage Increase in AKP Votes",
                        keep.stat="n", omit = "Constant", style = "ajps",
                        out = "regression_table.txt")