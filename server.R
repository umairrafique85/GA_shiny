library(shiny)
library(dplyr)
library(ggplot2)
library(readr)
library(tidyr)
library(plotly)
library(shinydashboard)
select <- dplyr::select

shinyServer(function(input, output) {
  
  observeEvent(input$btn_auth, {
    ga_auth()
  }) 
  
  observeEvent(input$btn_accList, {
    output$tableFetched_tab1 <- renderDataTable(ga_account_list())
  })
})
