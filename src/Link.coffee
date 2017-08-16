{DOM: {a}} = require 'react'
createReactClass = require 'create-react-class'
{func, object, string} = require 'prop-types'
{always, any, has, identity, isNil, length, merge, omit, remove} = require 'ramda' #auto_require:ramda


# Renders <a href> tag that also has a onClick handler that performs a "modern"
# navigate using push-state
module.exports = Link = createReactClass
	displayName: 'Link'

	propTypes:
		to: func
		page: string

	getDefaultProps: ->
		# If you only specify {page: '...'} you typically want to remove any
		# query string, so by default, to is always({}). If you want to keep
		# the query string pass identity, i.e. {page: '...', to: identity}
		to: always {}

	contextTypes:
		router: object.isRequired

	componentWillMount: ->
		# React has a known limitation with context
		# https://facebook.github.io/react/docs/context.html#known-limitations
		# It's discussed at lenght here:
		# https://github.com/facebook/react/issues/2517
		# And it's also discussed in the context of react-router at length here:
		# https://github.com/ReactTraining/react-router/issues/470
		# We do the same kind of workaround as react-router does in version 3.0.0:
		# https://github.com/ReactTraining/react-router/pull/3430/commits/1d0ed5e183f18b97d588309e40a9b58b6ed723e4
		@context.router.subscribe =>
			@forceUpdate()

	render: ->
		{to, page, onClick} = @props
		{router} = @context
		url = router.buildUrl to, page
		newProps = merge omit(['to', 'page', 'onClick'], @props),
			href: url
			onClick: (e) ->
				if !isNil onClick then onClick(e)
				router.navigateCallback(url)(e)
		a newProps

