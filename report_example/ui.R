
# Originally, example taken from 
# https://shiny.rstudio.com/tutorial/written-tutorial/lesson5/

# User interface ----
ui <- fluidPage(
  titlePanel("Interactive Report Creation Example"),
  
  sidebarLayout(
    sidebarPanel(
      helpText("Demographic maps with information from 2015 current population estimates."),
      
      selectInput("var", 
                  label = "Choose a variable to display",
                  choices = c("Percent White", "Percent Black",
                              "Percent Hispanic", "Percent Asian",
                              "Percent Native American"),
                  selected = "Percent White"),
      
      sliderInput("range", 
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100)),
      downloadButton("report", "Generate report")
      ),
    
    mainPanel(plotOutput("map"))
  )
  )



