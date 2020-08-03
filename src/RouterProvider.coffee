React = require 'react'
prop = require('ramda/es/prop').default; props = require('ramda/es/props').default; #auto_require: srcramda
{} = require 'ramda-extras' #auto_require: ramda-extras

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
		# @router.initialize()
		@unsubscribe = @router.subscribe (state, delta) =>
			@setState {url: state}

	# Testing quick workaround to not destroy to make hot reloading work better.
	# Better would be to make sure the logic is correct and works but probably we'd re-write it
	# with hooks at same time.
	# componentWillUnmount: -> @router.destroy()

	render: ->
		_ Context.Provider, {value: @state},
			@props.children


module.exports = RouterProvider
