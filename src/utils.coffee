{has, join, map, omit, path, replace, split, toPairs, type} = require 'ramda' #auto_require:ramda
{change, doto, fzipWith} = require 'ramda-extras' #auto_require:ramda-extras

##### DATA #####################################################################

# [k, v] -> s
# Takes a key value pair and returns their query string representation
_kvToQuery = ([k, v]) -> "#{k}=#{v}"

# o -> s
# Takes an object and returns it's "query string equivalent"
# e.g. toQueryString {page: 'login', user: 'Max'} returns '?page=login&user=Max'
toQueryString = (o) ->
	if !o then return ''
	return '?' + doto o, toPairs, map(_kvToQuery), join('&')

# helper to apply x to v or just return v
_change = (x, v) ->
	if type(x) == 'Function' then x v
	else x

# f, s|f..., o -> s
# Builds a url by applying f to current query in state and replacing path or
# pathparts in state.
buildUrl = (arg, state) ->
	{path0, path1, path2, path3, path4} = state

	if arg.path
		nextPaths = doto (arg.path || ''), replace(/^\//, ''), split(/\//)
		newPaths = fzipWith nextPaths, [path0, path1, path2, path3, path4], (cur, next) ->
			if next == '*' then cur
			else next

		newPath = '/' + join '/', newPaths

	state_ = omit ['path', 'path0', 'path1', 'path2', 'path3', 'path4'], state
	newQuery =
		if has 'query', arg then toQueryString change(arg.query, state_)
		else toQueryString state_

	return (newPath || state.path) + newQuery

# s -> s
# Splits the location.pathname into parts
extractPathParts = (pathname) ->
	if pathname == '/' then return {}
	[p0, p1, p2, p3, p4] = doto pathname, replace(/^\//, ''), split('/')
	paths = {}
	if p0 then paths.path0 = p0
	if p1 then paths.path1 = p1
	if p2 then paths.path2 = p2
	if p3 then paths.path3 = p3
	if p4 then paths.path4 = p4
	return paths

# a -> a   # optimistically parses to Number or Boolean if needed
_autoParse = (val) ->
	if !isNaN(val) then Number(val)
	else if val == 'true' then true
	else if val == 'false' then false
	else val

# s -> {k:v}
# Parses location.search into an object
# http://stackoverflow.com/questions/647259/javascript-query-string
extractQuery = (locationSearch) ->
	result = {}
	queryString = locationSearch.slice(1)
	re = /([^&=]+)=([^&]*)/g
	m = undefined
	while m = re.exec(queryString)
		v = decodeURIComponent(m[2])

		value = _autoParse v
		result[decodeURIComponent(m[1])] = value
	return result


##### BROWSER ##################################################################

# o -> b   # Returns true if user clicked using left mouse
_isLeftClickEvent = (e) -> e.button == 0

# o -> b   # Returns true if user clicked while modifier was pressed
_isModifiedEvent = (e) -> !!(e.metaKey || e.altKey || e.ctrlKey || e.shiftKey)

# s -> null
# Does a "modern" navigate by using history.pushState and dispatching a
# 'popostate' event on the window object
navigate = (url) ->
	# idea from https://github.com/larrymyers/react-mini-router/blob/master/lib/navigate.js
	window.history.pushState {}, '', url
	window.dispatchEvent new window.Event('popstate')

# f, s -> f(e) -> e
# Returns a callback to use for onClick in <a href> elements.
# Uses navigate to do a "modern" navigate using pushState.
navigateCallback = (url) -> (e) ->
	# if a user clicks with the mouse-wheel or using e.g. cmd + click
	# we have to abord and let the browser open that link in a new tab / window
	if _isModifiedEvent(e) || !_isLeftClickEvent(e) || e.defaultPrevented
		return

	e.preventDefault()
	navigate url
	# # if we return false or true we get error msg from react
	# # 'Warning: Returning `false` from an event handler is deprecated'
	# return e # ..so we're returning the event


#auto_export:none_
module.exports = {toQueryString, buildUrl, extractPathParts, extractQuery, navigate, navigateCallback}