#The following script writes CSVs from NUTS and UCDP data

#Load Packages
library(tidyverse)
library(dplyr)
library(rvest)
library(stringr)
library(purrr)
library(lubridate)
library(pdftools)
library(stringi)

# Using the NUTS statistical regions of Turkey from European Union

NUTS2016 <- data.frame(
  
  District = c("istanbul1" , "istanbul2" , "istanbul3", "Tekirdag", "Edirne","Kirklareli", "Balikesir", "Canakkale", "izmir1",	"izmir2", "Aydin",	"Denizli","Mugla",	"Manisa",	"Afyonkarahisar", "Kutahya",	"Usak", "Bursa", "Eskisehir", "Bilecik",	"Kocaeli", "Sakarya",	"Duzce", "Bolu",	"Yalova", "Ankara1",	"Ankara2",	"Konya",	"Karaman", 	"Antalya", 	"isparta",	"Burdur",	"Adana",	"Mersin",	"Hatay",	"Kahramanmaras", "Osmaniye", "Kirikkale", "Aksaray",	"Nigde",	"Nevsehir",	"Kirsehir",	"Kayseri",	"Sivas",	"Yozgat", "Zonguldak",	"Karabuk",	"Bartin",	"Kastamonu",	"Cankiri",	"Sinop",	"Samsun",	"Tokat", "Corum", "Trabzon",	"Ordu",	"Giresun",	"Rize",	"Artvin",	"Gumushane", "Amasya", "Erzurum", 	"Erzincan", 	"Bayburt",  "Agri",	"Kars",	"igdir",	"Ardahan", "Malatya", "Elazig",	"Bingol",	"Tunceli",	"Van",	"Mus",	"Bitlis",	"Hakkari", "Gaziantep",	"Adiyaman",	"Kilis",	"Sanliurfa",	"Diyarbakir",	"Mardin",	"Batman", "Sirnak", "Siirt"),
  
  NUTS_Region = c("istanbul","istanbul","istanbul","Bati Marmara","Bati Marmara","Bati Marmara","Bati Marmara","Bati Marmara", "Ege", "Ege","Ege", "Ege" ,"Ege" ,"Ege" ,"Ege" ,"Ege" ,"Ege", "Dogu Marmara", "Dogu Marmara", "Dogu Marmara", "Dogu Marmara", "Dogu Marmara", "Dogu Marmara", "Dogu Marmara", "Dogu Marmara", "Bati Anadolu", "Bati Anadolu", "Bati Anadolu", "Bati Anadolu", "Akdeniz", "Akdeniz", "Akdeniz", "Akdeniz", "Akdeniz", "Akdeniz", "Akdeniz", "Akdeniz", "Orta Anadolu","Orta Anadolu","Orta Anadolu","Orta Anadolu","Orta Anadolu","Orta Anadolu","Orta Anadolu","Orta Anadolu", "Bati Karadeniz", "Bati Karadeniz", "Bati Karadeniz", "Bati Karadeniz", "Bati Karadeniz", "Bati Karadeniz", "Bati Karadeniz", "Bati Karadeniz", "Bati Karadeniz", "Bati Karadeniz", "Dogu Karadeniz", "Dogu Karadeniz", "Dogu Karadeniz", "Dogu Karadeniz", "Dogu Karadeniz", "Dogu Karadeniz", "Kuzeydogu Anadolu",	"Kuzeydogu Anadolu",	"Kuzeydogu Anadolu",	"Kuzeydogu Anadolu",	"Kuzeydogu Anadolu",	"Kuzeydogu Anadolu",	"Kuzeydogu Anadolu",	"Ortadogu Anadolu", "Ortadogu Anadolu", "Ortadogu Anadolu", "Ortadogu Anadolu", "Ortadogu Anadolu", "Ortadogu Anadolu", "Ortadogu Anadolu", "Ortadogu Anadolu", "Guneydogu Anadolu", "Guneydogu Anadolu", 	"Guneydogu Anadolu", 	"Guneydogu Anadolu", 	"Guneydogu Anadolu", 	"Guneydogu Anadolu", 	"Guneydogu Anadolu", 	"Guneydogu Anadolu", 	"Guneydogu Anadolu"),
  stringsAsFactors = F)

write.csv(NUTS2016, "NUTS_Regions_2016.csv", row.names = F)

#UCDP Georeferenced Event Dataset (GED) Global version 19.1

UCDP_GED <- read.csv("Data/ged191.csv", stringsAsFactors = F)

UCDP_GED_select <- UCDP_GED %>%
  filter(country == "Turkey",
         year == "2015",
         side_a == "Government of Turkey",
         date_start > "2015-06-06" & date_start < "2015-11-01",
         date_end > "2015-06-06" & date_end < "2015-11-01") %>%
  select("id","adm_1","best")

# Removing the word "province" and correcting city names in adm_1

UCDP_GED_select$adm_1 <- UCDP_GED_select$adm_1 %>%
  str_remove_all(., pattern = " province") %>%
  str_replace_all(., "Ä±", "i") %>%
  str_replace_all(., "ÄŸ", "g") %>%
  str_replace_all(., "Ä°", "i") %>%
  str_replace_all(., "ÅŸ", "s") %>%
  str_replace_all(., "Ã¶", "o") %>%
  str_replace_all(., "I", "i") %>%
  str_replace_all(., "Å", "S")

#Creating a smaller dataset with cities where military operations resulted in at least one death, calculating the percentage of casulties, removing empty rows after the calculation.

Death_byCity <- UCDP_GED_select %>%
  group_by(adm_1) %>%
  summarize("CityDeath" = sum(best)) %>%
  mutate("CityDeathPerc" = CityDeath/sum(CityDeath)) %>%
  filter(adm_1 != "") %>%
  select(adm_1 , CityDeathPerc)

names(Death_byCity) <- c("District" , "CityDeathPerc")


#Completing the Death_byCity data with districts where no death occurred

Other_cities <- data.frame(
  District = c("Tekirdag", "Edirne","Kirklareli", "Balikesir", "Canakkale", "izmir1",	"izmir2", "Aydin",	"Denizli","Mugla",	"Manisa",	"Afyonkarahisar", "Kutahya",	"Usak", "Bursa", "Eskisehir", "Bilecik",	"Kocaeli", "Sakarya",	"Duzce", "Bolu",	"Yalova", "Ankara1",	"Ankara2",	"Konya",	"Karaman", 	"Antalya", 	"isparta",	"Burdur",	"Mersin",	"Hatay",	"Kahramanmaras", "Kirikkale", "Aksaray",	"Nigde",	"Nevsehir",	"Kirsehir",	"Kayseri",	"Sivas",	"Yozgat", "Zonguldak",	"Karabuk",	"Bartin",	"Kastamonu",	"Cankiri",	"Sinop",	"Samsun",	"Tokat", "Corum", "Trabzon",	"Ordu",	"Giresun",	"Rize",	"Artvin",	"Gumushane", "Amasya", 	"Erzincan", 	"Bayburt",	"Ardahan", "Malatya", "Elazig"),
  CityDeathPerc = 0, stringsAsFactors = F
)

Death_byCity <- rbind(Death_byCity, Other_cities)

#Seperating the "istanbul" observation into three

Death_byCity <- Death_byCity %>%
  filter(District != "istanbul ") %>%
  filter(District != "istanbul")

istanbul_df <- data.frame(
  District = c("istanbul1" , "istanbul2" , "istanbul3"),
  CityDeathPerc = 0.011337868/3
)

Death_byCity <- rbind(Death_byCity, istanbul_df)

#Writing the CSV

write.csv(Death_byCity, file = "Death_byCity.csv", row.names = F)