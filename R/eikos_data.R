library(plyr)
#' Create eikosogram data frame
#'
#' @description Eikos helper function used to convert data.
#'
#' @param y response variable.
#' @param x conditional variables.
#' @param data data frame or table to be converted.
#' @param marginalize name of variable to marginalize on, NULL if none.
eikos_data <- function(y, x, data, marginalize = NULL) {

    # Make sure x and marginalize are vectors of unique variates
    x <- unique(x)
    marginalize <- unique(marginalize)

    # gather all the variates together
    allvars <- c(x, y)

    # data will be turned into a data frame (from a table)
    # containing the cell identifiers and the count (frequency)
    if (is.data.frame(data)) {
        idf <- as.data.frame(table(data[,allvars]))
        colnames(idf) <- c(allvars, "Freq")
    } else {
        if (is.table(data)){
            idf <- as.data.frame(data)
        } else {
            if (is.array(data)) {
                idf <- as.data.frame(as.table(data))
            } else {
                # print error message and quit
                stop("data argument must be either a table or a data frame.")
            }
        }
    }


    # Remove any extra variables and sum those Frequencies away to concentrate
    # on the vars identified by the user
    idf <- idf[, c(allvars, "Freq")]
    idf <- unique(ddply(idf, allvars, 
                        .fun = function(.idf){
                            data.frame(.idf[,allvars], Freq = sum(.idf$Freq))}
                        ))
    #
    # If there is to be marginalization,
    if (!is.null(marginalize)) {
        if (!is.null(x)) {
            if (!(all(marginalize %in% x))){
                stop("The variates being marginalized must be a subset of the conditioning variates.")
            }

            # OK to marginalize the data
            if (identical(sort(x),sort(marginalize))) {
                # because ddply doesn't like accepting NULL for variables to subset on
                idf$total.freq <- sum(idf$Freq)
            } else {
                # Need to make sure the marginalized variates are at the front of the
                # x list
                x <- c(marginalize, setdiff(x, marginalize))
                diffvars <- setdiff(x, marginalize)
                idf <- ddply(idf, diffvars, 
                             .fun = function(.idf){
                                 data.frame(.idf[,c(allvars, "Freq")], 
                                            total.freq = sum(.idf$Freq))
                                 }
                             )
            }
            idf <- ddply(idf, x, 
                         .fun = function(.idf){
                             data.frame(.idf, m = sum(.idf$Freq)/.idf$total.freq)
                             }
                         )
            idf <- ddply(idf, c(y, setdiff(x, marginalize)), 
                         .fun = function(.idf){
                             .idf$Freq <- sum(.idf$Freq) * .idf$m
                             .idf
                         }
            )
        }
    }


    # Scale to [0,1]x[0,1], and compute boundaries of each of the regions to be drawn
    if (!is.null(x)){
        idf$total_freq <- sum(idf$Freq)
        idf <- ddply(idf, x,
                     .fun = function(.idf){
                         .idf$MarginProb <- .idf$Freq / sum(.idf$Freq)
                         .idf$ymax <- cumsum(.idf$MarginProb)
                         .idf$ymin <- .idf$ymax - .idf$MarginProb
                         .idf$CondProb <- sum(.idf$Freq)/.idf$total_freq
                         .idf
                     }
                     )

        # The order of the data frame when we do a cumulative sum to calculate the xmax
        # value is important. It should be sorted first by the response variable, and then
        # by the reverse of the conditioning variables list (so that we split on the
        # first conditioning variable, then the second, then the third, etc)
        # 
        # Have to be careful here with the do.call 
        # If (and it will happen) the idf contains variable names that
        # match the arguments to order, then the do.call will fail on a match.arg error.
        # ... must/should be some base R function somewhere that does this ... rwo
        # 
        eikos_vars <- c(y, rev(x))
        if (any(eikos_vars %in% names(formals(order)))) {
            idfCopy <- idf[, eikos_vars]
            newNames <- paste0("eikos_var_", eikos_vars)
            names(idfCopy) <- newNames
            newOrder <- do.call(order, idfCopy)
        } else {
            newOrder <- do.call(order, idf[, eikos_vars])
        }
        idf <- idf[newOrder,]
        
    } else {
        idf$MarginProb <- idf$Freq/sum(idf$Freq)
        idf$ymax <- cumsum(idf$MarginProb)
        idf$ymin <- idf$ymax - idf$MarginProb
        idf$CondProb <- 1
    }
    idf <- ddply(idf, y,
                 .fun = function(.idf){
                     .idf$xmax <- cumsum(.idf$CondProb)
                     .idf$xmin <- .idf$xmax - .idf$CondProb
                     .idf
                 })

    return(idf)
}
