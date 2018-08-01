## ------------------------------------------------------------------------
knitr::kable(apply(HairEyeColor, 1:2, sum))

## ---- message=FALSE, fig.width=4, fig.height=3---------------------------
library(eikos)
eikos("Hair", "Eye", data = HairEyeColor, xaxs=FALSE, yaxs=FALSE)

## ---- message=FALSE, warning=FALSE, fig.width=4, fig.height=3------------
eikos("Eye", "Hair", data=HairEyeColor, xaxs=FALSE, yaxs=FALSE)

## ---- fig.width=4, fig.height=3------------------------------------------
eikos(Eye~Hair, data=HairEyeColor)

## ---- message=FALSE, warning=FALSE, fig.width=4, fig.height=3------------
eikos("Eye", "Hair", data = HairEyeColor, xaxs=TRUE, yaxs=TRUE)

