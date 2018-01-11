
 # install.packages("stringr")
 #  library(stringr)

#  install.packages("jsonlite")
#  library(jsonlite)

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

business <- stream_in(file("./data/business-trunk.json"))


biz_dat <- fromJSON(sprintf("[%s]", paste(readLines("./data/business.json"), collapse=",")))

restaurants<-grep(pattern="Restaurants",biz_dat$categories)

bars<-biz_rest<-biz_dat[restaurants,]

bizrates<-data.frame(biz_rest$business_id, biz_rest$stars,
                     biz_rest$longitude,biz_rest$latitude, 
                     biz_rest$state,
                     biz_rest$attributes$`Take-out`,biz_rest$attributes$`Takes Reservations`,
                     biz_rest$attributes$`Wi-Fi`,biz_rest$attributes$Caters)
