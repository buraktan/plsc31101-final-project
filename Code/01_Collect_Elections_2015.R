#The following code scrapes the website of Turkish Supreme Election Council and creates a dataframe with the votes Justice and Development Party won in each election district in June and November 2015.

#Load Packages
library(tidyverse)
library(rvest)
library(stringr)
library(purrr)
library(lubridate)
library(pdftools)

#Part 1: Creating a list of URLs or PDFs from the June and November election results pages

#Scraping the main election results page for election zones/pdf links

districts_vector <- c("Adana" , "Edirne" , "Kutahya" , "Usak" , "Adiyaman" , "Elazig" , "Malatya", "Van", "Afyonkarahisar", "Erzincan", "Manisa", "Yozgat", "Agri" ,"Erzurum" ,"Kahramanmaras", "Zonguldak", "Amasya", "Eskisehir", "Mardin", "Aksaray" ,"Ankara1", "Ankara2" ,"Gaziantep", "Mugla", "Bayburt", "Antalya" ,"Giresun", "Mus" ,"Karaman", "Artvin", "Gumushane", "Nevsehir", "Kirikkale", "Aydin", "Hakkari", "Nigde", "Batman", "Balikesir", "Hatay" ,"Ordu", "Sirnak", "Bilecik" ,"isparta" ,"Rize" ,"Bartin", "Bingol" ,"Mersin", "Sakarya", "Ardahan", "Bitlis", "istanbul1", "istanbul2", "istanbul3", "Samsun", "igdir" ,"Bolu", "izmir1" ,"izmir2", "Siirt" ,"Yalova" ,"Burdur" ,"Kars", "Sinop" ,"Karabuk" ,"Bursa", "Kastamonu", "Sivas" ,"Kilis" ,"Canakkale" ,"Kayseri" ,"Tekirdag", "Osmaniye", "Cankiri", "Kirklareli", "Tokat" ,"Duzce" ,"Corum", "Kirsehir" ,"Trabzon" ,"Denizli", "Kocaeli", "Tunceli", "Diyarbakir" ,"Konya" ,"Sanliurfa")

districts_df <- data.frame(
  Districts = districts_vector
)


#Creating the list of PDFs for the scraper function. There will be two links for two elections

#Election 1: June 7th, 2015
June_URLstart <- "http://www.ysk.gov.tr/doc/dosyalar/docs/Milletvekili/7Haziran2015/KesinSecimSonuclari/Cevre/"
June_URLend <-".pdf"
June_URLs <- str_c(June_URLstart , districts_vector , June_URLend)

#Election 2: June 7th, 2015
Nov_URLstart <- "http://www.ysk.gov.tr/doc/dosyalar/docs/Milletvekili/1Kasim2015/KesinSecimSonuclari/SecimCevresiSonuclari/"
Nov_URLend <- ".pdf"
Nov_URLs <- str_c(Nov_URLstart , districts_vector , Nov_URLend)


#Part 2: Creating a function to scrape local AKP vote counts of the PDFs

June_district_scraper <- function(i){
  pdf_text(i) %>%
    str_split( . , "ADALET VE KALKINMA PARTİSİ") %>%
    . [[1]] %>%
    . [2] %>%
    str_split( . , "\r\nDEMOKRATİK SOL PARTİ") %>%
    . [[1]] %>%
    . [1] %>%
    str_trim() %>%
    str_sub( . , 1, 10) %>%
    str_trim() %>%
    str_remove_all( . , ",") %>% 
    as.numeric()
}

Nov_district_scraper <- function(i){
  pdf_text(i) %>%
    str_split( . , "ADALET VE KALKINMA PARTİSİ") %>%
    . [[1]] %>%
    . [2] %>%
    str_split( . , "KOMÜNİST PARTİ") %>%
    . [[1]] %>%
    . [1] %>%
    str_trim() %>%
    str_sub( . , 1, 10) %>%
    str_trim() %>%
    str_remove_all( . , "\\.") %>%
    str_remove_all( . , ",") %>% 
    as.numeric()
}


# Part 3: Pass each URL into the respective function and create a dataframe

# June
results_June <- map(June_URLs, June_district_scraper)

results_June_unlisted <- unlist(results_June)

# November
results_Nov <- map(Nov_URLs, Nov_district_scraper)

results_Nov_unlisted <- unlist(results_Nov)


#Create a dataframe of the results and store as a CSV

AKP_Votes_2015 <- data.frame(
  District = districts_vector,
  June2015_votes = results_June_unlisted,
  Nov2015_votes = results_Nov_unlisted
)

write.csv(AKP_Votes_2015, file = "AKP_votes_2015.csv")