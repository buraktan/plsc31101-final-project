#The following script reads the data and merges into the final dataset

#Loading Packages
library(tidyverse)

#Reading the CSVs created
AKP_votes2015 <- read.csv("Data/AKP_votes_2015.csv" , stringsAsFactors = F)
NUTS <- read.csv("Data/NUTS_Regions_2016.csv" , stringsAsFactors = F)
Death_byCity <- read.csv("Data/Death_byCity.csv" , stringsAsFactors = F)

#Merging the CSVs and preparing the final dataset for analysis
Final_Dataset <- left_join(AKP_votes2015, NUTS, by = "District")
Final_Dataset <- left_join(Final_Dataset, Death_byCity, by = "District")

Final_Dataset <- Final_Dataset %>%
  .[order(Final_Dataset$District),] %>%
  mutate(VotePercDiff = (Nov2015_votes - June2015_votes)/June2015_votes) %>%
  select(c(2,5,6,3,4,7))

write.csv(Final_Dataset, "Final_Dataset.csv" , row.names = F)