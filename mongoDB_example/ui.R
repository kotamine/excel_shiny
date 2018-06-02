
ui <- 
  fluidPage(
    theme = shinytheme("united"), 
    useShinyjs(),
    titlePanel("MongoDB Example"),
    sidebarLayout(
      sidebarPanel(
        h5(paste("Fill the form to enter data.", 
                 "Select a row on the table to update or delete.")),
        uiOutput('user_inputs'),
        actionButton("add","Enter"), 
        actionButton("update","Update"), 
        actionButton("delete","Delete") 
      ),
      mainPanel(
        DTOutput('users'),
        plotOutput('fig_user_type'), 
        br(), br(), 
        plotOutput('fig_interests'),
        uiOutput('usage_summary'),
        br(), br(), 
        DTOutput('usage'),   
        br(), br()
      )
    )
  )