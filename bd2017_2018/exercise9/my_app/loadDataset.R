

install.packages("jsonlite")
library(jsonlite)


bus_dat <- fromJSON(sprintf("[%s]", paste(readLines("./data/business.json"), collapse=",")))

#create a table of categories:
cats<-bus_dat$categories
listcats<-unlist(cats)
allcat<-table(listcats)
category_table<-as.data.frame(allcat)

#we want all related with tourism: restaurants and hotels
toMatch <- c("Restaurants", "Hotels")
matches <- unique (grep(paste(toMatch,collapse="|"), bus_dat$categories, value=TRUE))

bars<-bus_rest<-bus_dat[matches,]

birates <- data.frame(bus_rest$business_id, 
                      bus_rest$stars,
                      bus_rest$longitude, 
                      bus_rest$latitude,
                      bus_rest$state, 
                      bus_rest$attributes$RestaurantsTakeOut, 
                      bus_rest$attributes$RestaurantsReservations,
                      bus_rest$attributes$WiFi, bus_rest$attributes$Caters, 
                      bus_rest$categories)

cc<-complete.cases(birates)
business<-birates[cc,]
write.table(business,"business.dat")


