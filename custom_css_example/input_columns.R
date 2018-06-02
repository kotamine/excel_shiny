
library(shiny)

my_ui <- 
  fluidPage( 
    # HTML header tags
    tags$head(
      # Include the css file from the www folder
      tags$link(rel = "stylesheet", type = "text/css", href = "/css/main.css")
      ),
    
    #  ---------------------- beginning of UI ---------------------------
    div(class = "content-body",
      h2("Inputs in Columns"),
    
      # define inputs
      fluidRow(div(class="row-label", ""),
               div(class="column-labels",
                   div("Column1"),
                   div("Column2"),
                   div("Column3")
               )
               
      ),
      fluidRow(div(class="row-label", "Row 1"),
               div(class="column-inputs",
                   numericInput(inputId= "input1_1", label = NA, value = 1),
                   numericInput(inputId= "input1_2", label = NA, value = 2),
                   numericInput(inputId= "input1_3", label = NA, value = 3)
               )
               
      ),
      fluidRow(div(class="row-label", "Row 2"),
               div(class="column-inputs",
                   numericInput(inputId= "input2_1", label = NA, value = 1),
                   numericInput(inputId= "input2_2", label = NA, value = 2),
                   numericInput(inputId= "input2_3", label = NA, value = 3)
               )
               
      ),
      fluidRow(div(class="row-label", "Row 3"),
               div(class="column-inputs",
                   numericInput(inputId= "input3_1", label = NA, value = 1),
                   numericInput(inputId= "input3_2", label = NA, value = 2),
                   numericInput(inputId= "input3_3", label = NA, value = 3)
               )
               
      )
    )
  )


my_server <- 
  function(input, output) {
    
  }

shinyApp(my_ui, my_server)


