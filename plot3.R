setwd("/Users/lilianabraescu/_DataScience-JHU/Course4_Exploratory_Data_Analysis/Week4")

## First, clear R environment and load necessary libraries.
rm(list = ls())
library(datasets); library(ggplot2) 

## Unzip and read data
if (!file.exists("./summarySCC_PM25.rds")) {
        unzip(zipfile = "./exdata_data_NEI_data.zip", exdir = "./NEIdata")}

NEI <- readRDS("NEIdata/summarySCC_PM25.rds")
SCC <- readRDS("NEIdata/Source_Classification_Code.rds")
str(NEI); str(SCC)

## 3. Of the four types of sources indicated by the type variable, which of these 
## four sources have seen decreases in emissions from 1999–2008 for Baltimore City? 
## Which have seen increases in emissions from 1999–2008? 
Baltimore <- NEI[NEI$fips == "24510", ]
EmissionsTypeBaltimore <- aggregate(Emissions ~ year + type, Baltimore, sum)

Emissions <- EmissionsTypeBaltimore$Emissions

## Using ggplot
plot3 <- ggplot(EmissionsTypeBaltimore, aes(factor(year), Emissions, fill = type)) + 
         geom_bar(stat = "identity") +
         facet_grid(.~type, scales = "free", space="free") +
         labs(title = "PM2.5 emissions in Baltimore City from 1999 to 2008 per source type",
             x = "Year", y = "PM2.5 Emissions")
plot3
## Conclusion: Plot shows that PM2.5 emissions in Baltimore City from 1999 to 2008 decreased 
## for "non-road", "on-road" and "nonpoint" type of sources. Increase in emission can be seen for
## the "point" source with a pick achieved in 2005. Emission in 2008 decreased compared with 2005, 
## but it is still higher than emission from 1999.

## Save plot3 to a PNG file
dev.copy(png, file = "plot3.png", width = 1000, height = 700)
dev.off()