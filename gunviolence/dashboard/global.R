# global for dashboard

# README ##############################

# changes to be made:
#   
# update the titles on the charts so that they do not reflect the variable names.
# 
# update the selectize inputs so that they also do not reflect the variable names.
# 
# Change the pie charts to bar charts.  Pie charts suck.
# 
# format the correlation plot so that it is square.  also, try normalizing the data to see how it looks.
# 
# Format each page.  The fluid row system needs to be better implemented.
# 
# add summary stats to the top part of the map page.
# 
# format column widths on the data tables
#
# Write a better introduction, and include a bio-page at the end with a github link.

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
#normalize the incidents_per_pop
tester = df_stat %>% 
  mutate(., norm_inc_per_pop = incidents_per_pop/sum(incidents_per_pop))


choice1 = c("Number of regulations" = "num_regulations", 
                         "Number of incidents" = "incidents_per_pop")
corrplot_choices = c("Number of regulations" = "num_regulations", 
                     "Number of incidents" = "num_incidents", 
                     "Median Household Income" = "med_household_income", 
                     "Vote Percentage: Donald Trump" = "donald_trump", 
                     "Vote Percentage: Hillary Clinton" = "hillary_clinton")


  #colnames(df_stat)[colnames(df_stat) %in% map_selector_choices]

# function to remap choices
# RemapChoice = function(){
#   
#   return (ifelse(input$selected == 'incidents_per_pop', 'num_incidents', input$selected))
# }

# Mass shooting #############################################################

mass <- read.csv('mass.csv', stringsAsFactors = F)
mass$Date = as.Date(mass$Date, format = '%Y-%m-%d')

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


introstring1 = "Gun Violence and gun control have been topics of heated debate for a long time, now.  America is a minority in the group of first world countries when it comes to guns and gun laws.  With this dataset,
I hope to investigate the effectiveness of gun laws, and relationships--if any--between population demographics and the
frequency of gun-related incidents."

# introstring2 = "Map -- The map allows you to geographically visualize the number of incidents per state population.
#                 Correlation -- Here, you may select from a few statisitics which are aggregated by state and see a correlation plot between them.
#                 Mass Shooting Stats -- From a separate dataset consisting of mass shooting incidents, you may see how certain demographics have changed from 2013 to 2017.
#                 Data -- There are two perusable data tables which were used to construct this app.
#                 Bio -- There is some contact info here and a link to the author's github repository."
introstringMap = "Map -- The map allows you to geographically visualize the number of incidents per state population."
introstringCorr = "Correlation -- Here, you may select from a few statisitics which are aggregated by state and see a correlation plot between them."
introstringMass = "Mass Shooting Stats -- From a separate dataset consisting of mass shooting incidents, you may see how certain demographics have changed from 2013 to 2017."
introstringData = "Data -- There are two perusable data tables which were used to construct this app."

corrstring = "Choose two stats to correlate.  Each blue dot represents a state.  Presidential nominees indicate the percentage of votes per state."

