isEmpty = require('ramda/es/isEmpty').default; path = require('ramda/es/path').default; type = require('ramda/es/type').default; without = require('ramda/es/without').default; #auto_require: srcramda
{change, diff} = require 'ramda-extras' #auto_require: ramda-extras

utils = require './utils'


createRouter = () ->
	return new Router()

class Router
	constructor: () ->
		@state = {path: '/'}
		@listeners = []
		window.addEventListener 'popstate', @_onUrlChange
		@_onUrlChange() # to load initial state of url

	_onUrlChange: =>
		path = location.pathname
		paths = utils.extractPathParts path
		query = utils.extractQuery location.search
		urlState = {path, ...paths, ...query}
		delta = diff @state, urlState
		if isEmpty delta then return
		@state = change delta, @state
		@listeners.forEach (l) => l @state, delta
		return true


	buildUrl: (args) ->
		utils.buildUrl args, @state

	navigate: (arg) ->
		url =
			if type(arg) == 'String' then arg
			else utils.buildUrl arg, @state
		return utils.navigate url

	navigateCallback: (arg) ->
		url =
			if type(arg) == 'String' then arg
			else utils.buildUrl arg, @state
		return utils.navigateCallback url

	subscribe: (listener) ->
		@listeners.push listener
		return () -> @listeners = without listener, @listeners

	getState: () -> @state

	# call this when stop using the router (e.g. componentWillUnmount)
	destroy: ->
		window.removeEventListener 'popstate', @_onUrlChange
		@listeners = null

module.exports = createRouter
