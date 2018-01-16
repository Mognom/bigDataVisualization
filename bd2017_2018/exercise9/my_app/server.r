# 
#  server.r
#


library(jsonlite)
library(UsingR)
library(leaflet)
library(maps)
library(DT)

# Read pre-processed data
#
business<-read.table("business.dat")


shinyServer(
  
  function(input, output) {
    
    output$map <-renderLeaflet({      
      
      # for ranges
      lower<-1
      upper<-5
      
      # We will keep business as our reference version of the data and filter into the business_filtered variable
      business_filtered = business   
    
      # filter takeout 
      if (input$takeout)
        wo <- (business_filtered$bus_rest.attributes.RestaurantsTakeOut == TRUE)
      else
        wo <- (business_filtered$bus_rest.attributes.RestaurantsTakeOut == FALSE)
      business_filtered<-business_filtered[wo,]
      
      # filter reservations
      if (input$reserve)
        wo <- (business_filtered$bus_rest.attributes.RestaurantsReservations == TRUE)
      else
        wo <- (business_filtered$bus_rest.attributes.RestaurantsReservations == FALSE)
      business_filtered<-business_filtered[wo,]
      
      # filter WiFi
      if (input$wifi)
        wo <- (business_filtered$bus_rest.attributes.WiFi== "free")
      else
        wo <- (business_filtered$bus_rest.attributes.WiFi == FALSE)
      business_filtered<-business_filtered[wo,]
      
      
      # filter Caters
      if (input$caters)
        wo <- (business_filtered$bus_rest.attributes.Caters == TRUE)
      else
        wo <- (business_filtered$bus_rest.attributes.Caters == FALSE)
      business_filtered<-business_filtered[wo,]
      
      
      # filter groups
      if (input$groups)
        wo <- (business_filtered$bus_rest.attributes.RestaurantsGoodForGroups == TRUE)
      else
        wo <- (business_filtered$bus_rest.attributes.RestaurantsGoodForGroups == FALSE)
      business_filtered<-business_filtered[wo,]
      
      
      # filter outdoor
      if (input$outdoor)
        wo <- (business_filtered$bus_rest.attributes.OutdoorSeating == TRUE)
      else
        wo <- (business_filtered$bus_rest.attributes.OutdoorSeating == FALSE)
      business_filtered<-business_filtered[wo,]
  
      
      # filter on stars
      lower<-as.numeric(input$stars[1])
      wo <- business_filtered$bus_rest.stars >= lower
      business_filtered<-business_filtered[wo,]

      upper<-as.numeric(input$stars[2])
      wo <- business_filtered$bus_rest.stars <= upper

      business_filtered<-business_filtered[wo,]

      
      # generate map        
      mymap<-leaflet() %>% 
        addTiles() %>% 
        addTiles(urlTemplate = "http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png")  %>%  
        mapOptions(zoomToLimits="always") %>%             
        addMarkers(lat = business_filtered$bus_rest.latitude,
                   lng = business_filtered$bus_rest.longitude,
                   clusterOptions = markerClusterOptions(),
                   popup = business_filtered$bus_rest.business_id) 
      mymap
      
    })
    
    # choose the column to display just the user comment
    output$tip <- DT::renderDataTable({
      tip
    })
    
    # Make the wordcloud drawing predictable during a session
    wordcloud_rep <- repeatable(wordcloud)
    
    output$plot <- renderPlot({
      v <- terms()
      wordcloud_rep(names(v), v, scale=c(4,0.5),
                    min.freq = input$freq, max.words=input$max,
                    colors=brewer.pal(8, "Dark2"))
    })
    
  }
)
