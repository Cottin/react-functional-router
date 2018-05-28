React = require 'react'
{prop, props} = R = require 'ramda' #auto_require:ramda
{} = require 'ramda-extras' #auto_require:ramda-extras

Context = require './Context'

_ = React.createElement


class RouterProvider extends React.Component 
	constructor: (props) ->
		super(props)
		if !@props.router
			throw new Error 'RouterProvider expected prop \'router\''
		@router = @props.router
		@state = {url: @props.router.getState(), router: @router}

	componentDidMount: ->
		@unsubscribe = @router.subscribe (state, delta) =>
			@setState {url: state}

	componentWillUnmount: -> @router.destroy()

	render: ->
		_ Context.Provider, {value: @state},
			@props.children


module.exports = RouterProvider
