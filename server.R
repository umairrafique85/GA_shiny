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
  
  observeEvent(input$btn_addDimension, {
    updateTextInput(session, "txt_dimensions_tab1", 
                    value = paste(unique(c(unlist(strsplit(input$txt_dimensions_tab1, 
                                                         split = " ", fixed = T)), 
                                           input$slct_dimensions_tab1)), 
                                  collapse = " "))
  })
  
  observeEvent(input$btn_addMetric, {
    updateTextInput(session, "txt_metrics_tab1", 
                    value = paste(unique(c(unlist(strsplit(input$txt_metrics_tab1, 
                                                           split = " ", fixed = T)), 
                                           input$slct_metrics_tab1)), 
                                  collapse = " "))
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
