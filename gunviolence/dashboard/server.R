# dashboard server script


shinyServer(function(input, output, session){
  observe({
   x <- input$stat_1
   if (is.null(x)) {
     x <- character(0)
   }
    
    updateSelectInput(session, "stat_2", choices = corrplot_choices[corrplot_choices != x],
                      selected = corrplot_choices[corrplot_choices != x][1])
 })
  
  # Info Boxes ####
  output$maxBox <- renderInfoBox({
    
    max_value <- max(df_stat[,ifelse(input$selected == 'incidents_per_pop', 'num_incidents', input$selected)] )
    max_state <-
      df_stat$state[df_stat[,ifelse(input$selected == 'incidents_per_pop', 'num_incidents', input$selected)]==max_value]
    infoBox(max_state, max_value, icon = icon("hand-o-up"))
  })
  
  output$minBox <- renderInfoBox({
    min_value <- min(df_stat[,ifelse(input$selected == 'incidents_per_pop', 'num_incidents', input$selected)])
    min_state <-
      df_stat$state[df_stat[,ifelse(input$selected == 'incidents_per_pop', 'num_incidents', input$selected)]==min_value]
    infoBox(min_state, min_value, icon = icon("hand-o-down"))
  })
  
  output$avgBox <- renderInfoBox({
    
    infoBox(paste("AVG.", ifelse(input$selected == 'incidents_per_pop', 'Number of Incidents', input$selected)),
            mean(df_stat[,ifelse(input$selected == 'incidents_per_pop', 'num_incidents', input$selected)]),
            icon = icon("calculator"), fill = TRUE)
  })
  
  # Map ####
  output$map <- renderGvis({
   
    gvisGeoChart(df_stat, "state", input$selected,
                 options=list(region="US", displayMode="regions",
                              resolution="provinces",
                              width="auto", height="auto"))

  })
  # Mass Shooting Charts ####
  output$bar1 <- renderPlot({
    slideyear = mass_inc_by_race$Year
    ui_year <- slideyear[seq_len(input$slider)]
      mass_inc_by_race %>%
      filter(., Year == input$slider) %>%
      group_by(., Year) %>%
      ggplot(aes(x='', y = Incidents, fill = Race ))+
      geom_bar(width = 1, stat = 'identity', position = 'dodge')+
      # coord_polar("y", start=0)+
      scale_fill_brewer(palette="Blues")+
      theme_minimal() +
      scale_fill_discrete()+
        ylab("Number of Incidents")+
        xlab("")+
      theme(legend.position = 'bottom', 
              legend.key.size = unit(.5, 'cm'), 
              legend.text = element_text(size = 12), 
              legend.title = element_text(size=14),
              axis.text = element_text(size = 12),
              axis.title = element_text(size = 12, face = 'bold'))
  })
  output$bar2 <- renderPlot({
    
    slideyear = mass_inc_by_mental$Year
    ui_year <- slideyear[seq_len(input$slider)]
      mass_inc_by_mental %>%
      filter(., Year == input$slider) %>%
      group_by(., Year) %>% 
      ggplot(aes(x='', y = Incidents, fill = Mental.Health.Issues ))+
      geom_bar(width = 1, stat = 'identity', position = 'dodge')+
      #coord_polar("y", start=0)+
      scale_fill_brewer(palette="Blues")+
      theme_minimal()+
      scale_fill_discrete()+
        ylab("Number of Incidents")+
        xlab("")+
      theme(legend.position = 'bottom', 
              legend.key.size = unit(.5, 'cm'), 
              legend.text = element_text(size = 12), 
              legend.title = element_text(size=14),
              axis.text = element_text(size = 12),
              axis.title = element_text(size = 12, face = 'bold'))
  })
  # why does this plot have a gray background?
  output$bar3 <- renderPlot({
    slideyear = mass_inc_by_mental$Year
    ui_year <- slideyear[seq_len(input$slider)]
      mass_inc_by_sex %>% 
      filter(., Year == input$slider) %>%
      group_by(., Year) %>%   
      ggplot(aes(x='', y = Incidents, fill = sex ))+
      geom_bar(width = 1, stat = 'identity', position = 'dodge')+
      #coord_polar("y", start=0)+
      scale_fill_brewer(palette='Blues')+
      scale_fill_discrete()+
      ylab("Number of Incidents")+
      xlab("")+
      theme(legend.position = 'bottom', 
            legend.key.size = unit(.5, 'cm'), 
            legend.text = element_text(size = 12), 
            legend.title = element_text(size=14),
            axis.text = element_text(size = 12),
            axis.title = element_text(size = 12, face = 'bold'))
  })

  # Correlation plots ####
  output$plot2 <- renderPlotly({
      # An attempt was made to change the 
      ylabel = as.character(input$stat_2)
      xlabel = as.character(input$stat_1)
      yaxislabel = switch(ylabel,
                          "num_regulations" = "Number of regulations", "num_incidents" = "Number of incidents", "med_household_income" = "Median Household Income", "donald_trump" = "Vote Percentage: Donald Trump", "hillary_clinton" = "Vote Percentage: Hillary Clinton" 
        
      )
      xaxislabel = switch(xlabel,
                          "num_regulations" = "Number of regulations", "num_incidents" = "Number of incidents", "med_household_income" = "Median Household Income", "donald_trump" = "Vote Percentage: Donald Trump", "hillary_clinton" = "Vote Percentage: Hillary Clinton" 
        
      )  
    
    
      ggplotly(ggplot(data = df_stat, aes_string(x = input$stat_1,  y = input$stat_2))+
    
      geom_point( color = 'blue')+
        xlab(xaxislabel)+
        ylab(yaxislabel))
    
    
  })
  
  # Data Tables ####
  output$table_inc <- DT::renderDataTable({
    datatable(df_stat, rownames=FALSE) %>%
      formatStyle(input$selected,
                  background="skyblue", fontWeight='bold')
    
    # Highlight selected column using formatStyle
  })
  output$table_mass <- DT::renderDataTable({
    datatable(mass, rownames=FALSE, filter = 'top') %>%
      formatStyle(columns = mass_columns,
                  background="skyblue", fontWeight='bold')
  
  
  })
  
})