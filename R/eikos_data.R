#' Create eikosogram data frame
#'
#' @description Eikos helper function used to convert data.
#'
#' @param y response variable.
#' @param x conditional variables.
#' @param data data frame or table to be converted.
#' @param marginalize name of variable to marginalize on, NULL if none.
#' @importFrom stats aggregate ave
eikos_data <- function(y, x, data, marginalize = NULL) {
    
    x <- unique(x)
    marginalize <- unique(marginalize)
    allvars <- c(x, y)
    
    if (is.data.frame(data)) {
        idf <- as.data.frame(table(data[, allvars, drop = FALSE]))
        colnames(idf) <- c(allvars, "Freq")
    } else if (is.table(data)) {
        idf <- as.data.frame(data)
    } else if (is.array(data)) {
        idf <- as.data.frame(as.table(data))
    } else {
        stop("data argument must be either a table or a data frame.")
    }
    
    # Keep only requested variables + Freq, collapse duplicates by sum(Freq)
    idf <- idf[, c(allvars, "Freq"), drop = FALSE]
    idf <- aggregate(idf$Freq, idf[allvars], sum)
    names(idf)[names(idf) == "x"] <- "Freq"
    
    # ---------------------------------------------------------------------------
    # Marginalization (plyr-compatible: keeps total.freq and m columns)
    # ---------------------------------------------------------------------------
    if (!is.null(marginalize) && length(marginalize) > 0 &&
        !is.null(x) && length(x) > 0) {
        
        if (!all(marginalize %in% x)) {
            stop("The variates being marginalized must be a subset of the conditioning variates.")
        }
        
        x <- c(marginalize, setdiff(x, marginalize))
        diffvars <- setdiff(x, marginalize)
        
        key_x    <- interaction(idf[, x, drop = FALSE], drop = TRUE)
        key_diff <- if (length(diffvars) == 0) rep.int(".__ALL__", nrow(idf))
        else interaction(idf[, diffvars, drop = FALSE], drop = TRUE)
        key_y    <- interaction(idf[, y, drop = FALSE], drop = TRUE)
        
        if (length(diffvars) == 0) {
            idf$total.freq <- sum(idf$Freq)
        } else {
            total_by_diff <- tapply(idf$Freq, key_diff, sum)
            idf$total.freq <- as.numeric(total_by_diff[key_diff])
        }
        
        x_sum <- tapply(idf$Freq, key_x, sum)
        idf$m <- as.numeric(x_sum[key_x]) / idf$total.freq
        
        key_ydiff <- if (length(diffvars) == 0) key_y
        else interaction(key_y, key_diff, drop = TRUE)
        ydiff_total <- tapply(idf$Freq, key_ydiff, sum)
        
        idf$Freq <- as.numeric(ydiff_total[key_ydiff]) * idf$m
    }
    
    # ---------------------------------------------------------------------------
    # Scale to [0,1]x[0,1], and compute boundaries
    # ---------------------------------------------------------------------------
    if (!is.null(x) && length(x) > 0) {
        
        idf$total_freq <- sum(idf$Freq)
        
        key_x <- interaction(idf[, x, drop = FALSE], drop = TRUE)
        x_sum <- ave(idf$Freq, key_x, FUN = sum)
        
        idf$MarginProb <- idf$Freq / x_sum
        idf$CondProb   <- x_sum / idf$total_freq
        
        # Ordering (your original logic)
        eikos_vars <- c(y, rev(x))
        if (any(eikos_vars %in% names(formals(order)))) {
            idfCopy <- idf[, eikos_vars, drop = FALSE]
            newNames <- paste0("eikos_var_", eikos_vars)
            names(idfCopy) <- newNames
            newOrder <- do.call(order, idfCopy)
        } else {
            newOrder <- do.call(order, idf[, eikos_vars, drop = FALSE])
        }
        idf <- idf[newOrder, , drop = FALSE]
        
        # y bounds within each x-cell
        key_x <- interaction(idf[, x, drop = FALSE], drop = TRUE)
        idf$ymax <- ave(idf$MarginProb, key_x, FUN = cumsum)
        idf$ymin <- idf$ymax - idf$MarginProb
        
    } else {
        
        idf$MarginProb <- idf$Freq / sum(idf$Freq)
        idf$ymax <- cumsum(idf$MarginProb)
        idf$ymin <- idf$ymax - idf$MarginProb
        idf$CondProb <- 1
    }
    
    # x bounds within each y 
    key_y <- interaction(idf[, y, drop = FALSE], drop = TRUE)
    idf$xmax <- ave(idf$CondProb, key_y, FUN = cumsum)
    idf$xmin <- idf$xmax - idf$CondProb
    
    idf
}
