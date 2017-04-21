{Children, createElement: _} = React = require 'react'
createReactClass = require 'create-react-class'
{object, func} = require 'prop-types'
{ymap, getPath, change} = require 'ramda-extras'


##### Simple flux-ish / redux-ish implementations for demo purposes

# Create a store with global data for the application and pass the initialData
exports.createStore = createStore = (initialData) ->
	_state = initialData
	_listeners = []

	mutate = (delta) ->
		console.log 'Store.change', delta
		_state = change delta, _state
		notify()


	subscribe = (listener) ->
		_listeners.push listener
		return () => # unsubscribe function
			_listeners = _listeners.filter (l) -> l != listener

	notify = ->
		_listeners.forEach (l) -> l _state

	getState = -> _state

	return {mutate, subscribe, notify, getState}


# Use at root of your application to inject store to context
exports.StoreProvider = StoreProvider = createReactClass
	displayName: 'StoreProvider'

	propTypes:
		store: object

	childContextTypes:
		store: object

	getChildContext: ->
		store: @props.store

	render: ->
		Children.only(@props.children)


# Like redux's connect, wraps a "dumb" component and makes it into a container
# that has a mapping to some data in the store and gets re-rendered if that
# data changes.
exports.connect = connect = (component, mapping) -> createReactClass
	displayName: "Connect(#{getDisplayName(component)})"

	contextTypes:
		store: object.isRequired

	getInitialState: ->
		ymap mapping, -> null

	componentWillMount: ->
		@_unsubscribe = @context.store.subscribe(@storeChanged)
		@storeChanged @context.store.getState() # get data for first render

	componentWillUnmount: ->
		@_unsubscribe()

	storeChanged: (newState) ->
		data = ymap mapping, (path) -> getPath path, newState
		@setState data

	render: ->
		_ component, @state



getDisplayName = (WrappedComponent) ->
  WrappedComponent.displayName || WrappedComponent.name || 'Component'




