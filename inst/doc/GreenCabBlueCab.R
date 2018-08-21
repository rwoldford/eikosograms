## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
library(knitr)
set.seed(12314159)

## ----libraries-----------------------------------------------------------
library(eikosograms)

## ----cab data------------------------------------------------------------
HitAndRun <- as.table(array(c(12, 17, 3, 68), 
                            dim = c(2,2),
                            dimnames = list(
                                Cab = c("Blue", "Green"), 
                                Witness = c("Blue", "Green"))
                            )
                      )

## ----print table, echo=FALSE, message=FALSE, fig.align="center", fig.width=4, fig.height=3.5, out.width ="50%"----
knitr::kable(addmargins(prop.table(HitAndRun)))

## ----first eikosogram, echo=TRUE, message=FALSE, fig.align="center", fig.width=4, fig.height=3.5, out.width ="50%"----
eikos(y = "Witness", x = "Cab", data = HitAndRun, 
      bottomcol = "grey")

## ----cab solution, echo=TRUE, message=FALSE, fig.align="center", fig.width=4, fig.height=3, out.width ="50%"----
eikos(y = "Cab", x = "Witness", data = HitAndRun, 
      bottomcol = "grey")

