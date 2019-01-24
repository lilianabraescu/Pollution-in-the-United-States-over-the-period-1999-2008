setwd("/Users/lilianabraescu/_DataScience-JHU/Course4_Exploratory_Data_Analysis/Week4")

## First, clear R environment and load necessary libraries.
rm(list = ls())
library(datasets) 

## Unzip and read data
if (!file.exists("./summarySCC_PM25.rds")) {
        unzip(zipfile = "./exdata_data_NEI_data.zip", exdir = "./NEIdata")}

NEI <- readRDS("NEIdata/summarySCC_PM25.rds")
SCC <- readRDS("NEIdata/Source_Classification_Code.rds")
str(NEI); str(SCC)

## 2. Have total emissions from PM2.5 decreased in the Baltimore City, Maryland from 1999 to 2008?  
Baltimore <- NEI[NEI$fips == "24510", ]
TotalEmissionsBaltimore <- aggregate(Emissions ~ year, Baltimore, sum)

## Using the base plotting system:
Emissions <- TotalEmissionsBaltimore$Emissions
Year <- TotalEmissionsBaltimore$year
with(TotalEmissionsBaltimore,
     barplot(Emissions, Year, names.arg = Year, 
             xlab = "Year", ylab = "PM2.5 Emissions",
             main = "Total PM2.5 emissions in Baltimore City from 1999 to 2008", col = "green"))
# Conclusion: Plot shows that overall total PM2.5 emission decreased from 1999 to 2008.

## Save plot2 to a PNG file
dev.copy(png, file = "plot2.png", width = 900, height = 480)
dev.off()