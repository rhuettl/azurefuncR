library(jsonlite)
library(plumber)
library(ChainLadder)

#* Echo back the input
#* @param msg The message to echo
#* @get /api/msg
function(msg="") {
  list(msg = paste0("The message is: '", msg, "'"))
}

#* Calculate triangle by ChainLadder
#* @param req The triange in JSON format
#* @post /api/square
function(req){
  bodyList <- jsonlite::fromJSON(req$postBody)
  triangleDF <- bodyList$data
  triangle <- as.triangle(bodyList)
  chainLadderModel <- suppressWarnings({MackChainLadder(triangle,
                                                        weights = 1,
                                                        alpha=1,
                                                        est.sigma="log-linear",
                                                        tail=FALSE,
                                                        tail.se=NULL,
                                                        tail.sigma=NULL,
                                                        mse.method="Mack")})
  squaREDF <- as.data.frame(chainLadderModel$FullTriangle)
  return(squaREDF)
}
