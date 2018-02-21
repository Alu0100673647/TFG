
library("rsconnect");

library("ROAuth"); # para autenticaci?n OAuth
library("base64enc"); # provee herramientas con base64 para ASCII
library("twitteR"); # libreria de twitter para R
library("streamR"); # Provee funciones en R para usuarios con acceso a twitter.

# Leer fichero credenciales
# cuando ejecutamos el PIN lo teniamos qu poner en consola para   q crear el ficher myoauth



#' notifies job status
#' 
#' sends a tweet to rmflight the job status
#' 
#' @param tweetText the text to include in the tweet
#' @export
#' @importFrom twitteR tweet

.onLoad <- function(libname, pkgname){
  cachedToken <- new.env()
  dataFile <- system.file("./my_oauth.RData", package="rmfNotifier")
  load(dataFile, cachedToken)
  assign("oauth_token", cachedToken$local_cache, envir=twitteR:::my_oauth)
  rm(cachedToken)
}

  fullTweet <- paste("@SAYAS91995364", "Notidicacion sayas", sep=" ") # change @username to where you want to recieve notifications
  tweet(fullTweet)