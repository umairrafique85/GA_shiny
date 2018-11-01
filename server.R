library(shiny)
library(tidyverse)
library(plotly)
library(shinydashboard)
library(googleAnalyticsR)
select <- dplyr::select

shinyServer(function(input, output, session) {
  
  observeEvent(input$btn_auth_tab1, {
    ga_auth()
  }) 
  
  df_dataPulled <- reactiveVal()
  self_domain <- reactiveVal()
  accsList <- reactiveVal()
  
  observeEvent(input$btn_accList_tab1, {
    accsList(ga_account_list())
    output$dtTbl_accountsList_tab1 <- renderDataTable(accsList())
  })
  
  observeEvent(input$btn_quickAudit_tab1, {
    if (str_detect(input$txt_viewId_tab1, "\\S")){
      try({
        df_srcMdmData <- google_analytics(input$txt_viewId_tab1, date_range = c(Sys.Date() - 30,
                                                                                Sys.Date()),
                                          dimensions = "sourceMedium", metrics = "users")
      })
      try({
        if (input$btn_accList_tab1<1){
          accsList(ga_account_list())
        } 
        rawUrl <- accsList()$websiteUrl[accsList()$viewId==input$txt_viewId_tab1]
        rawUrl <- unlist(strsplit(rawUrl, split = ".", fixed = TRUE))
        rawUrl[length(rawUrl)] <- str_extract(rawUrl[length(rawUrl)], "(?:(?!\\/).)*")
        self_domain(paste(rawUrl[2:length(rawUrl)], collapse = "."))
      })
      output$txt_selfDomainTest <- renderText(paste("self domain found in source/Medium:",
                                                    self_domain() %in% df_srcMdmData$sourceMedium))
      vct_paymentPortals <- c("pay.amazon.com", "paypal.com", "pay.shopify.com", 
                              "Infusionsoft.com", "payu.com")
      output$txt_pmntPortalTest <- renderText(paste("payment portal found in source/Medium:",
                                                    any(vct_paymentPortals %in% df_srcMdmData$sourceMedium)))
      df_srcMdmData %>% arrange(desc(users)) %>% head(10) %>% 
        ggplot(aes(reorder(sourceMedium, users), users, fill = users)) + 
        geom_bar(stat = 'identity') + scale_fill_gradient(low = 'blue', high = 'red') + 
        coord_flip() -> srcMdmPlot
      output$plt_srcMdmTest_tab1 <- renderPlotly(ggplotly(srcMdmPlot))
    }
  })
  
  observeEvent(input$btn_addDimension_tab2, {
    updateTextInput(session, "txt_dimensions_tab2", 
                    value = paste(unique(c(unlist(strsplit(input$txt_dimensions_tab2, 
                                                         split = " ", fixed = T)), 
                                           input$slct_dimensions_tab2)), 
                                  collapse = " "))
  })
  
  observeEvent(input$btn_addMetric_tab2, {
    updateTextInput(session, "txt_metrics_tab2", 
                    value = paste(unique(c(unlist(strsplit(input$txt_metrics_tab2, 
                                                           split = " ", fixed = T)), 
                                           input$slct_metrics_tab2)), 
                                  collapse = " "))
  })
  
  dfsInMemory <- reactiveValues()
  
  observeEvent(input$btn_fetchData_tab2, {
    df_dataPulled(try(google_analytics(input$txt_viewId_tab1, date_range = c(input$date_from_tab2, 
                                                                        input$date_to_tab2), 
                                  dimensions = unlist(strsplit(input$txt_dimensions_tab2, split = " ")), 
                                  metrics = unlist(strsplit(input$txt_metrics_tab2, split = " ")))))
  })
  
  observeEvent(df_dataPulled(), {
    output$tableFetched_tab2 <- renderDataTable(df_dataPulled())
  })
  
  observeEvent(input$btn_memorize_tab2, {
    if (str_detect(input$txt_nameToMemorize_tab2, "\\S")) {
      dfsInMemory[[input$txt_nameToMemorize_tab2]] <- df_dataPulled()
      output$tbl_dataInMemory <- renderTable(matrix(names(reactiveValuesToList(dfsInMemory)), 
                                                    dimnames = list(NULL, "Data frames in memory")))
    } else {
      output$txtOut_status_tab2 <- renderText("Please enter name to identify dataframe")
    }
  })
})
  