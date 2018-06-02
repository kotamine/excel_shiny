
library(shiny)

source(file.path("ui_files","about.R"), local=TRUE)
source(file.path("ui_files","ui_tools.R"), local=TRUE)
source(file.path("templates","UMN_Header.R"), local=TRUE)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "css/bootstrap.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "css/bootstrap.min.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "css/2015-tc.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "css/agency.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "css/main.css"),
    
    tags$link(rel = "stylesheet", type = "text/css", href = "css/font-awesome.min.css"),
    tags$link(rel = "stylesheet", type = "text/css", href = "https://fonts.googleapis.com/css?family=Montserrat:400,700"),
    tags$link(rel = "stylesheet", type = "text/css", href = "https://fonts.googleapis.com/css?family=Kaushan+Script' rel='stylesheet"),
    tags$link(rel = "stylesheet", type = "text/css", href = "https://fonts.googleapis.com/css?family=Droid+Serif:400,700,400italic,700italic"),
    tags$link(rel = "stylesheet", type = "text/css", href = "https://fonts.googleapis.com/css?family=Roboto+Slab:400,100,300,700"),
    
    tags$script(type =  "text/javascript" ,  src ="numberformat.js")
  ),
  UMNHeader("Economic Analysis of Automated Calf Feeders"),
  div(id="content",
      about_text(),
      df_all %>%
        with(
          lapply(1:nrow(df_all), function(i) {
            if(is.even(i)) {
              shading <- "shaded-row"
            } else {
              shading <- ""
            }
            if (header[i]!="") {
               fluidRow(div(h4(header[i])))
            } else {
              if (by_user[i] == 0) {  # calculated variable
                # uiOutput(variable[i])
                fluidRow(class=shading,
                         div(class="row-label",label[i]),
                         div(class="input-columns",
                             uiOutput(class="format-node desktop",paste0(variable[i],1)),
                             uiOutput(class="format-node desktop",paste0(variable[i],2)),
                             uiOutput(class="format-node desktop",paste0(variable[i],3)),
                             uiOutput(class="format-node mobile",paste0(variable[i], "-mobile"), "data-idref"=variable[i])
                         )
                )
              } else if (!is.na(default_txt[i])) {  # text variable
                # textInput(variable[i], label[i], value = default_txt[i])
                fluidRow(class=shading,
                         div(class="row-label", label[i]),
                         div(class="input-columns",
                             inlineTextInput(class="desktop", paste0(variable[i],1), NULL, paste(default_txt[i],1)),
                             inlineTextInput(class="desktop", paste0(variable[i],2), NULL, paste(default_txt[i],2)),
                             inlineTextInput(class="desktop", paste0(variable[i],3), NULL, paste(default_txt[i],3))
                         ),
                         div(class="dropdown mobile", mobileDropdown(variable[i], default_txt[i]))
                )
              } else if (!is.na(default_num[i])) {  # numeric variable
                # numericInput(variable[i], label[i], value = default_num[i],
                #              min = min[i], max = max[i], step = step[i])
                fluidRow(class=shading,
                         div(class="row-label", label[i]),
                         div(class="input-columns",
                             inlineNumericInput(paste0(variable[i],1), NULL, default_num[i],
                                                min = min[i], max = max[i], step = step[i], subclass="desktop"),
                             inlineNumericInput(paste0(variable[i],2), NULL, default_num[i],
                                                min = min[i], max = max[i], step = step[i], subclass="desktop"),
                             inlineNumericInput(paste0(variable[i],3), NULL, default_num[i],
                                                min = min[i], max = max[i], step = step[i], subclass="desktop"),
                             inlineNumericInput(paste0(variable[i], "-mobile"), NULL, default_num[i],
                                                min = min[i], max = max[i], step = step[i], subclass="mobile", "data-idref"=variable[i])
                         )
                )
              }
            }
        })
      ),
      br(),
  div(class="plot-with-key",
      plotOutput("cost_plot")
      ),
  plotOutput("breakeven_plot"),
  # fluidRow(
  #   div(class="col-md-4", plotOutput("cost_plot")),
  #   div(class="col-md-4", plotOutput("breakeven_plot"))
  # ),
  
  # tooltips
  df_all %>% 
    with(
      lapply(1:nrow(df_all), function(i) {
          if (by_user[i]==1) {
          bsTooltip(id=paste0(variable[i],1),
                    note[i])
          }
        })
    ))
  
))
