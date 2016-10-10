{PropTypes: {object, func}, Children, createClass} = React = require 'react'
Router = require './Router'

module.exports = RouterProvider = createClass
	displayName: 'RouterProvider'

	propTypes:
		setPage: func
		setQueryPart: func

	childContextTypes:
		router: object

	getChildContext: ->
		router: @router

	componentWillMount: ->
		{setPage, setQueryPart} = @props
		@router = new Router({setPage, setQueryPart})

	render: ->
		Children.only(@props.children)
