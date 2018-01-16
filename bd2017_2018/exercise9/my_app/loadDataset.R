

install.packages("jsonlite")
install.packages("leaflet")
install.packages("UsingR")
library(jsonlite)
library(leaflet)
library(UsingR)

bus_dat <- fromJSON(sprintf("[%s]", paste(readLines("./data/business.json"), collapse=",")))

# there are many business categories: hotels, services...
cats<-bus_dat$categories
listcats<-unlist(cats)
allcat<-table(listcats)
category_table<-as.data.frame(allcat)

# we are just interested in restaurants
restaurants<-grep(pattern="Restaurants",bus_dat$categories)

bars<-bus_rest<-bus_dat[restaurants,]
busrates <- data.frame(bus_rest$business_id,
                        bus_rest$stars,
                        bus_rest$longitude,
                        bus_rest$latitude,
                        bus_rest$state,
                        bus_rest$attributes$RestaurantsTakeOut,
                        bus_rest$attributes$RestaurantsReservations,
                        bus_rest$attributes$WiFi,
                        bus_rest$attributes$Caters,
                        bus_rest$attributes$RestaurantsPriceRange2,
                        bus_rest$attributes$RestaurantsGoodForGroups,
                        bus_rest$attributes$OutdoorSeating,
                        bus_rest$attributes$Smoking)

cc<-complete.cases(busrates)
business<-busrates[cc,]
write.table(business,"business.dat")

tip <- fromJSON(sprintf("[%s]", paste(readLines("./data/tip.json"), collapse=",")))
