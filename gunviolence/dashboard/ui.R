# dashboard ui

library(shinydashboard)
shinyUI(
  dashboardPage(skin = 'purple',
    dashboardHeader(title = 'Gun Violence'),
    dashboardSidebar(
      sidebarUserPanel('author: Mike Dollar'),
      
      
      sidebarMenu(
        menuItem("Introduction", tabName = "intro", icon = icon("angle-right")),
        menuItem("General Shootings By State", tabName = "map", icon = icon("map")),
        menuItem('Correlation', tabName = 'corr', icon = icon('angle-right')),
        menuItem("Mass Shooting Stats", tabName = 'bar', icon = icon("angle-right")),
        menuItem('Data', tabName = 'data', icon = icon('angle-right')),
        menuItem('Bio', tabName = 'bio', icon = icon('angle-right')))
      ),
        
    
  dashboardBody(
    tabItems(
      tabItem(tabName = 'intro',
              titlePanel('A Brief Look At Gunviolence'),
              fluidRow(
                column(width = 12,
                    box((introstring1), width = 24 ,style = "font-family: 'Ariel', sans-serif;
                        font-weight: 500; line-height: 1.1; color: #4d3a7d;")    
                       )
                
              ),
              flowLayout(
                column(12,
                  titlePanel('Map'),
                  box((introstring2),style = "font-family: 'Ariel', sans-serif;
                          font-weight: 500; line-height: 1.1; color: #4d3a7d;"),
                  titlePanel('Map'),
                  box((introstring2),style = "font-family: 'Ariel', sans-serif;
                      font-weight: 500; line-height: 1.1; color: #4d3a7d;")
                       
                  ),
                column(12,
                  titlePanel('Map'),
                  box((introstring2),style = "font-family: 'Ariel', sans-serif;
                          font-weight: 500; line-height: 1.1; color: #4d3a7d;"),
                  titlePanel('Map'),
                  box((introstring2),style = "font-family: 'Ariel', sans-serif;
                      font-weight: 500; line-height: 1.1; color: #4d3a7d;")
                  
                )
                )
                
                
              
              
              
      ),
        
      tabItem(tabName = "map",
              # gvisGeoChart
              fluidRow(
                titlePanel('Incidents and Number of Regulations by State for 2016')
              ),
              fluidRow(
                infoBoxOutput("maxBox"),
                infoBoxOutput("minBox"),
                infoBoxOutput("avgBox")
              ),
              fluidRow(
                selectizeInput("selected", "Select Stat", choice1)
              ),
              fluidRow(
                box(htmlOutput("map"), width = 10)
              )
              
              
              
      ),
      
      tabItem(tabName = "corr",
              # correlational stats
              titlePanel('Correlation Investigation'),
              sidebarLayout(
                sidebarPanel(
                  fluidRow(
                    box((corrstring), width = 16,style = "font-family: 'Ariel', sans-serif;
                    font-weight: 500; line-height: 1.1; 
                    color: #4d3a7d;")),
                  fluidRow(box(selectizeInput('stat_1','Select stat for horizontal axis', choices = corrplot_choices), width = 14)),
                  fluidRow(box(selectizeInput('stat_2','Select stat for vertical axis', choices = choice), width = 14))
                  
                ),
              mainPanel(
                box(plotlyOutput("plot2", height = 500, width = 500), width = 8)
                
                )
              )),
      tabItem(tabName = "bar",
              #splitLayout()# Piecharts
              
              fluidRow(
                titlePanel('Mass Shooting Incidents By Year and Demographic')
              ),
              fluidRow(
                box(title = "Select Year From 2013 to 2017", width = 10,
                    sliderInput("slider", "Year", 2013, 2017, 50)
                )
              ),
              fluidRow(
                box(plotOutput("bar1", width = 400), title = 'By Race', width = 4, height = 4),
                box(plotOutput("bar2", width = 400), title = 'By Mental Health',width = 4, height = 4),
                box(plotOutput("bar3", width = 400), title = 'By Gender',width = 4, height = 4)
                
                
              )),
              
             
              
      tabItem(tabName = "data",
              fluidRow(titlePanel('Incidents by State'),
                       box(DT::dataTableOutput("table_inc"),
                           width = 12)),
              fluidRow(titlePanel('Mass Shootings Since 1966'),
                       box(DT::dataTableOutput("table_mass"),
                           width = 12))
              ),
      
      tabItem(tabName = 'bio',
              fluidRow(titlePanel('A little about the author...')))
      
      
      )
      
    )
  )
)