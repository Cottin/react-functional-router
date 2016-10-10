EventListener = require 'fbjs/lib/EventListener'
{identity, path} = require 'ramda' #auto_require:ramda
{diffObj, change, ymapObjIndexed} = require 'ramda-extras'

utils = require './utils'


class Router

	constructor: ({setPage, setQueryPart}) ->
		# @page = utils.extractPage location.pathname
		# @query = utils.extractQuery location.search
		@page = null
		@query = null
		@listeners = []
		@setPage = setPage
		@setQueryPart = setQueryPart
		EventListener.listen window, 'popstate', @_onPopState
		@_onPopState()

	# PUBLIC METHODS
	buildUrl: (f = identity, page = @page) ->
		return utils.buildUrl f, page, @query

	navigate: (url) ->
		return utils.navigate url

	navigateCallback: (url) ->
		return utils.navigateCallback url

	subscribe: (listener) ->
		@listeners.push listener
		return () =>
			@listeners = @listeners.filter (l) -> l != listener

	# PRIVATE METHODS 
	_onPopState: () =>
		debugger
		path = location.pathname
		if !utils.isValidPath path
			throw new Error "Router: too complex location.pathname, this is a simple
			router, if you need nested routes, maybe look at react-router?"

		page = utils.extractPage path
		if @page != page
			@page = page
			@setPage @page

		query = utils.extractQuery location.search
		diff = diffObj @query, query
		# console.log '@query', @query
		# console.log 'query', query
		# console.log 'diff', diff
		@query = change diff, @query
		# console.log '@query after change', @query
		ymapObjIndexed diff, (v, k) => @setQueryPart k, v

		@listeners.forEach (l) -> l()

module.exports = Router
