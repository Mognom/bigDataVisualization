# 
#  loadDataset.r
#



 # install.packages("stringr")
 #  library(stringr)

#  


# load data from json file

 # review <- stream_in(file("./data/review.json"))
 # tip <- stream_in(file("./data/tip.json"))
 # business <- stream_in(file("./data/business-trunk.json"))
 # user <- stream_in(file("./data/user.json"))
 # checkin <- stream_in(file("./data/checkin.json"))
 # photos <- stream_in(file("./data/photos.json"))

# flat data

 # review_flat <- flatten(review)
 # tip_flat <- flatten(tip)
 # business_flat <- flatten(business)
 # user_flat <- flatten(user)
 # checkin_flat <- flatten(checkin)
 # photos_flat <- flatten(photos)

# transform into a data frame

 # review_tbl <- as.data.frame(review_flat)
 # tip_tbl <- as.data.frame(tip_flat)
 # business_tbl <- as.data.frame(business_flat)
 # user_tbl <- as.data.frame(user_flat)
 # checkin_tbl <- as.data.frame(checkin_flat)
 # photos_tbl <- as.data.frame(photos_flat)

# business <- stream_in(file("./data/business-trunk.json"))

install.packages("jsonlite")
library(jsonlite)

bus_dat <- fromJSON(sprintf("[%s]", paste(readLines("./data/business.json"), collapse=",")))

restaurants<-grep(pattern="Restaurants",bus_dat$categories)

bars<-bus_rest<-bus_dat[restaurants,]

birates <- data.frame(bus_rest$business_id, bus_rest$stars,
                      bus_rest$longitude, bus_rest$latitude,
                      bus_rest$state, 
                      bus_rest$attributes$RestaurantsTakeOut, bus_rest$attributes$RestaurantsReservations,
                      bus_rest$attributes$WiFi, bus_rest$attributes$Caters)

cc<-complete.cases(birates)
business<-birates[cc,]
write.table(business,"business.dat")


