#' Create eikosogram data frame
#'
#' @description Eikos helper function used to convert data.
#'
#' @param y response variable.
#' @param x conditional variables.
#' @param data data frame or table to be converted.
#' @param marginalize varibale to marginalize on, NULL if none.
eikos_data <- function(y, x, data, marginalize=NULL) {

    # Make sure x and marginalize are vectors of unique variates
    if (is.character(x)) {x <- c(x)}
    x <- unique(x)

    if (is.character(marginalize)) {marginalize <- c(marginalize)}
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
    idf <- idf[,c(allvars,"Freq")]
    idf <- unique(ddply(idf, allvars, transform, Freq=sum(Freq)))

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

                idf <- ddply(idf, setdiff(x, marginalize), transform, total.freq = sum(Freq))
            }
            idf <- ddply(idf, x, transform, m = sum(Freq)/total.freq)
            idf <- ddply(idf, c(y, setdiff(x, marginalize)), transform, Freq=sum(Freq)*m)
        }
    }


    # Scale to [0,1]x[0,1], and compute boundaries of each of the regions to be drawn
    if (!is.null(x)){
        idf <- ddply(idf, x, transform, MarginProb=Freq/sum(Freq))
        idf <- ddply(idf, x, transform, ymax=cumsum(MarginProb))
        idf <- ddply(idf, x, transform, ymin=ymax - MarginProb)

        idf$total_freq <- sum(idf$Freq)

        idf <- ddply(idf, x, transform, CondProb=sum(Freq)/total_freq)
        # The order of the data frame when we do a cumulative sum to calculate the xmax
        # value is important. It should be sorted first by the response variable, and then
        # by the reverse of the conditioning variables list (so that we split on the
        # first conditioning variable, then the second, then the third, etc)
        idf <- idf[do.call(order, idf[,c(y,rev(x))]),]
    } else {
        idf$MarginProb <- idf$Freq/sum(idf$Freq)
        idf$ymax <- cumsum(idf$MarginProb)
        idf$ymin <- idf$ymax - idf$MarginProb
        idf$CondProb <- 1
    }
    idf <- ddply(idf, y, transform, xmax=cumsum(CondProb))
    idf <- ddply(idf, y, transform, xmin=xmax - CondProb)

    return(idf)
}
