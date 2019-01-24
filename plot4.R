setwd("/Users/lilianabraescu/_DataScience-JHU/Course4_Exploratory_Data_Analysis/Week4")

## First, clear R environment and load necessary libraries.
rm(list = ls())
library(datasets); library(ggplot2); library(dplyr) 

## Unzip and read data
if (!file.exists("./summarySCC_PM25.rds")) {
        unzip(zipfile = "./exdata_data_NEI_data.zip", exdir = "./NEIdata")}

NEI <- readRDS("NEIdata/summarySCC_PM25.rds")
SCC <- readRDS("NEIdata/Source_Classification_Code.rds")
str(NEI); str(SCC)

## 4. Across the United States, how have emissions from coal combustion-related sources changed from 1999–2008?
# According to https://www.epa.gov/, "coal" data can be found in SCC.Level.Three (e.g., Anthracite Coal) 
# and SCC.Level.Four (e.g., Pulverized Coal); combustion data are in SCC.Level.One.
# So, we filter SCC data by "Coal" in Levels 3 and 4, and by "Combustion" in Level 1
SCC_Coal_Combustion <- SCC %>%
        filter(grepl('[Cc]ombustion', SCC.Level.One)) %>%
        filter(grepl("[Cc]oal", SCC.Level.Three)) %>%
        filter(grepl("[Cc]oal", SCC.Level.Four)) %>%
        select(SCC, SCC.Level.One, SCC.Level.Three, SCC.Level.Four)

NEI_Coal_Combustion <- inner_join(NEI, SCC_Coal_Combustion, by = "SCC")

Emissions <- NEI_Coal_Combustion$Emissions

## Using ggplot
plot4 <- ggplot(NEI_Coal_Combustion, aes(factor(year), Emissions)) + 
         geom_bar(stat = "identity", fill = "red") + 
         labs(title = "Emissions from coal combustion-related sources in the United States from 1999 to 2008",
             x = "Year", y = "Emissions")
plot4
## Conclusion: Plot shows that emissions from coal combustion-related sources in the United States 
## decreased overall from 1999 to 2008. 

## Save plot4 to a PNG file
dev.copy(png, file = "plot4.png", width = 800, height = 700)
dev.off()