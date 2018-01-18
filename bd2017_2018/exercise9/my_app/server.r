# 
#  server.r
#


library(jsonlite)
library(UsingR)
library(leaflet)
library(maps)
library(DT)
library(shinyjs)

# Read pre-processed data
business <- read.csv("https://media.githubusercontent.com/media/Mognom/bigDataVisualization/master/bd2017_2018/exercise9/my_app/business.csv")
tip = read.csv("https://media.githubusercontent.com/media/Mognom/bigDataVisualization/master/bd2017_2018/exercise9/my_app/tip.csv")

shinyServer(
  
 
  function(input, output, session) {

    values<-reactiveValues()
    values$show <- FALSE
    
    output$show <- reactive({
      return(values$show)
    })
    
    observe({
      values$show <- TRUE
    })
    
    
    output$map <-renderLeaflet({      
      
      # for ranges
      lower<-1
      upper<-5
      
      # We will keep business as our reference version of the data and filter into the business_filtered variable
      business_filtered = business   
    
      # filter takeout 
      wo <- (business_filtered$bus_rest.attributes.RestaurantsTakeOut == input$takeout)
      business_filtered<-business_filtered[wo,]
      
      # filter reservations
      wo <- (business_filtered$bus_rest.attributes.RestaurantsReservations == input$reserve)
      business_filtered<-business_filtered[wo,]
      
      
      # filter Caters
      wo <- (business_filtered$bus_rest.attributes.Caters == input$caters)
      business_filtered<-business_filtered[wo,]
      
      
      # filter groups
      wo <- (business_filtered$bus_rest.attributes.RestaurantsGoodForGroups == input$groups)
      business_filtered<-business_filtered[wo,]
      
      
      # filter outdoor
      wo <- (business_filtered$bus_rest.attributes.OutdoorSeating == input$outdoor)
      business_filtered<-business_filtered[wo,]
  
      
      # filter on stars
      lower<-as.numeric(input$stars[1])
      wo <- business_filtered$bus_rest.stars >= lower
      business_filtered<-business_filtered[wo,]

      upper<-as.numeric(input$stars[2])
      wo <- business_filtered$bus_rest.stars <= upper

      business_filtered<-business_filtered[wo,]

      
      # generate map        
      map <- leaflet() %>% 
        addTiles(urlTemplate = "http://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}.png")  %>%  
        mapOptions(zoomToLimits="always") %>%             
        addMarkers(lat = business_filtered$bus_rest.latitude,
                   lng = business_filtered$bus_rest.longitude,
                   layerId = business_filtered$bus_rest.business_id,
                   clusterOptions = markerClusterOptions(),
                   popup = business_filtered$bus_rest.name)
      map
    })
    

    # When map is clicked, show a popup with the name of the restaurant
    observeEvent(input$map_marker_click, {
      click <- input$map_marker_click
      if (is.null(click))
        return()

      text<-paste("You've selected point ", click$id, " Lattitude ", click$lat, " Longitude ", click$lng)
      print(text)
      values$show <- TRUE
      restaurant_comments <- subset(tip[tip$business_id==click$id, ], select=c("date", "text"))
      
      # choose the column to display just the user comment
      output$tip <- DT::renderDataTable(
        restaurant_comments
      )
      
      
      # # Define a reactive expression for the document term matrix
      terms <- reactive({
       
          withProgress({
            setProgress(message = "Processing corpus...")
            getTermMatrix(restaurant_comments)
        })
      })


      # Make the wordcloud drawing predictable during a session
      wordcloud_rep <- repeatable(wordcloud)

      output$plot <- renderPlot({
        v <- terms()
        wordcloud_rep(names(v), v, scale=c(4,0.5),
                      min.freq = input$freq, max.words=input$max,
                      colors=brewer.pal(8, "Dark2"))
      })
      outputOptions(output, "show", suspendWhenHidden = FALSE) 

    })
    
    # Using "memoise" to automatically cache the results
    getTermMatrix <- memoise(function(restaurant_comments) {
      
      myCorpus = Corpus(VectorSource(restaurant_comments$text))
      myCorpus = tm_map(myCorpus, content_transformer(tolower))
      myCorpus = tm_map(myCorpus, removePunctuation)
      myCorpus = tm_map(myCorpus, removeNumbers)
      myCorpus = tm_map(myCorpus, removeWords,
                        c(stopwords("SMART"), "thy", "thou", "thee", "the", "and", "but"))
      
      myDTM = TermDocumentMatrix(myCorpus,
                                 control = list(minWordLength = 1))
      
      m = as.matrix(myDTM)
      
      sort(rowSums(m), decreasing = TRUE)
    })
    
    counts <- table(business$bus_rest.stars)
    output$plotReviews <- renderPlot({
      barplot(counts, main="Stars distribution", horiz=FALSE,
              names.arg=c("1 star", "1.5 stars", "2 stars", "2.5 stars","3 stars", "3.5 stars", "4 stars", "4.5 stars", "5 stars"))
    })

  }
)
