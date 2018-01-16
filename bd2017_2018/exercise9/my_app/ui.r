#
#   ui.r
#

library(shiny) 
library(leaflet)

shinyUI(pageWithSidebar(
  
  headerPanel("Yelp Dataset Visualization"), 
  
  sidebarPanel(
    
    h3('Search Parameters'),
    
    sliderInput("stars",label="Number of Stars",min=1,max=5,value=c(1,5)), 
    sliderInput("RestaurantsPriceRange2",label="Restaurants price range",min=1,max=3,value=c(1,3)),   
    checkboxInput("takeout",label="Take-out",value=TRUE),
    checkboxInput("reserve", label="Takes reservations",value=TRUE),
    checkboxInput("wifi",label="Free Wi-Fi",value=TRUE),
    checkboxInput("caters",label="Caters",value=TRUE),
    checkboxInput("groups",label="Good for groups",value=TRUE),
    checkboxInput("outdoor",label="Outdoors seating",value=TRUE),
    checkboxInput("smoking",label="Smoking",value=TRUE)
    
  ),
  
  mainPanel(
    leafletOutput("map",width="100%",height=500)  
  ) ))
