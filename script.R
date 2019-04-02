library(readr)
library(dplyr)

gmailr::gmail_auth(scope = "full", id = '171060509499-hach115o8h2od4t45q6nobp97jcgpch4.apps.googleusercontent.com', secret = 'VWsKb5RB9w7o67tlyR7Lzwb-')

# Test file with same columns
# file <- "MOCK_DATA.csv"

# Automatic names are generated when making the spreadsheet like "Dirección de 
# correo electrónico" which is basically "email" 🤷
df <- read_csv("R-Ladies 2018 Polyanna (Respuestas) - Respuestas de formulario 1.csv") %>% 
  rename(email = `Dirección de correo electrónico`) %>%
  rename(name = Name) 

set.seed(999) # Set seed to reproduce matching in case not every mail gets to its destination
dat <- df %>%
  select(name) %>%
  mutate(name = sample(name)) %>%
  mutate(partner = lag(name))
dat$partner[1] <- dat$name[nrow(dat)]

df_name <- df[ , c("name", "email")]
df_partner <- df[ , c("name", "Interests", "Address", "Local websites")]
dat <- dat %>%
  left_join(df_name, c("name" = "name")) %>%
  left_join(df_partner, c("partner" = "name"))

### Send email
library(ponyexpress)
body <- "Dear {name},

  You have an important mission to complete, you have been assigned to surprise <b>{partner}</b> with a <3 gift. 
  Maybe you know each other, maybe you have talked some time, what we know is that {partner} told us she has the following interests:
  
  <b>{Interests}</b>
  
  We have set the limit to $15 or to a paperback book price, you know what we mean.
  
  <img src = 'https://media.giphy.com/media/EOsZWaNPaivrimwlqG/giphy.gif'> </img>
  
  And also, she is so nice she included some local websites for you to buy easier!
  
  <b>{`Local websites`}</b>
  
  Don't forget to send your gift to
  
  <b>{Address}</b>
  
  Have the best of Christmas,
  R-Ladies"

our_template <- glue::glue(glitter_template)
parcel <- parcel_create(dat, sender_name = "Sender", sender_email = "tatipatati@gmail.com",
                        subject = "Polyanna!", template = our_template)

parcel_preview(parcel)     

parcel_send(parcel[25, ])
