
library(shiny)

df  <- read.csv("variable_data.csv", stringsAsFactors =FALSE) 

my_ui <- 
  fluidPage( 
    h2("How many calves can be fed by calf feeders per year?"),
    h3("Enter your inputs"),
    
    # define inputs
    with(df, 
         lapply(1:nrow(df), function(i) {
           if (by_user[i] == 1) { # select only inputs provided by user
             numericInput(inputId = variable[i], label = label[i], value=default[i])
           }
         })
    ), 
    br(), br(), 
    
    # define outputs   
    with(df, 
         lapply(1:nrow(df), function(i) {
           if (by_user[i] == 0 ) { # select only outputs returned to user 
             uiOutput(variable[i])
           }
         })
    )
  )


my_server <- 
  function(input, output) {
    # define a object (list) for reactive values 
    rv <- reactiveValues()
    
    # calculate and store variables as reactive objects
    observe({
      rv$calves_total <- input$num_feeders * input$num_calves
      rv$group_turns <-  365/input$days_on_feeder
      rv$calves_yr <- rv$calves_total * rv$group_turns 
    })
    
    # render calculated results as UI output 
    with(df, 
         lapply(1:nrow(df),
                function(i) {
                  if (by_user[i] == 0) {
                    # define output items 
                    output[[variable[i]]] <<- renderUI({
                      if (length(rv[[variable[i]]])>0)
                        # define rendering UI object  
                        div(
                          h4(label[i]), 
                          h4( round( rv[[variable[i]]], digits = round_digits[i]))
                        )
                    })
                  }
                })
    )
  }

shinyApp(my_ui, my_server)


