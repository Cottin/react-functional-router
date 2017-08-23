{Children} = React = require 'react'
createReactClass = require 'create-react-class'
{object} = require 'prop-types'

# A "Provider" that creates a router and injects it in reacts context.
# Use this component close at the root of your application.
module.exports = RouterProvider = createReactClass
	displayName: 'RouterProvider'

	# Getting warnings from this and I don't understand why
	# https://facebook.github.io/react/warnings/dont-call-proptypes.html
	# Tried to reproduce in smaller code base but faild:
	# http://jsbin.com/watozotove/edit?html,js,console,output
	# http://jsbin.com/nehomixeho/edit?html,js,console,output  <-- 15.3.2
	propTypes:
		router: object

	childContextTypes:
		router: object

	getChildContext: ->
		router: @props.router

	render: ->
		Children.only(@props.children)
