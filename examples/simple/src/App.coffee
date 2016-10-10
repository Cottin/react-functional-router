React = require 'react'
{DOM: {div}, PropTypes: {object, func}, Children, createClass, createElement: _} = React = require 'react' #auto_require:react
{RouterProvider, Link} = require 'react-functional-router'
{assoc, dissoc, merge, test} = R = require 'ramda' #auto_require:ramda

class Store

	constructor: ->
		@state =
			page: ''
			query: {}
		@listeners = []
		window.setTimeout @notify, 1000

	mutate: (path, value) ->
		path_ = if R.is String, path then split '.', path else path
		console.log "Store.mutate", path, value
		console.log "state before", @state
		if value == undefined
			@state = dissoc dropLast(1, path_), @state
		else
			@state = assoc path_, value, @state
		console.log "state after", @state

	subscribe: (listener) ->
		@listeners.push listener
		return () =>
			@listeners = @listeners.filter (l) -> l != listener

	notify: =>
		@listeners.forEach (l) -> l @state

StoreProvider = createClass
	displayName: 'StoreProvider'

	propTypes:
		store: object

	childContextTypes:
		store: object

	getChildContext: ->
		store: @props.store

	render: ->
		Children.only(@props.children)

connect = (displayName, component, mapping) -> createClass
	displayName: displayName

	contextTypes:
		router: object.isRequired

	getInitialState: ->
		ymap mapping, -> null

	componentWillMount: ->
		@_unsubscribe = @context.router.subscribe(@storeChanged)

	componentWillUnmount: ->
		@_unsubscribe()

	render: ->
		_ component, merge(@state, @props)

	storeChanged: (newState) ->
		data = ymap mapping, (path) -> getPath path, newState
		@setState data


HomePage = createClass
	displayName: 'HomePage'

	render: ->
		console.log 'RENDER HomePage'
		div {}, 'Home page'

TestPage = createClass
	displayName: 'TestPage'

	render: ->
		console.log 'RENDER TestPage'
		div {}, 'Test page'

ProfilePage = createClass
	displayName: 'ProfilePage'

	render: ->
		console.log 'RENDER ProfilePage'
		div {}, 'Profile page'

Body = createClass
	displayName: 'Body'

	render: ->
		{page} = @props
		div {},
			if page == '' then _ HomePage
			else if page == 'test' then _ TestPage
			else if page == 'profile' then _ ProfilePage
			else div {}, '404 - Page not found'

Body_ = connect 'Body_', Body,
	page: 'page'


Popup = createClass
	displayName: 'Popup'

	render: ->
		console.log 'RENDER Popup'
		div {}, 'Popup is shown!'



store = new Store()
window.store = store

setPage = (page) -> store.mutate 'page', page
setQueryPart = (path, value) -> store.mutate ['query', path], value

module.exports = App = createClass
	displayName: 'App'

	getInitialState: ->
		page: ''
		query: {}

	render: ->
		div {},
			_ RouterProvider, {setPage, setQueryPart},
				_ StoreProvider, {store},
					div {},
						div {},
							_ Link, {to: assoc('showPopup', true)}, 'Open popup'
						_ Body
