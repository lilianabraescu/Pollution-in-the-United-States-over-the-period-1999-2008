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

## 1. Have total emissions from PM2.5 decreased in the United States from 1999 to 2008? 
TotalEmissions <- aggregate(Emissions ~ year, NEI, sum)

## Using the base plotting system:
Emissions <- TotalEmissions$Emissions
Year <- TotalEmissions$year
with(TotalEmissions,
barplot(Emissions, Year, names.arg = Year, 
        xlab ="Year", ylab = "PM2.5 Emissions",
        main = "Total PM2.5 emissions in the United States from 1999 to 2008", col = "blue"))
# Conclusion: Plot shows that total PM2.5 emission from all sources decreased from 1999 to 2008.

## Save plot1 to a PNG file
dev.copy(png, file = "plot1.png", width = 900, height = 480)
dev.off()