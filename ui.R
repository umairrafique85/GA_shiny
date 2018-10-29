library(shiny)
library(shinydashboard)
library(DT)
library(plotly)

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
        fluidRow(      
          actionButton("btn_auth", "Authenticate"),
          actionButton("btn_accList", "Fetch Accounts List"),
          dataTableOutput("tableFetched_tab1")
        )
      ),
      tabItem(tabName = "tab2_wrangle"

      )
    )
  )
)