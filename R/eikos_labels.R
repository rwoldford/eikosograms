library(grid)
#' eikos helper function. Returns grob with x axis labels.
#'
#' @param x vector of conditional variables
#' @param data data frame from eikos_data.
#' @param margin unit specifying margin
#' @param xname_size font size for x axis variable names (in points)
#' @param xvals_size font size of labels for values of x variables (in points)
#' @param lab_rot integer indicating the rotation of the label, default is horizontal
#'
#' @return gList with x labels and x-axis names as grob frames.
eikos_x_labels <- function(x, data, margin = unit(10, "points"), 
                           xname_size = 12, xvals_size = 10, lab_rot = 0) {
    # number of conditional variables
    n <- length(x)

    # get labels for ymin is 0
    data <- data[data$ymin == 0,]
    label_list <- gList()
    axis_name_list <- gList()
    heights <- NULL

    # set a maximum label width
    max_name_width <- unit(0, "npc")

    for (i in 1:n) {
        # deal with each variable in conditional variables
        variable <- x[i]
        all.following <- x[i:length(x)]
        tmp <- ddply(data, all.following, transform, xtext=mean((xmin + xmax)/2))
        # takes the unique xtext for conditional variables
        tmp <- unique(tmp[,c(variable,"xtext")])
        tmp$label <- paste(tmp[[variable]])
        # create x axis text grob
        text <- textGrob(tmp$label, x = tmp$xtext, y = unit(1, "npc") - margin, 
                         just = "centre", rot = lab_rot,
                         gp = gpar(fontsize = xvals_size), name = "x values")
        height <- grobHeight(text) + margin

        # make grob for labelling axes
        name <- textGrob(variable, x = unit(1,"npc") - 4*margin, y = unit(0.6, "npc"),
                         just = "right", gp = gpar(fontsize = xname_size), name = "x vars")
        axis_name_list <- gList(axis_name_list, name)

        # set label heights
        if(is.null(heights)) {
            heights <- height
        } else {
            heights <- unit.c(heights, height)
        }

        max_name_width <- max(grobWidth(name) + 5*margin, max_name_width)

        label_list <- gList(label_list, text)
    }

    # arrange x labels
    xlabs_layout <- grid.layout(nrow = n,
                                ncol = 1,
                                widths = 1,
                                heights = heights)

    name_layout <- grid.layout(nrow = n,
                               ncol = 1,
                               widths = max_name_width,
                               heights = heights)

    xlabs_frame <- frameGrob(layout = xlabs_layout, name = "x values layout")
    name_frame <- frameGrob(layout = name_layout, name = "x varnames layout")

    for(i in 1:n) {
        xlabs_frame <- placeGrob(xlabs_frame, label_list[[i]], row = i, col = 1)
        name_frame <- placeGrob(name_frame, axis_name_list[[i]], row = i, col = 1)

    }

    return(gList(labels = xlabs_frame, names = name_frame))
}

#' eikos helper function. Returns grob with y axis labels.
#'
#' @param y response variable
#' @param data data frame from eikos_data.
#' @param margin unit specifying margin
#' @param yname_size font size for y axis variable names (in points)
#' @param yvals_size font size of labels for values of y variable (in points)
#' @param lab_rot integer indicating the rotation of the label, default is horizontal
#'
#' @return gList with x labels and x-axis names as grob frames.
#'
#' @return grobFrame with response variable labels and axis text
eikos_y_labels <- function(y, data,  margin = unit(2, "points"), 
                           yname_size = 12, yvals_size = 10, lab_rot=0) {
    labels <- as.vector(unique(data[,y]))
    y0 <- vector(length = length(labels))

    for(label in labels) {
        # identify location of corresponding leftmost box
        i <- (data[,y] == label) & (data[,"xmin"] == 0)
        row <- data[i, ]

        label_y_coordinate <- row[,"ymin"] + (row[,"ymax"] - row[,"ymin"])/2
        y0[which(labels == label)] <- label_y_coordinate
    }

    # arrange y labels text and position
    y_labs <- textGrob(labels,
                      x = unit(1, "npc") - margin,
                      y = y0, rot = lab_rot,
                      just = "right",
                      gp = gpar(fontsize = yvals_size),
                      name = "y values")

    y_name <- textGrob(y, just = "center", rot = 90,
                      gp = gpar(fontsize = yname_size),
                      name = "y name")

    y_frame <- frameGrob(layout = grid.layout(1, 2,
                                             widths = unit.c(grobWidth(y_name) + 4*margin,
                                                             grobWidth(y_labs) + margin)),
                         name = "left y labels")

    y_frame <- placeGrob(y_frame, y_name, 1, 1)
    y_frame <- placeGrob(y_frame, y_labs, 1, 2)

    return(y_frame)
}


