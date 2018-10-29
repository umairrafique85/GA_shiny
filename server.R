library(shiny)
library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(plotly)
library(shinydashboard)
library(googleAnalyticsR)
select <- dplyr::select

shinyServer(function(input, output, session) {
  
  observeEvent(input$btn_auth, {
    ga_auth()
  }) 
  
  observeEvent(input$btn_accList, {
    try(output$tableFetched_tab1 <- renderDataTable(ga_account_list()))
  })
  
  observeEvent(input$slct_dimensions_tab1, {
    updateTextInput(session, "txt_dimensions_tab1", value = paste(input$txt_dimensions_tab1, input$slct_dimensions_tab1, 
                                                                  sep = " "))
  })
  
  observeEvent(input$slct_metrics_tab1, {
    updateTextInput(session, "txt_metrics_tab1", value = paste(input$txt_metrics_tab1, input$slct_metrics_tab1, 
                                                               sep = " "))
  })
  
  df_dataPulled <- eventReactive(input$btn_fetchData, {
    try(google_analytics(input$txt_viewId_tab1, date_range = c(input$date_from_tab1, input$date_to_tab1), 
                     dimensions = unlist(strsplit(input$txt_dimensions_tab1, split = " ")), 
                     metrics = unlist(strsplit(input$txt_metrics_tab1, split = " "))))
  })
  
  observeEvent(df_dataPulled(), {
    output$tableFetched_tab1 <- renderDataTable(df_dataPulled())
  })
})
