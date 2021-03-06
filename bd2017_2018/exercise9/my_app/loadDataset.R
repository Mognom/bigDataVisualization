

install.packages("jsonlite")
install.packages("leaflet")
install.packages("UsingR")
install.packages("DT")
install.packages("slam")
install.packages("tm")
install.packages("wordcloud")
install.packages("memoise")
install.packages("maps")
install.packages("shinyjs")

library(jsonlite)
library(leaflet)
library(UsingR)
library(DT)
library(shiny)
library(tm)
library(wordcloud)
library(memoise)
library(maps)

setwd("~/git/bigDataVisualization/bd2017_2018/exercise9/my_app")

bus_dat <- fromJSON(sprintf("[%s]", paste(readLines("./data/business.json"), collapse=",")))

# there are many business categories: hotels, services...
# cats<-bus_dat$categories
# listcats<-unlist(cats)
# allcat<-table(listcats)
# category_table<-as.data.frame(allcat)

# we are just interested in restaurants
restaurants<-grep(pattern="Restaurants",bus_dat$categories)

# useful columns
bars<-bus_rest<-bus_dat[restaurants,]
busrates <- data.frame(bus_rest$business_id,
                        bus_rest$stars,
                        bus_rest$longitude,
                        bus_rest$latitude,
                        bus_rest$state,
                        bus_rest$attributes$RestaurantsTakeOut,
                        bus_rest$attributes$RestaurantsReservations,
                        bus_rest$attributes$Caters,
                        bus_rest$attributes$RestaurantsGoodForGroups,
                        bus_rest$attributes$OutdoorSeating,
                        bus_rest$name)

cc<-complete.cases(busrates)
business<-busrates[cc,]

# we are also interested in customers opinions and reviews
tip <- fromJSON(sprintf("[%s]", paste(readLines("./data/tip.json"), collapse=",")))

# export cleaned data to upload it to an online repository
write.csv(business,"business.csv")
write.csv(tip,"tip.csv")


# Gather some metrics and plot
# num_bus<-nrow(bus_dat)
# num_rest<-nrow(bars)
# num_complete<-nrow(busrates)
# barplot(c(num_bus,num_rest,num_complete, main="Number of business",names.arg=c("Businesses","Restaurants","Full Service")))


