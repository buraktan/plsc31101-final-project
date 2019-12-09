

## Short Description

This project evaluates whether there is a relation between the local effects of state violence in Turkey and the increase of votes ruling party enjoyed between the elections of June and November 2015.

The first part of the code scrapes the website of the Turkish Supreme Election Council to collect the change in the votes of the ruling Justice and Development Party (AKP) between the June 2015 and November 2015 elections. The months between the June election and the November re-election coincide with the resurgance of the Kurdish civil war in Turkey after an three year substantial peace process, which predominantly affected the Eastern and Souteastern regions of the country. Hence, the second part of the code uses region classifications from the NUTS data and UCDP localized battle related death data as dependent variables.

Results indicate that there is a significant relation between the geography that was affected from the military operations and the regions in which the election results changed for the favor of the ruling Justice and Development Party.

## Dependencies

The code depends on the following software:

1. R, 3.6.1 Version 1.2.5001

## Files

#### /

1. Narrative.Rmd: Provides a 3-5 page narrative of the project, main challenges, solutions, and results.
2. Narrative.pdf: A knitted pdf of 00_Narrative.Rmd. 
3. Slides.pptx: Lightning talk slides.
4. README.md: Readme
5. Comp_Final_Project.Rproj: Complete R Project

#### Code/
1. 01_Collect_Elections.R: Collects and cleans data from the website of the Turkish Election Council, writes the dataset "AKP_votes_2015.csv"
2. 02_Collect_UCDP_NUTS.R: Uses the "NUTS2016-NUTS2021.xlxs" data from the Data directory, filters the relevant information and writes the "NUTS_Regions_2016.csv". Also loads and cleans data from the "Data/ged191.csv" data of UCDP, and writes the dataset "Death_byCity.csv"
3. 03_Merge_Data.R: Loads and merges the three datasets produced into the Final Dataset and writes "Final_Dataset.csv"
4. 04_Analysis.R: Loads the "Final_Dataset.csv" and conducts descriptive analysis of the data, producing the tables and visualizations found in the Results directory

#### Data/

1. Districts.csv: Contains dataframe of election districts coded manually based on the PDF, 
http://www.ysk.gov.tr/doc/dosyalar/docs/Milletvekili/7Haziran2015/2015MV-SecimCevreleri.pdf
2. AKP_Votes_2015.csv: Contains data from the website of the Turkish Election Council, collected via 'pdf_text' function. Includes information on votes AKP got in each district on June 2015 and November 2015. All PDFs available through: http://www.ysk.gov.tr/tr
3. ged.191.csv: UCDP Georeferenced Event Dataset (GED) Global version 19.1, available here: 
https://ucdp.uu.se/downloads/
4. Death_byCity.csv: Cleaned data from the UCDP dataset.
5. NUTS2016-NUTS2021.xlsx: European Union's NUTS regional classification dataset, available here: https://ec.europa.eu/eurostat/documents/345175/629341/NUTS2016-NUTS2021.xlsx
6. NUTS_Regions_2016.csv: Data derived and cleaned from NUTS dataset above
7. Final_Dataset.csv: The final dataset derived from the raw data above. It includes election district information for each district in 2015, with observations for the following variables: 
    - *District*: Name of election district in Latin characters
    - *NUTS_Region*: Region the district is in derived fromthe NUTS dataset
    - *CityDeathPerc*: The electoral district's percentage share of the total battle related deaths occurred between June-November 2015, derived from the UCDP dataset
    - *June2015_votes*: Local Justice and Development Party vote count in June 2015 Turkish General Elections, derived from the T.E.C website as described above
    - *Nov2015_votes*: Local Justice and Development Party vote count in November 2015 Turkish General Elections, derived from the T.E.C website as described above
    - *VotePercDiff*: Percentage difference of Justice and Development Party votes between June 2015 and November 2015 elections

#### Results/

1. Plot_0.jpeg: Descriptive chart that demonstrates the Percentage Change in AKP Votes by District.
2. Plot_1.jpeg: Demonstrates the Change in Votes by Region.
3. Plot_2.jpeg: Shows the Distribution of Wartime Deaths by Region, between June-November 2015.
4. Plot_3.jpeg: Visualizes the Increase in AKP Votes by Region’s Share of Wartime Casualties.
5. Plot_4.jpeg: Visualizes the Share of Deaths by District and Percentage Increase in AKP Votes with a smoothed linear model line.
6. Plot_5.jpeg: Uses the same information with the Plot_4.jpeg, with the x-axis logged.
7. regression_table.txt: Demonstrates results driven from three basic linear models, using the Percentage Increase in AKP Votes as the dependent variable.

## More Information

This is a final project prepared for "PLSC 31101: Computational Tools for Social Science," a graduate seminar at the University of Chicago, taught by Dr. Rochelle Terman, in Fall 2019.

For questions regarding the data, its replication, and its implications, the author can be reached at buraktan@uchicago.edu 

