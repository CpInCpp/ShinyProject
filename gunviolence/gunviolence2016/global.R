# global for dashboard

# README ##############################

# changes to be made:
#   
# The numbers on the map page are wonky.  They are correct, but they are so small in value, 
# they are not being displayed.
#
# try normalizing the data to see how it looks.
# 


# Libraries ###############################################################
library(shiny)
library(tidyverse)
library(dplyr)
library(ggplot2)
library(plotly)
library(googleVis)
library(lubridate)
library(DT)

# Data Frames ####
# incidents ##################################################################
df_stat = read.csv('IncRegMedVotes.csv', stringsAsFactors = F)
df_stat = df_stat %>% 
  select(., colnames(df_stat)[-c(8,9,10,11)])


choice1 = c("Number of regulations" = "num_regulations", 
                         "Number of incidents" = "incidents_per_pop")
corrplot_choices = c("Number of regulations" = "num_regulations", 
                     "Number of incidents" = "num_incidents",
                     "Number of incidents per state population" = "incidents_per_pop",
                     "Median Household Income" = "med_household_income", 
                     "Vote Percentage: Donald Trump" = "donald_trump", 
                     "Vote Percentage: Hillary Clinton" = "hillary_clinton")
df_statcolnames = c("Number of regulations", 
  "Number of incidents",
  "Number of incidents per state population",
  "Median Household Income", 
  "Vote Percentage: Donald Trump", 
  "Vote Percentage: Hillary Clinton")



# Mass shooting #############################################################

mass <- read.csv('mass.csv', stringsAsFactors = F)
mass$Date = as.Date(mass$Date, format = '%Y-%m-%d')
massDT = mass %>%
  select(., Title, Location, Date, Incident.Area, Summary, Total.victims)


# pie chart of incidents by different races
mass_inc_by_race = mass %>% 
  mutate(., Year = year(Date) ) %>% 
  group_by(., Race, Year ) %>% 
  summarise(., Incidents = n())

mass_inc_by_mental = mass %>% 
  mutate(., Year = year(Date) ) %>% 
  group_by(., Mental.Health.Issues, Year ) %>% 
  summarise(., Incidents = n())

mass_inc_by_sex = mass %>% 
  mutate(., Year = year(Date) ) %>% 
  group_by(., sex, Year ) %>% 
  summarise(., Incidents = n())

rem_col = which(colnames(mass) %in% c('Incident.Area', 'Open.Close.Location', 'Employeed..Y.N.', 'Employed.at', 'Latitude', 'Longitude'))
mass_columns = colnames(mass)[-rem_col]

massDTcolumns = c('Title', 'Location', 'Date', 'Incident Area', 'Summary', 'Total Victims')


introstring1 = "Gun Violence and gun control have been topics of heated debate for a long time, now.  America is a minority in the group of first world countries when it comes to guns and gun laws.  With this dataset,
I hope to investigate the effectiveness of gun laws, and relationships--if any--between population demographics and the
frequency of gun-related incidents."


introstringMap = "Map -- The map allows you to geographically visualize the number of incidents per state population."
introstringCorr = "Correlation -- Here, you may select from a few statisitics which are aggregated by state and see a correlation plot between them."
introstringMass = "Mass Shooting Stats -- From a separate dataset consisting of mass shooting incidents, you may see how certain demographics have changed from 2013 to 2017."
introstringData = "Data -- There are two perusable data tables which were used to construct this app."

statstring = "Number of Incidents has been divided by the state population for map contrast, but not for max/min values."
corrstring = "Choose two stats to correlate.  Each blue dot represents a state.  Presidential nominees indicate the percentage of votes per state."

biostring1 = "Mike Dollar lives in Manhattan with his wife and two daughters.  He graduated from the City College of New York in 2018 with a B.S. in Physics."
biostring2 = "MikeDollarData@gmail.com https://github.com/CpInCpp"
