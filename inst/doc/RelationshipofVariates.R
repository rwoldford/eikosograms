## ---- echo=FALSE, fig.height=2.5, fig.width=3, message=FALSE-------------
library(eikos)
binIndep <- array(c(1,3,1,3), dim = c(2,2),
                  dimnames = list(X=c("x_1", "x_2"), Y = c("y_1", "y_2")))
eikos(Y~X, data=binIndep, xaxs = FALSE, yaxs = FALSE)
eikos(X~Y, data=binIndep, xaxs = FALSE, yaxs = FALSE)

## ---- echo=FALSE, fig.height=2.5, fig.width=3----------------------------
indepData <- array(rep(c(3,2,12,3),3), dim = c(4,3),
                   dimnames = list(X = c("x_1", "x_2", "x_3", "x_4"), Y = c("y_1", "y_2", "y_3")))
eikos("X", "Y", data = indepData, xaxs = FALSE, yaxs = FALSE)
eikos("Y", "X", data = indepData, xaxs = FALSE, yaxs = FALSE)

## ---- echo=FALSE---------------------------------------------------------
coincident <- array(c(0.3,0,0,0.7), dim = c(2,2),
                  dimnames = list(X=c("Yes", "No"), Y = c("Yes", "No")))
eikos("Y", "X", data = coincident, xaxs = T, yaxs = T, main = "Coincident")
mutualExclusive <- array(c(0,0.7,0.3,0), dim = c(2,2),
                  dimnames = list(X=c("Yes", "No"), Y = c("Yes", "No")))
eikos("Y", "X", data = mutualExclusive, xaxs = T, yaxs = T, main = "Mutually exclusive")
negAsso <- array(c(6, 56, 24, 14), dim = c(2,2),
                  dimnames = list(X=c("Yes", "No"), Y = c("Yes", "No")))
eikos("Y", "X", data = negAsso, xaxs = T, yaxs = T, main = "Negative Association")
posAsso <- array(c(24, 14, 6, 56), dim = c(2,2),
                  dimnames = list(X=c("Yes", "No"), Y = c("Yes", "No")))
eikos("Y", "X", data = posAsso, xaxs = T, yaxs = T, main = "Positive Association")

## ---- echo=FALSE, fig.width=2, fig.height=2------------------------------
par(mfrow=c(5,1))
eikos("Y", "X", data=mutualExclusive, main="Mutually exclusive")
eikos("Y", "X", data=negAsso, main="Negative Association")
eikos("Y", "X", data= binIndep, main="Independent")
eikos("Y", "X", data=posAsso, main="Positive Association")
eikos("Y", "X", data=coincident, main="Coincident")

## ---- echo=FALSE---------------------------------------------------------
joint <- array(c(6, 3, 12, 6, 10, 15, 10, 15), dim = c(2,2,2),
                  dimnames = list(X=c("X=Yes", "X=No"), Y = c("Y=Yes", "Y=No"), Z = c("Z=Yes", "Z=No")))
eikos("Y", c("X", "Z"), data = joint, xaxs = T, yaxs = T)
eikos("X", c("Z", "Y"), data = joint, xaxs = T, yaxs = T)
eikos("Z", c("Y", "X"), data = joint, xaxs = T, yaxs = T)

