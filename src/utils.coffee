{into, isEmpty, isNil, join, map, pair, path, remove, replace, test, toPairs, values} = require 'ramda' #auto_require:ramda
{cc} = require 'ramda-extras'

# s -> b
# Returns true if the path conforms to the very simplified url patterns
# supported by react-functional-router
exports.isValidPath = isValidPath = (path) ->
	# /             OK
	# /?a=1         OK

	# /abc          OK
	# /abc?a=1      OK
	# /abc/         OK
	# /abc/?a=1     OK

	# /abc/def      NOT OK
	# /abc/def?a=1  NOT OK
	# /abc/def/     NOT OK
	# /abc/def/?a=1 NOT OK

	# remove potential starting and trailing slashes
	trimmedPath = cc replace(/^\//, ''), replace(/\/$/, ''), path
	# if there are still slashes it's invalid
	return ! test /\//, trimmedPath

# s -> s
# react-functional-router defines the first part after the slash as the "page"
# and this function extracts that part from the location.pathname
# e.g. extractPage '/my-page/' returns 'my-page'
exports.extractPage = extractPage = (locationPath) ->
	cc replace(/^\//, ''), replace(/\/$/, ''), replace(/\?.*/, ''), locationPath

# s -> {k:v}
# Pass location.search to this function and it will return you the query string
# converted into an object
# http://stackoverflow.com/questions/647259/javascript-query-string
exports.extractQuery = extractQuery = (locationSearch) ->
	result = {}
	queryString = locationSearch.slice(1)
	re = /([^&=]+)=([^&]*)/g
	m = undefined
	while m = re.exec(queryString)
		v = decodeURIComponent(m[2])

		# some simple parsing
		value = switch
			when v == 'true' then true
			when v == 'false' then false
			else v

		result[decodeURIComponent(m[1])] = value
	return result

# [k, v] -> s
# Takes a key value pair and returns their query string representation
_kvToQuery = ([k, v]) -> "#{k}=#{v}"

# o -> s
# Takes an object with key-values and returns it's "query string equivalent"
# e.g. toQueryString {page: 'login', user: 'Max'} returns '?page=login&user=Max'
exports.toQueryString = toQueryString = (o) ->
	return '?' + cc join('&'), map(_kvToQuery), toPairs, o

# o -> b   # Returns true if user clicked using left mouse
# stolen from https://github.com/rackt/react-router/blob/master/modules/Link.js
_isLeftClickEvent = (e) -> e.button == 0

# o -> b   # Returns true if user clicked while modifier was pressed
_isModifiedEvent = (e) -> !!(e.metaKey || e.altKey || e.ctrlKey || e.shiftKey)

# s -> null
# Does a "modern" navigate by using history.pushState and dispatching a
# 'popostate' event on the window object
exports.navigate = navigate = (url) ->
	# idea from https://github.com/larrymyers/react-mini-router/blob/master/lib/navigate.js
	window.history.pushState {}, '', url
	window.dispatchEvent new window.Event('popstate')
	return null # return null to work around warning, see navigateCallback

# f, s, o -> s
# Constructs a url string by applying f to query and prepending page
exports.buildUrl = buildUrl = (f, page, query) ->
	if test /^\//, page
		throw new Error "page cannot begin with '/'. Use '' to go home."

	if isNil page
		throw new Error "Page cannot be nil. Use '' to go to home."

	newQuery = f query
	if isEmpty newQuery then '/' + page
	else '/' + page + toQueryString(newQuery)

# f, s -> f(e) -> e
# Returns a callback to use for onClick in <a href> elements.
# Uses navigate to do a "modern" navigate using pushState.
exports.navigateCallback = navigateCallback = (url) -> (e) ->
	# if a user clicks with the mouse-wheel or using e.g. cmd + click
	# we have to abord and let the browser open that link in a new tab / window
	if _isModifiedEvent(e) || !_isLeftClickEvent(e) then return e

	navigate url
	e.preventDefault()
	# if we return false or true we get error msg from react
	# 'Warning: Returning `false` from an event handler is deprecated'
	return e # ..so we're returning the event
