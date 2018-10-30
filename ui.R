library(shiny)
library(shinydashboard)
library(DT)
library(plotly)
library(RGA)

dimMets <- list_dimsmets()
avlblDimensions <- subset(dimMets, type=='DIMENSION')$id
avlblMetrics <- subset(dimMets, type=='METRIC')$id
avlblDimensions <- matrix(unlist(strsplit(avlblDimensions, split = ":", fixed = T)), ncol = 2, byrow = T)[,2]
avlblMetrics <- matrix(unlist(strsplit(avlblMetrics, split = ":", fixed = T)), ncol = 2, byrow = T)[,2]

dashboardPage(
  dashboardHeader(title = "GA with Shiny"),
  dashboardSidebar(
    sidebarMenu(
      menuItem("Pull data", tabName = "tab1_dataFetch"),
      menuItem("Wrangle", tabName = "tab2_wrangle")
    )
  ),
  dashboardBody(
    tabItems(
      tabItem(tabName = "tab1_dataFetch",
        h2("Authenticate and Fetch data"),
        fluidRow(      
          actionButton("btn_auth", "Authenticate"),
          actionButton("btn_accList", "Fetch Accounts List")
        ),
        fluidRow(
          column(width = 4,  
            textInput("txt_viewId_tab1", "View Id:")
          ),
          column(width = 4,
            dateInput("date_from_tab1", "From:", value = Sys.Date()-1)
          ),
          column(width = 4,
            dateInput("date_to_tab1", "To:", value = Sys.Date()-1)
          )
        ),
        fluidRow(
          column(width = 6, 
            textInput("txt_dimensions_tab1", label = "Dimensions selected:")
          ),
          column(width = 6,
            textInput("txt_metrics_tab1", label = "Metrics selected:")
          )
        ),
        fluidRow(
          column(width = 5,
            selectInput("slct_dimensions_tab1", "Select dimension to add", choices = avlblDimensions)
          ),
          column(width = 1,
            actionButton("btn_addDimension", "+")
          ),
          column(width = 5,
            selectInput("slct_metrics_tab1", "Select metric to add", choices = avlblMetrics)
          ),
          column(width = 1,
            actionButton("btn_addMetric", "+")
          )
        ),
        fluidRow(
          actionButton("btn_fetchData", "Fetch Data")
        ),
        fluidRow(
          box(dataTableOutput("tableFetched_tab1"))
        )
      ),
      tabItem(tabName = "tab2_wrangle"

      )
    )
  )
)
