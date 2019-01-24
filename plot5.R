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

## 5. How have emissions from motor vehicle sources changed from 1999–2008 in Baltimore City?
## Filter SCC data by "Vehicles" in the SCC.Level.Two
SCC_Vehicles <- SCC %>%
        filter(grepl('[Vv]ehicle', SCC.Level.Two)) %>%
        select(SCC, SCC.Level.Two)

BaltimoreVehicles <- NEI %>%
        filter(fips == "24510") %>%
        select(SCC, fips, Emissions, year) %>%
        inner_join(SCC_Vehicles, by = "SCC") %>%
        group_by(year) %>%
        summarise(Emissions = sum(Emissions, na.rm = TRUE)) %>%
        select(Emissions, year)

Emissions <- BaltimoreVehicles$Emissions

## Using ggplot
plot5 <- ggplot(BaltimoreVehicles, aes(factor(year), Emissions)) + 
        geom_bar(stat = "identity", fill = "grey") + 
        labs(title = "Emissions from the motor vehicle sources in Baltimore from 1999 to 2008",
             x = "Year", y = "Emissions")
plot5
## Conclusion: Plot shows that emissions from motor vehicle sources in Baltimore decreased
## from 1999 to 2008.

## Save plot5 to a PNG file
dev.copy(png, file = "plot5.png", width = 800, height = 700)
dev.off()