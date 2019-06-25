# dashboard server script


shinyServer(function(input, output, session){
  observe({
   x <- input$stat_1
   if (is.null(x)) {
     x <- character(0)
   }
    
    updateSelectInput(session, "stat_2", choices = choice[choice != x],
                      selected = choice[choice != x][1])
 })
  Pieslide <- reactive({

    slideyear = mass_inc_by_race$Year
    ui_year <- slideyear[seq_len(input$slider)]
   
    
    
  })
  
 
  output$map <- renderGvis({
    gvisGeoChart(df_stat, "state", input$selected,
                 options=list(region="US", displayMode="regions",
                              resolution="provinces",
                              width="auto", height="auto"))

  })
  output$pie1 <- renderPlot({
    Pieslide()
      mass_inc_by_race %>%
      filter(., Year == input$slider) %>%
      group_by(., Year) %>%
      ggplot(aes(x='', y = Incidents, fill = Race ))+
      geom_bar(width = 1, stat = 'identity')+
      coord_polar("y", start=0)+
      scale_fill_brewer(palette="Blues")+
      theme_minimal() +
      scale_fill_discrete()+
      theme(legend.position = 'bottom', legend.key.size = unit(.5, 'cm'))
  })
  output$pie2 <- renderPlot({
    
    slideyear = mass_inc_by_mental$Year
    ui_year <- slideyear[seq_len(input$slider)]
      mass_inc_by_mental %>%
      filter(., Year == input$slider) %>%
      group_by(., Year) %>% 
      ggplot(aes(x='', y = Incidents, fill = Mental.Health.Issues ))+
      geom_bar(width = 1, stat = 'identity')+
      coord_polar("y", start=0)+
      scale_fill_brewer(palette="Blues")+
      theme_minimal()+
        scale_fill_discrete()+
        theme(legend.position = 'bottom', legend.key.size = unit(.5, 'cm'))
  })
  output$pie3 <- renderPlot({
    slideyear = mass_inc_by_mental$Year
    ui_year <- slideyear[seq_len(input$slider)]
      mass_inc_by_sex %>% 
      filter(., Year == input$slider) %>%
      group_by(., Year) %>%   
      ggplot(aes(x='', y = Incidents, fill = sex ))+
      geom_bar(width = 1, stat = 'identity')+
      coord_polar("y", start=0)+
        scale_fill_discrete()+
        theme(legend.position = 'bottom', legend.key.size = unit(.5, 'cm'))
  })

  output$plot2 <- renderPlotly({
    
   
    
    
    ggplotly(ggplot(data = df_stat, aes_string(x = input$stat_1,  y = input$stat_2))+
    
      geom_point( color = 'blue'))
    
    
  })
  
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