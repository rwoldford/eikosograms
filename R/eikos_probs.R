library(grid)
#' Create grob with eikosogram x-axis probabilities
#'
#' @description Creates x axis grob to be placed on eikosogram. Called by eikos functions.
#'
#' @param data data frame from eikos_data object
#' @param xprobs vector of probabilities to be shown. NULL if they should be calculated from the data.
#' @param xprobs_size font size of labels for horizontal probabilities (in points)
#' @param margin unit specifying margin between y axis and eikosogram
#' @param rotate logical, whether probabilities should be rotated vertically.
#'
#' @return textGrob with x-axis probabilities.
#' 
eikos_x_probs <- function(data, xprobs = NULL, xprobs_size = 8,
                          margin = unit(2, "points"), rotate = TRUE) {
    # round the probabilities in 2 digits
    if(is.null(xprobs)) {
        labels <- round(as.vector(unique(data$xmax[data$xmax < 1])), 2)
    } else {
        labels <- round(xprobs, 2)
    }
    
    probs <- if(length(labels) > 0) {
        
        # if rotate is TRUE, then x probs are vertically displayed
        if(rotate) {
            textGrob(labels, x = labels, y = margin, 
                     gp = gpar(fontsize = xprobs_size),
                     just = "left", rot = 90,
                     name = "x probs")
        } else {
            # otherwise, the probs are displayed horizontally at the margin
            textGrob(labels, x = labels, y = unit(0.5, "npc") + 0.5*margin,
                     gp = gpar(fontsize = xprobs_size), just = "center",
                     name = "x probs")
        }
        
    } else nullGrob(name = "null: no x probs")


    return(probs)
}

#' Create grob with eikosogram y-axis probabilities
#'
#' @description Creates y axis grob to be placed on eikosogram. Called by eikos functions.
#'
#' @param data data frame from eikos_data object
#' @param yprobs vector of probabilities to be shown. NULL if they should be calculated from the data.
#' @param yprobs_size font size of labels for horizontal probabilities (in points)
#' @param margin unit specifying margin between y axis and eikosogram
#'
#' @return textGrob with y-axis probabilities.
eikos_y_probs <- function(data, yprobs, yprobs_size = 8, margin = unit(2, "points")) {
    
    if(is.null(yprobs)) {
        # round the probability to two digits
        labels <- round(as.vector(unique(data$ymax[data$ymax < 1])), 2)

    } else {
        labels <- round(yprobs, 2)
    }
    
    probs <- if(length(labels) > 0) {
        textGrob(labels, y = labels, x = margin,
                 gp = gpar(fontsize = yprobs_size),
                 just = "left",
                 name = "y probs")
    } else nullGrob(name = "null: no y probs")

    return(probs)
}
