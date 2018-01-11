

library(jsonlite)

# load data from json file

review <- stream_in(file("./data/review.json"))
tip <- stream_in(file("./data/tip.json"))
business <- stream_in(file("./data/business.json"))
user <- stream_in(file("./data/user.json"))
checkin <- stream_in(file("./data/checkin.json"))
photos <- stream_in(file("./data/photos.json"))

# flat data

review_flat <- flatten(review)
tip_flat <- flatten(tip)
business_flat <- flatten(business)
user_flat <- flatten(user)
checkin_flat <- flatten(checkin)
photos_flat <- flatten(photos)

# transform into a data frame

review_tbl <- as.data.frame(review_flat)
tip_tbl <- as.data.frame(tip_flat)
business_tbl <- as.data.frame(business_flat)
user_tbl <- as.data.frame(user_flat)
checkin_tbl <- as.data.frame(checkin_flat)
photos_tbl <- as.data.frame(photos_flat)

