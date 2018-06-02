
library(shiny)

my_ui <- 
  fluidPage( 
    h2("How many calves can be fed by calf feeders per year?"),
    h3("Enter your inputs"),
    
    # define inputs
    # numericInput(inputId, label, value, min, max, step, width)
    numericInput(inputId= "num_feeders", label="Number of Feeders", value = 2), 
    numericInput(inputId="num_calves", label="Number of Calves", value = 30), 
    numericInput(inputId="days_on_feeder", label="Days on Feeder", value = 60),
    actionButton(inputId = "update", label="Update"), 
    br(), br(), 
    
    # define outputs   
    h3("Results"), 
    h4("Total number of calves that can be fed in a given point of time"), 
    verbatimTextOutput("calves_total"),  
    h4("Groups of calves that can be turned over a year"),
    textOutput("group_turns"), 
    h4("Calves that can be fed per year "),
    uiOutput("calves_yr")
  )


my_server <- 
 function(input, output) {
    
    # define a object (list) for reactive values 
    rv <- reactiveValues(calves_total = NA, group_turns =NA)
    
    # when input$update is pressed 
    # calculate and store variables as reactive objects  
    observeEvent(input$update, {
      rv$calves_total <- input$num_feeders * input$num_calves
      rv$group_turns <-  365/input$days_on_feeder
    })
    
    # render calculated results as outputs 
    output$calves_total <- renderPrint(rv$calves_total)
    output$group_turns <-  renderText(rv$group_turns)
    output$calves_yr <-  renderUI(h4(round(rv$calves_total * rv$group_turns)))
  }

shinyApp(my_ui, my_server)


