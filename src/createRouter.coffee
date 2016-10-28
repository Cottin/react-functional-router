{any, call, either, identity, isEmpty, update} = R = require 'ramda' #auto_require:ramda
{diff, change, ymapObjIndexed} = require 'ramda-extras'

utils = require './utils'


# A router that keeps a simplified state of the url containing page and query.
# If a url change results in a change in either the page or query in state,
# onChange will be called with the delta. Use this delta to do a minimal update
# of any global state you have based on this data. The point of this special
# structure of the api is so that you can use some kind of immutable data and
# only update the bits that's really needed to update instead of updating the
# whole object holding query data on every history change.
# A router object also provides a couple of methods, see their comments.
module.exports = ({onChange}) ->
	_state = {page: '', query: {}}

	_listeners = [onChange]

	_onUrlChange = ->
		page = utils.extractPage location.pathname
		query = utils.extractQuery location.search
		delta = diff _state, {page, query}
		_state = change delta, _state
		if isEmpty delta then return
		else _listeners.forEach (l) -> l _state
		return true

	window.addEventListener 'popstate', _onUrlChange
	_onUrlChange() # to load initial state of url

	buildUrl: (f = identity, page = _state.page) ->
		return utils.buildUrl f, page, _state.query

	navigate: (url) ->
		return utils.navigate url

	navigateCallback: (url) ->
		return utils.navigateCallback url

	subscribe: (listener) ->
		_listeners.push listener
		return () =>
			_listeners = _listeners.filter (l) -> l != listener

	# call this when stop using the router (e.g. componentWillUnmount)
	destroy: ->
		window.removeEventListener 'popstate', _onUrlChange
		_listeners = null
