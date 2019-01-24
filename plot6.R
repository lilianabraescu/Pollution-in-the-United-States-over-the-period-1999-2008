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

## 6. Compare emissions from motor vehicle sources in Baltimore City with emissions 
## from motor vehicle sources in Los Angeles County, California (fips==06037).
## Which city has seen greater changes over time in motor vehicle emissions?
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

LosAngelesVehicles <- NEI %>%
        filter(fips == "06037") %>%
        select(SCC, fips, Emissions, year) %>%
        inner_join(SCC_Vehicles, by = "SCC") %>%
        group_by(year) %>%
        summarise(Emissions = sum(Emissions, na.rm = TRUE)) %>%
        select(Emissions, year)

BaltimoreVehicles$city <- "Baltimore City"
LosAngelesVehicles$city <- "Los Angeles County"

Comparison <- rbind(BaltimoreVehicles, LosAngelesVehicles)

## Using ggplot
plot6 <- ggplot(Comparison, aes(factor(year), Emissions, fill = city)) + 
        geom_bar(stat = "identity") + 
        facet_grid(.~city, scales = "free", space="free") + 
        labs(title = "Emissions from the motor vehicle sources in Baltimore compared with Los Angeles from 1999 to 2008",
             x = "Year", y = "Emissions")
plot6
## Conclusion: Plot shows that Las Angeles County has huge PM2.5 emissions compared with Baltimore city. 
## Moreover, if in Baltimore emissions decreased from 1999 to 2008, in Los Angeles County can be
## seen increasing of emissions from the motor vehicle sources, with a pick in 2005. Even thought 
## emissions decreased in 2008 compared with 2005 in LA, they are still bigger that emissions from 1999.

## Save plot6 to a PNG file
dev.copy(png, file = "plot6.png", width = 800, height = 1000)
dev.off()