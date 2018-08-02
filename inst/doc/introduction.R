## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
library(knitr)
set.seed(12314159)

## ----eikosograms library, echo = TRUE, fig.width=4, fig.height=3, fig.align="center", out.width="50%"----
library(eikosograms)

## ---- echo = FALSE, message = FALSE, warning = FALSE, error = FALSE, fig.width=4, fig.height=3, fig.align="center", out.width="50%", fig.cap = "Application to Waterloo's Faculty of Mathematics (2017)"----
Waterloo <- data.frame(Decision = c(rep("Accepted", 1200), 
                                    rep("Rejected", 15200-1200)))
eikos("Decision", data = Waterloo)

## ----Berkeley table, echo = FALSE----------------------------------------
str(UCBAdmissions)

## ----UCB admissions, echo = TRUE, fig.width=4, fig.height=3, fig.align="center", out.width="50%"----
eikos("Admit", data = UCBAdmissions)

## ----UCB departments, echo = TRUE, fig.width=4, fig.height=3, fig.align="center", out.width="50%"----
eikos("Dept", data = UCBAdmissions)

## ----UCB gender marginals, echo = TRUE, fig.width=4, fig.height=3.5, fig.align="center", out.width="50%"----
eikos("Gender", data = UCBAdmissions)

## ----UCB Dept by male, echo = TRUE, fig.width=4, fig.height=3.5, fig.align="center", out.width="50%"----
eikos("Dept", data = UCBAdmissions[,"Male",], 
      main = "Applications from males")

## ----UCB Dept by female, echo = TRUE, fig.width=4, fig.height=3.5, fig.align="center", out.width="50%"----
eikos("Dept", data = UCBAdmissions[,"Female",], 
      main = "Applications from females")

## ----UCB Dept by gender, echo = TRUE, fig.width=4, fig.height=3, fig.align="center", out.width="50%"----
eikos(y = "Dept", x = "Gender",  data = UCBAdmissions,
      label_size = 8)

## ----admit given gender, echo = TRUE, fig.width=4, fig.height=3, fig.align="center", out.width="50%"----
eikos(y = "Admit", x = "Gender", data = UCBAdmissions)

## ----gender given admit, echo = TRUE, fig.width=4, fig.height=3, fig.align="center", out.width="50%"----
eikos(y = "Gender", x = "Admit", data = UCBAdmissions)

## ----independence Y given X, echo = TRUE, fig.width=4, fig.height=3.5, fig.align="center", out.width="50%", fig.cap = "Independence of variates X and Y"----
indep <- as.table(array(c(10, 40, 15, 60),
                        dim = c(2,2),
                        dimnames = 
                        list(X =c("x_1", "x_2"), 
                             Y = c("y_1", "y_2"))))
eikos("Y", "X", data = indep)

## ----independence X given Y, echo = TRUE, fig.width=4, fig.height=3.5, fig.align="center", out.width="50%", fig.cap = "Independence of variates X and Y"----
eikos("X", "Y", data = indep)

