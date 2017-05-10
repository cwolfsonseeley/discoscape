#' Input a list of entity ids and output a csv file ready for use with the DonorScape tool
#'
#' @param ids A discoveryengine definition
#' @param include_deceased Should deceased individuals be included?
#' @param household Should there be one line per household?
#' @param file Where should output go?
#'
#' @details
#' By default, deceased individuals are exclused.
#' By default, output is one line per household.
#' If no file location is indicated, the output will be returned within R.
#' @export
donorscape_report <- function(ids, include_deceased = FALSE, household = TRUE,
                              file = NULL) {
    # ensure that we have entity ids
    stopifnot(listbuilder::get_id_type(ids) == "entity_id")

    # household, etc
    ids <- modify(
        ids,
        include_organizations = FALSE,
        include_deceased = include_deceased,
        household = household)

    # run the query and return a data frame
    res <- discoveryengine::get_cdw(
        listbuilder::report(
            ids, template = donorscape_query_template
        )
    )

    # re-arrange columns
    first_three_cols <- c("account_id", "screening_indicator", "entity_id")
    rest_cols <- setdiff(names(res), first_three_cols)
    res <- res[c(first_three_cols, rest_cols)]

    # rename columns from this_style to ThisStyle
    names(res) <- ReName(names(res))

    # should be "ProspectId" instead of "EntityId"
    names(res)[3] <- "ProspectId"

    # also columns should all be character
    res$DateOfBirth <- as.character(res$DateOfBirth, format = "%m/%d/%Y")
    res$ProspectId <- as.character(res$ProspectId)
    res$SpouseId <- as.character(res$SpouseId)

    if (is.null(file))
        return(res)

    if (!grepl("\\.csv$", file)) filename <- paste0(file, ".csv")
    else filename <- file
    write.csv(res, filename, na = "", row.names = FALSE)
}
