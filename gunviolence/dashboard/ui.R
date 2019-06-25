# dashboard ui

library(shinydashboard)
shinyUI(
  dashboardPage(skin = 'purple',
    dashboardHeader(title = 'Gun Violence'),
    dashboardSidebar(
      sidebarUserPanel('Mike Dollar'),
      
      
      sidebarMenu(
        menuItem("Introduction", tabName = "intro", icon = icon("angle-right")),
        menuItem("General Shootings By State", tabName = "map", icon = icon("map")),
        menuItem("Mass Shooting Stats", tabName = 'pie', icon = icon("angle-right")),
        menuItem('Correlation', tabName = 'corr', icon = icon('angle-right')),
        menuItem('Data', tabName = 'data', icon = icon('angle-right')))
      ),
        
    
  dashboardBody(
    tabItems(
      tabItem(tabName = 'intro',titlePanel('A Brief Look At Gunviolence'),
              box(introstring),style = "font-family: 'Ariel', sans-serif;
        font-weight: 500; line-height: 1.1; 
              color: #4d3a7d;"),
        
      tabItem(tabName = "map",
            # gvisGeoChart
            fluidRow(titlePanel('General Gun Violence Incidents and Number of Regulations by State'),
                     selectizeInput("selected",
                                    "Select Stat",
                                    choice1),
                     box(htmlOutput("map"), width = 10)
                     
                     
                     )),
      tabItem(tabName = "pie",
            #splitLayout()# Piecharts
           
             fluidRow(titlePanel('Mass Shooting Incidents By Year and Demographic'),
               box(
                 title = "Select Year From 2013 to 2017", width = 10,
                 sliderInput("slider", "Year", 2013, 2017, 50)
               )
               
              
               
             ),
             fluidRow(
              box(plotOutput("pie1", width = 275), title = 'By Race', width = 4, height = 4),
              box(plotOutput("pie2", width = 275), title = 'By Mental Health',width = 4, height = 4),
              box(plotOutput("pie3", width = 275), title = 'By Gender',width = 4, height = 4)
              
              
            )),
      tabItem(tabName = "corr",
              # correlational stats
              titlePanel('Correlation Investigation'),
              sidebarLayout(
                sidebarPanel(
                  fluidRow(box(selectizeInput('stat_1','Select Stat 1', choices = choice), width = 14)),
                  fluidRow(box(selectizeInput('stat_2','Select Stat 2', choices = choice), width = 14))
                  
                ),
              mainPanel(
                box(plotlyOutput("plot2", height = 500, width = 500), width = 8)
                
                )
              )),
              
             
              
      tabItem(tabName = "data",
              fluidRow(titlePanel('Incidents by State'),
                       box(DT::dataTableOutput("table_inc"),
                           width = 12)),
              fluidRow(titlePanel('Mass Shootings Since 1966'),
                       box(DT::dataTableOutput("table_mass"),
                           width = 12))
              )
      )
      
    )
  )
)