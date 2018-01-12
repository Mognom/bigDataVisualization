#
#   ui.r
#

library(shiny) 
library(leaflet)

shinyUI(pageWithSidebar(
  
  headerPanel("Yelp Dataset Visualization"), 
  
  sidebarPanel(
    
    h3('Search Parameters'),
    
    sliderInput("stars",label= h3("Number of Stars"),min=1,max=5,value=c(1,5)),   
    checkboxInput("takeout",label="Take-out",value=TRUE),
    checkboxInput("reserve", label="Takes Reservations",value=TRUE),
    checkboxInput("wifi",label="Free Wi-Fi",value=TRUE),
    checkboxInput("caters",label="Caters",value=TRUE)
    
  ),
  
  mainPanel(
    leafletOutput("map",width="100%",height=500)  
  ) ))
