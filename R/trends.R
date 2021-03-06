#' get_trends
#'
#' @description Returns Twitter trends
#'
#' @param woeid Numeric, WOEID (Yahoo! Where On Earth ID) or
#'   character string of desired town or country. To browse all
#'   available trend places, see \code{\link{trends_available}}
#' @param exclude Logical, indicating whether or not to exclude
#'   hashtags
#' @param token OAuth token (1.0 or 2.0). By default
#'   \code{token = NULL} fetches a non-exhausted token from
#'   an environment variable tokens.
#' @param parse Logical, indicating whether or not to parse return
#'   trends data.
#'
#' @examples
#' \dontrun{
#' # Retrieve available trends
#' trends <- available_trends()
#' trends
#'
#' # Store WOEID for Worldwide trends
#' worldwide <- subset(trends, name == "Worldwide")[["woeid"]]
#'
#' # Retrieve worldwide trends datadata
#' ww_trends <- get_trends(woeid = worldwide)
#'
#' # Preview trends data
#' ww_trends
#' }
#'
#' @return Trend data for a given location.
#' @export
get_trends <- function(woeid = 1, exclude = FALSE, token = NULL,
	parse = TRUE) {

	stopifnot(is.atomic(woeid), length(woeid) == 1)

	woeid <- check_woeid(woeid)

	query <- "trends/place"

	token <- check_token(token, query)

	params <- list(
		id = woeid,
		exclude = exclude)

	url <- make_url(
		query = query,
		param = params)

	gt <- TWIT(get = TRUE, url, token)

	gt <- from_js(gt)

	if (parse) gt <- parse_trends(gt)

	gt
}

#' parse_trends
#'
#' @description Returns tibble data frame of trends data.
#'
#' @param x Nexted list fromJSON of trends data.
#'
#' @keywords internal
#' @export
parse_trends <- function(x) {
	trends <- data_frame_(x$trends[[1]])
	rows <- nrow(trends)
	names(trends)[names(trends) == "name"] <- "trend"
	cbind_(trends, data_frame_(
		as_of = format_trend_date(rep(x$as_of, rows)),
		created_at = format_trend_date(rep(x$created_at, rows)),
		place = rep(x$locations[[1]]$name, rows),
		woeid = rep(x$locations[[1]]$woeid, rows)))
}


format_trend_date <- function(x, date = FALSE) {
	x <- as.POSIXct(x, format = "%Y-%m-%dT%H:%M:%SZ",
		tz = Sys.timezone())
	if (date) {
		x <- as.Date(x)
	}
	x
}

#' trends_available
#'
#' @description Returns Twitter trends based on requested WOEID.
#'
#' @param token OAuth token (1.0 or 2.0). By default
#'   \code{token = NULL} fetches a non-exhausted token from
#'   an environment variable tokens.
#' @param parse Logical, indicating whether to return parsed
#'   (data.frames) or nested list (fromJSON) object. By default,
#'   \code{parse = TRUE} saves users from the time
#'   [and frustrations] associated with disentangling the Twitter
#'   API return objects.
#'
#' @examples
#' \dontrun{
#' # Retrieve available trends
#' trends <- available_trends()
#' trends
#'
#' # Store WOEID for Worldwide trends
#' worldwide <- subset(trends, name == "Worldwide")[["woeid"]]
#'
#' # Retrieve worldwide trends datadata
#' ww_trends <- get_trends(woeid = Worldwide)
#'
#' # Preview Worldwide trends data
#' ww_trends
#' }
#'
#' @return Data frame with WOEIDs. WOEID is a Yahoo! Where On
#'   Earth ID.
#' @export
trends_available <- function(token = NULL, parse = TRUE) {

	query <- "trends/available"

	token <- check_token(token, query)

	url <- make_url(query = query,
		param = NULL)

	trd <- TWIT(get = TRUE, url, token)

	trd <- from_js(trd)

	if (parse) trd <- parse_trends_available(trd)

	trd
}

#' parse_trends_available
#'
#' @description parse trends data
#'
#' @param x trends data fromJSON
#' @keywords internal
#' @noRd
parse_trends_available <- function(x) {
	p <- cbind_(data_frame_(x[names(x) != "placeType"]),
		data_frame_(x[["placeType"]]))
	names(p)[ncol(p)] <- "place_type"
	p
}
