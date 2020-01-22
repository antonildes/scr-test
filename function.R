


now()

funNumber <- function(){
  num = runif(1, 1, 10) %>% round(0) 
  if((num %% 2) == 0) {
    print(paste(num,"is Even"))
  } else {
    print(paste(num,"is Odd"))
  }
  
}

      

