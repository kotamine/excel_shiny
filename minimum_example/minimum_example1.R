
library(shiny)

my_ui <- 
  fluidPage( 
    # HTML header tags
    # google analytics tracking: either one works 
    # tags$head(includeHTML(("google_analytics_snippet.html"))),
    tags$head(includeScript("google_analytics_snippet.js")),
    
    # google analytics tracking variable changes 
    # tags$script(includeHTML(("google_analytics_tracking.html"))),
    # includeScript("google_analytics_tracking.js"),
    
    # tags$script(HTML(
    # "$(document).on('shiny:inputchanged', function(event) {
    #   if (event.name === 'num_feeders') {
    #     trackingFunction(['trackEvent', 'Number of Feeders',
    #                       'Class of Model', event.name, event.value]);
    #   }
    #   if (event.name === 'num_calves') {
    #     trackingFunction(['trackEvent', 'Number of Calves',
    #                       'Class of Model', event.name, event.value]);
    #   }
    #   if (event.name === 'days_on_feeder') {
    #     trackingFunction(['trackEvent', 'Days on Feeder',
    #                       'Class of Model', event.name, event.value]);
    #   }
    # });")), 
    
    #  ---------------------- beginning of UI ---------------------------
    h2("How many calves can be fed by calf feeders per year?"),
    h3("Enter your inputs"),
    
    # define inputs
    # numericInput(inputId, label, value, min, max, step, width)
    numericInput(inputId= "num_feeders", label="Number of Feeders", value = 2), 
    numericInput(inputId="num_calves", label="Number of Calves", value = 30), 
    numericInput(inputId="days_on_feeder", label="Days on Feeder", value = 60),
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
    # calculate and store variables as reactive objects 
    calves_total <- reactive({ input$num_feeders * input$num_calves })
    group_turns <- reactive({ 365/input$days_on_feeder })
    
    # render calculated results as outputs 
    output$calves_total <- renderPrint(calves_total())
    output$group_turns <-  renderText(group_turns())
    output$calves_yr <-  renderUI(h4(round(calves_total() * group_turns())))
  }

shinyApp(my_ui, my_server)


