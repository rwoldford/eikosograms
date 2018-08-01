## ----setup, include=FALSE------------------------------------------------
knitr::opts_chunk$set(echo = TRUE)
library(knitr)
set.seed(12314159)

## ----set up conditional independence tables, eval = TRUE, echo = FALSE----
# This function will create all the joint probabilities
# and place them in the appropriate three-way table
create3WayBinaryTable <- function(widths, heights) {
    toprow_eikos <- widths * (1 - heights)
    bottomrow_eikos <- widths * heights
    probs <- array(c(bottomrow_eikos, toprow_eikos),
                  dim = c(2,2,2),
                  dimnames = list(Z = c("z1", "z2"),
                                  X = c("x1", "x2"),
                                  Y = c("y1", "y2")
                  ))
    as.table(probs)
}
# Marginal probabilities (widths) for 
# the two binary conditioning variates
# are given by the xz values,
# and the conditional probabilities (heights)
# for the response variate's first value
# are given by the b values.
# Figure numbers here refer to those figure numbers of
# the original Oldford (2003) article entitled
# "Understanding probabilistic independence and its 
#  modelling via Eikosograms and graphs."
xz1 <- c(2/7, 8/35, 1/7, 12/35)
b1 <- c(4/5, 1/2, 3/10, 7/10)
fig5a_data <-  create3WayBinaryTable(xz1, b1)
b2 <- c(4/5, 1/2, 3/5, 1/5)
fig5b_data <-  create3WayBinaryTable(xz1, b2)
b3 <- c(4/5, 1/2, 4/5, 1/2)
fig5c_data <-  create3WayBinaryTable(xz1, b3)
b4 <- c(7/10, 7/10, 7/10, 7/10)
fig6_data <- create3WayBinaryTable(xz1, b4)
xz2 <- c(10/33, 4/11, 5/33, 2/11)
fig7_data <- create3WayBinaryTable(xz2, b4)
xz3 <- c(1/3, 1/6, 1/3, 1/6)
b5 <- c(7/10, 7/10, 3/10, 3/10)
fig8_data <- create3WayBinaryTable(xz2, b5)
xz4 <- c(2/9, 1/9, 2/9, 4/9)
b6 <- c(2/3, 2/3, 1/6, 1/6)
fig9_data <- create3WayBinaryTable(xz4, b6)
xz5 <- c(1/7, 1/7, 3/7, 2/7)
b7 <- c(1/3, 2/3, 1/4, 1/6)
fig11_data <- create3WayBinaryTable(xz5, b7)
xz6 <- c(1/4, 1/4, 1/4, 1/4)
b8 <- c(3/4, 1/2, 1/4, 1/4)
fig12_data <- create3WayBinaryTable(xz6, b8)
xz7 <- c(1/3, 1/6, 1/3, 1/6)
b9 <- c(2/3, 1/2, 5/6, 1/6)
fig13_data <- create3WayBinaryTable(xz7, b9)
xz8 <- c(1/6, 1/3, 1/6, 1/3)
b10 <- c(1/6, 2/3, 5/6, 1/3)
fig14_data <- create3WayBinaryTable(xz8, b10)

# Create this now for early illustration
cond_indep <- fig5c_data

## ----independence Y given X, echo = FALSE, fig.width=4, fig.height=3.5, fig.align="center", out.width="50%", fig.cap = "Independence of variates X and Y"----
independenceExample <- as.table(array(c(10, 40, 15, 60),
                        dim = c(2,2),
                        dimnames = 
                        list(X =c("x_1", "x_2"), 
                             Y = c("y_1", "y_2"))))

## ----bivariate independence, echo = TRUE, fig.width=4, fig.height=3.5, fig.align="center", out.width="50%", fig.cap = "Independence of variates X and Y"----
library(eikos)
eikos("Y", "X", data = independenceExample)
eikos("X", "Y", data = independenceExample)

## ----conditional independence, echo = TRUE, fig.width=4, fig.height=3.5, fig.align="center", out.width="50%", fig.cap = "Conditional independence of variates X and Y"----
eikos("Y", c("X",  "Z"), data = cond_indep, xaxs = FALSE, yaxs = FALSE)

## ----conditional independence tables display, echo = TRUE, eval = FALSE----
#  # This function will create all the joint probabilities
#  # and place them in the appropriate three-way table
#  create3WayBinaryTable <- function(widths, heights) {
#      toprow_eikos <- widths * (1 - heights)
#      bottomrow_eikos <- widths * heights
#      probs <- array(c(bottomrow_eikos, toprow_eikos),
#                    dim = c(2,2,2),
#                    dimnames = list(Z = c("z1", "z2"),
#                                    X = c("x1", "x2"),
#                                    Y = c("y1", "y2")
#                    ))
#      as.table(probs)
#  }
#  # Marginal probabilities (widths) for
#  # the two binary conditioning variates
#  # are given by the xz values,
#  # and the conditional probabilities (heights)
#  # for the response variate's first value
#  # are given by the b values.
#  # Figure numbers here refer to those figure numbers of
#  # the original Oldford (2003) article entitled
#  # "Understanding probabilistic independence and its
#  #  modelling via Eikosograms and graphs."
#  xz1 <- c(2/7, 8/35, 1/7, 12/35)
#  b1 <- c(4/5, 1/2, 3/10, 7/10)
#  fig5a_data <-  create3WayBinaryTable(xz1, b1)
#  b2 <- c(4/5, 1/2, 3/5, 1/5)
#  fig5b_data <-  create3WayBinaryTable(xz1, b2)
#  b3 <- c(4/5, 1/2, 4/5, 1/2)
#  fig5c_data <-  create3WayBinaryTable(xz1, b3)
#  b4 <- c(7/10, 7/10, 7/10, 7/10)
#  fig6_data <- create3WayBinaryTable(xz1, b4)
#  xz2 <- c(10/33, 4/11, 5/33, 2/11)
#  fig7_data <- create3WayBinaryTable(xz2, b4)
#  xz3 <- c(1/3, 1/6, 1/3, 1/6)
#  b5 <- c(7/10, 7/10, 3/10, 3/10)
#  fig8_data <- create3WayBinaryTable(xz2, b5)
#  xz4 <- c(2/9, 1/9, 2/9, 4/9)
#  b6 <- c(2/3, 2/3, 1/6, 1/6)
#  fig9_data <- create3WayBinaryTable(xz4, b6)
#  xz5 <- c(1/7, 1/7, 3/7, 2/7)
#  b7 <- c(1/3, 2/3, 1/4, 1/6)
#  fig11_data <- create3WayBinaryTable(xz5, b7)
#  xz6 <- c(1/4, 1/4, 1/4, 1/4)
#  b8 <- c(3/4, 1/2, 1/4, 1/4)
#  fig12_data <- create3WayBinary Table(xz6, b8)
#  xz7 <- c(1/3, 1/6, 1/3, 1/6)
#  b9 <- c(2/3, 1/2, 5/6, 1/6)
#  fig13_data <- create3WayBinaryTable(xz7, b9)
#  xz8 <- c(1/6, 1/3, 1/6, 1/3)
#  b10 <- c(1/6, 2/3, 5/6, 1/3)
#  fig14_data <- create3WayBinaryTable(xz8, b10)
#  
#  # Create this now for early illustration
#  cond_indep <- fig5c_data

## ------------------------------------------------------------------------
fig14_data
sum(fig14_data)

## ----complete independence code, eval = FALSE----------------------------
#  complete_indep <- fig7_data
#  eikosY <- eikos(y="Y", x = c("Z", "X"),
#                  xaxs = FALSE, yaxs= FALSE,
#                  data = complete_indep, draw = FALSE)
#  eikosX <- eikos(y="X", x = c("Z", "Y"),
#                  xaxs = FALSE, yaxs= FALSE,
#                  data = complete_indep, draw = FALSE)
#  eikosZ <- eikos(y="Z", x = c("X", "Y"),
#                  xaxs = FALSE, yaxs= FALSE,
#                  data = complete_indep, draw = FALSE)

## ----complete independence eikos, echo = FALSE, fig.width=12, fig.height=3.5, fig.align="center", out.width="100%"----
complete_indep <- fig7_data
eikosY <- eikos(y="Y", x = c("Z", "X"), 
                xaxs = FALSE, yaxs= FALSE,
                data = complete_indep, draw = FALSE)
eikosX <- eikos(y="X", x = c("Z", "Y"), 
                xaxs = FALSE, yaxs= FALSE,
                data = complete_indep, draw = FALSE)
eikosZ <- eikos(y="Z", x = c("X", "Y"), 
                xaxs = FALSE, yaxs= FALSE,
                data = complete_indep, draw = FALSE)

## ----complete independence arrange 3, echo = TRUE, fig.width=12, fig.height=3.5, fig.align="center", fig.cap = "Complete independence", out.width="100%"----
library(gridExtra)
grid.arrange(eikosY, eikosX, eikosZ, nrow=1)

## ------------------------------------------------------------------------
library(eikos)


eikos(y="Y", x = c("Z", "X"), 
      data = create3WayBinaryTable(xz1, b2))

eikos(y="Y", x = c("Z", "X"), 
      data = create3WayBinaryTable(xz1, b3))
eikos(y="Y", x = c("X", "Z"), 
      data = create3WayBinaryTable(xz1, b3))

eikos(y="Y", x = c("Z", "X"), 
      data = create3WayBinaryTable(xz1, b4))


eikos(y="Y", x = c("Z", "X"), 
      data = create3WayBinaryTable(xz2, b4))
eikos(y="Y", x = c("Z", "X"), 
      data = create3WayBinaryTable(xz3, b5))
eikos(y="Y", x = c("Z", "X"), 
      data = create3WayBinaryTable(xz4, b6))
eikos(y="Y", x = c("Z", "X"), 
      data = create3WayBinaryTable(xz5, b7))
eikos(y="Y", x = c("Z", "X"), 
      data = create3WayBinaryTable(xz6, b8))
eikos(y="Y", x = c("Z", "X"), 
      data = create3WayBinaryTable(xz7, b9))
eikos(y="Y", x = c("Z", "X"), 
      data = create3WayBinaryTable(xz8, b10))


