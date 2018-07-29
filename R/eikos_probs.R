#' Create grob with eikosogram x-axis probabilities
#'
#' @description Creates y axis grob to be placed on eikosogram. Called by eikos functions.
#'
#' @inheritParams eikos_y_probs
#' @param xprobs vector of probabilities to be shown. NULL if they should be calculated from the data.
#' @param rotate logical, whether probabilities should be rotated vertically.
#'
#' @return textGrob with x-axis probabilities.
eikos_x_probs <- function(data, xprobs = NULL, margin = unit(2, "points"), rotate = TRUE) {
    # round the probabilities in 2 digits
    if(is.null(xprobs)) {
        labels <- round(as.vector(unique(data$xmax[data$xmax < 1])), 2)
    } else {
        labels <- round(xprobs, 2)
    }


    probs <- nullGrob()

    if(length(probs) > 0) {

        # if rotate is TRUE, then x probs are vertically displayed
        if(rotate) {
            probs <- textGrob(labels, x = labels, y = margin, just = "left", rot = 90)
        } else {
            # otherwise, the probs are displayed horizontally at the margin
            probs <- textGrob(labels, x = labels, y = unit(0.5, "npc") + 0.5*margin, just = "center")
        }

    }


    return(probs)
}

#' Create grob with eikosogram y-axis probabilities
#'
#' @description Creates y axis grob to be placed on eikosogram. Called by eikos functions.
#'
#' @param data data frame from eikos_data object
#' @param yprobs vector of probabilities to be shown. NULL if they should be calculated from the data.
#' @param margin unit specifying margin between y axis and eikosogram
#'
#' @return textGrob with y-axis probabilities.
eikos_y_probs <- function(data, yprobs, margin = unit(2, "points")) {
    if(is.null(yprobs)) {
        # round the probability to two digits
        labels <- round(as.vector(unique(data$ymax[data$ymax < 1])), 2)

    } else {
        labels <- round(yprobs, 2)
    }

    probs <- nullGrob()
    if(length(labels) > 0) {
        probs <- textGrob(labels, y = labels, x = margin, just = "left")
    }

    return(probs)
}
