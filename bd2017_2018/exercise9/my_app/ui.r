#
#   ui.r
#

library(shiny) 
library(leaflet)

shinyUI(pageWithSidebar(
  
  headerPanel("Yelp dataset restaurants reviews visualization"), 
  
  sidebarPanel(
    
    h3('Search parameters'),
    sliderInput("stars",label="Number of stars",min=1,max=5,value=c(1,5)), 
    checkboxInput("takeout",label="Take-out",value=TRUE),
    checkboxInput("reserve", label="Takes reservations",value=TRUE),
    checkboxInput("caters",label="Caters",value=TRUE),
    checkboxInput("groups",label="Good for groups",value=TRUE),
    checkboxInput("outdoor",label="Outdoor seating",value=TRUE),
    plotOutput("plotReviews", click = "plot_click")
  ),
  
  mainPanel(
    h4("Interactive map"),
    leafletOutput("map",width="100%",height=500),
    conditionalPanel(condition = "output.show",
      h4("Customers opinions"),
      tabsetPanel(
        id = 'dataset',
        tabPanel( "Words cloud",
                  mainPanel(
                    plotOutput("plot", width = "110%", height = "450px"),
                    hr(),
                    sliderInput("freq","Minimum Frequency:", min = 1,  max = 50, value = 15),
                    sliderInput("max", "Maximum Number of Words:", min = 1,  max = 100,  value = 90)
                  )
        ),
        tabPanel("User comments", DT::dataTableOutput("tip"))
      )
    ) 
  )
)
)