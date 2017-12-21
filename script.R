library(readr)
library(dplyr)

# Test file with same columns
# file <- "MOCK_DATA.csv"
# Automatic names are generated when making the spreadsheet like "Dirección de 
# correo electrónico" which is basically "email" 🤷
df <- read_csv(file) %>% 
  rename(email = `Dirección de correo electrónico`) %>%
  rename(name = Name) 

set.seed(525)
dat <- df %>%
  select(name) %>%
  mutate(name = sample(name)) %>%
  mutate(partner = lag(name))
dat$partner[1] <- dat$name[nrow(dat)]

df_name <- df[ , c("name", "email")]
df_partner <- df[ , c("name", "Interests", "Address")]
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

<img src = 'https://media.giphy.com/media/zhPXoVIBMtnUs/giphy.gif'> </img>

Also, don't forget to send your gift to

<b>{Address}</b>

Have the best of Christmas,
R-Ladies"

our_template <- glue::glue(glitter_template)

parcel <- parcel_create(dat, sender_name = "BR-Lady, sender_email = "temailgmail.com",
                        subject = "Polyanna!", template = our_template)

parcel_preview(parcel)     

parcel_send(parcel)
