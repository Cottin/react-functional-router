{isEmpty, path, type, without} = R = require 'ramda' #auto_require: ramda
{change, diff} = require 'ramda-extras' #auto_require: ramda-extras

utils = require './utils'


createRouter = () ->
	_state = {path: '/'}

	_listeners = []

	_onUrlChange = ->
		path = location.pathname
		paths = utils.extractPathParts path
		query = utils.extractQuery location.search
		urlState = {path, ...paths, ...query}
		delta = diff _state, urlState
		if isEmpty delta then return
		_state = change delta, _state
		_listeners.forEach (l) -> l _state, delta
		return true

	window.addEventListener 'popstate', _onUrlChange
	_onUrlChange() # to load initial state of url

	buildUrl: (args) ->
		utils.buildUrl args, _state

	navigate: (arg) ->
		url =
			if type(arg) == 'String' then arg
			else utils.buildUrl arg, _state
		return utils.navigate url

	navigateCallback: (arg) ->
		url =
			if type(arg) == 'String' then arg
			else utils.buildUrl arg, _state
		return utils.navigateCallback url

	subscribe: (listener) ->
		_listeners.push listener
		return () -> _listeners = without listener, _listeners

	getState: () -> _state

	# call this when stop using the router (e.g. componentWillUnmount)
	destroy: ->
		window.removeEventListener 'popstate', _onUrlChange
		_listeners = null

module.exports = createRouter
