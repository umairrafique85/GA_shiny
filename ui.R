library(shiny)
library(shinydashboard)
library(DT)
library(plotly)
library(shinyjs)
dimMets <- RGA::list_dimsmets()
avlblDimensions <- subset(dimMets, type=='DIMENSION')$id
avlblMetrics <- subset(dimMets, type=='METRIC')$id
avlblDimensions <- matrix(unlist(strsplit(avlblDimensions, split = ":", fixed = T)), ncol = 2, byrow = T)[,2]
avlblMetrics <- matrix(unlist(strsplit(avlblMetrics, split = ":", fixed = T)), ncol = 2, byrow = T)[,2]

dashboardPage(
  dashboardHeader(title = "GA with Shiny"),
  ## sidebar ####
  dashboardSidebar(
    sidebarMenu(
      menuItem("Pull data", tabName = "tab1_dataFetch"),
      menuItem("Wrangle", tabName = "tab2_wrangle")
    ),
    tableOutput("tbl_dataInMemory")
  ),
  dashboardBody(
    tabItems(
      ## Data fetch tab and audit tab ####
      tabItem(tabName = "tab1_dataFetch",
        h2("Authenticate, Fetch accounts list, and quick audit"),
        fluidRow( ## Top row with buttons ####     
          actionButton("btn_auth_tab1", "Authenticate"),
          actionButton("btn_accList_tab1", "Fetch Accounts List")
        ),
        fluidRow( ## View Id ####
          column(width = 4,  
            textInput("txt_viewId_tab1", "View Id:")
          ),
          column(width = 4,
            actionButton("btn_quickAudit_tab1", "Quick Audit")
          ),
          column(width = 4
          )
        ),
        fluidRow( ## accounts list
          box(dataTableOutput("dtTbl_accountsList_tab1"))        
        ),
        fluidRow( ## audit info ####
          box(width = 6,
            plotlyOutput("plt_srcMdmTest_tab1"),
            textOutput("txt_selfDomainTest"),
            textOutput("txt_pmntPortalTest")
          )        
        )
      ),
      ## Data fetch and wrangle tab ####
      tabItem(tabName = "tab2_wrangle",
        fluidRow(
          column(width = 8
          ),
          column(width = 2,
            dateInput("date_from_tab2", "From:", value = Sys.Date()-1)
          ),
          column(width = 2,
            dateInput("date_to_tab2", "To:", value = Sys.Date()-1)
          )
        ),
        fluidRow( ## Dimensions and metrics textboxes ####
          column(width = 6, 
            textInput("txt_dimensions_tab2", label = "Dimensions selected:")
          ),
          column(width = 6,
            textInput("txt_metrics_tab2", label = "Metrics selected:")
          )
        ),
        fluidRow( ## Dimensions and metrics selectors ####
          column(width = 5,
            selectInput("slct_dimensions_tab2", "Select dimension to add", choices = avlblDimensions)
          ),
          column(width = 1,
            actionButton("btn_addDimension_tab2", "+")
          ),
          column(width = 5,
            selectInput("slct_metrics_tab2", "Select metric to add", choices = avlblMetrics)
          ),
          column(width = 1,
            actionButton("btn_addMetric_tab2", "+")
          )
        ),
        fluidRow( ## Fetch data and display, and memorize options ####
          column(width = 1,
            actionButton("btn_fetchData_tab2", "Fetch Data")
          ),
          column(width = 3,
            tags$b("Memorize by name:")
          ),
          column(width = 4,
            textInput("txt_nameToMemorize_tab2", NULL)     
          ),
          column(width = 1,
            actionButton("btn_memorize_tab2", "Memorize")     
          ),
          column(width = 3,
            textOutput("txtOut_status_tab2")     
          )
        ),
        fluidRow(
          box(dataTableOutput("tableFetched_tab2"))
        )
      )
    ## end of tabItems ####
    )
  )
)
