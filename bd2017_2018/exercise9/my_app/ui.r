#
#   ui.r
#

library(shiny) 
library(leaflet)

shinyUI(pageWithSidebar(
  
  headerPanel("Yelp Dataset Visualization"), 
  
  sidebarPanel(
    
    h3('Search parameters'),
    sliderInput("stars",label="Number of stars",min=1,max=5,value=c(1,5)), 
    checkboxInput("takeout",label="Take-out",value=TRUE),
    checkboxInput("reserve", label="Takes reservations",value=TRUE),
    checkboxInput("wifi",label="Free Wi-Fi",value=TRUE),
    checkboxInput("caters",label="Caters",value=TRUE),
    checkboxInput("groups",label="Good for groups",value=TRUE),
    checkboxInput("outdoor",label="Outdoor seating",value=TRUE)
  ),
  
  mainPanel(
    h4("Map"),
    leafletOutput("map",width="100%",height=500),
    h4("Customers opinions"),
    tabsetPanel(
      id = 'dataset',
      tabPanel("User comments", DT::dataTableOutput("tip")),
      tabPanel( "Words cloud",
        sidebarLayout(
          sliderInput("freq","Minimum Frequency:", min = 1,  max = 50, value = 15),
          sliderInput("max", "Maximum Number of Words:", min = 1,  max = 300,  value = 100),
          # plotOutput("plot")
          )
      )
    )
  ) 
)
)