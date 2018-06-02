UMNHeader <- function(title) {
  tags$nav(id="mainNav", class="navbar navbar-default navbar-custom navbar-fixed-top", style="background-color: #7a0019; width: 100%;",
           div(class="container",
               div(class="umnhf", id="umnhf-h", role="banner",
                   div(id="skipLinks",
                       tags$a(href="#main-nav", "Main navigation"),
                       tags$a(href="#main-content", "Main content")
                       ),
                   div(class="printer",
                       div(class="left"),
                       div(class="right",
                           strong("University of Minnesota"),
                           br(),
                           "http://twin-cities.umn.edu/",
                           br(),
                           "612-625-5000"
                           )
                       ),
                   div(class="umnhf", id="umnhf-h-mast",
                       tags$a(class="umnhf", id="umnhf-h-logo", href="http://twin-cities.umn.edu/", style="margin-left: 0px;",
                              tags$span("Go to the U of M home page")
                              )
                       )
                   )
               ),
           div(class="navbar-header page-scroll",
               tags$button(type="button", class="navbar-toggle", "data-toggle"="collapse", "data-target"="#navbar_links",
                           tags$span(class="sr-only", "Toggle navigation"),
                           "Menu ",
                           tags$i(class="fa fa-bars")
                           ),
               tags$a(class="navbar-brand page-scroll", href="#page-top", title)
               ),
           div(class="collapse navbar-collapse", id="navbar_links",
               tags$ul(class="nav navbar-nav navbar-right",
                       tags$li(class="hidden",
                               tags$a(href="#page-top")
                               ),
                       tags$li(
                         tags$a(id="btn-about", class="page-scroll","About")
                         )
                       )
               )
           )
}