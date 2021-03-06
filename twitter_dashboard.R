library(rtweet)
library(magrittr)
library(dplyr)
library(DT)
library(widgetframe)

# Pull likes from my twitter handle
username <- "theaknowles"


# Do same with my_retweets
my_retweets <- get_timeline(username, n=100) %>%
     subset((is_retweet==TRUE | is_quote==TRUE)) %>%
     select("created_at", "text", "hashtags", "urls_expanded_url")
     arrange(desc(created_at))

# Tutorial done with likes and not retweets
#my_likes  <- get_favorites(username, n = 100) %>% 
#     select("created_at", "screen_name", "text", "urls_expanded_url") %>%
#     arrange(desc(created_at))


# Get rid of time in dashboard
my_retweets$created_at <- strptime(as.POSIXct(my_retweets$created_at), 
                                format = "%Y-%m-%d")
my_retweets$created_at <- format(my_retweets$created_at, "%Y-%m-%d")

# Make URLs clickable
createLink <- function(x) {
     if(is.na(x)){
          return("")
     }else{
          sprintf(paste0('<a href="', URLdecode(x),'" target="_blank">', 
                         substr(x, 1, 25) ,'</a>'))
     }
}

my_retweets$urls_expanded_url <- lapply(my_retweets$urls_expanded_url, 
                                     function(x) sapply(x, createLink))

# Make dashboard
my_table <- datatable(my_retweets, 
                      options = list(scrollX = TRUE, autoWidth = TRUE,
                                     columnDefs = list(list(
                                          width = '70%', 
                                          targets = c(2)))), 
                      rownames = FALSE,
                      fillContainer = TRUE,
                      width = "100%",
                      colnames = c("Date", "Text", "Hashtags", "URL"))

my_table <- formatStyle(my_table, columns = 1:4, fontSize = '100%')
my_table <- formatStyle(my_table, columns = 2, width = '800px')
#my_table

#temp_file <- tempfile()
#saveWidget(my_table, temp_file)


# doesn't work
#system(paste("chrome", temp_file))


widgetframe::frameWidget(my_table, width = "100%", height = 800, 
            options = frameOptions(allowfullscreen = TRUE))



