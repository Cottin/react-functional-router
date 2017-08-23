React = require 'react'
{DOM: {div}, Children, createElement: _} = React = require 'react'
createReactClass = require 'create-react-class'
PureRenderMixin = require 'react-addons-pure-render-mixin'
{createRouter, RouterProvider, Link} = require 'react-functional-router'
RouterProvider_ = React.createFactory RouterProvider
{assoc, evolve, has, identity, ifElse, inc, map, sort, where} = R = require 'ramda' #auto_require:ramda
{cc} = require 'ramda-extras'

{createStore, StoreProvider, connect} = require './Flux'

##### This is a simple example show-casing how react-functional-router works

# note: there is a lot of warnings like this one:
# "Calling PropTypes validators directly is not supported by the..."
# I can't see anywhere where we use validators directly. But it seems to be in
# the example only, when using react-functional-router in another projet,
# I don't get this issue, so I'm leaving it for now.

HomePage = createReactClass
	displayName: 'HomePage'

	mixins: [PureRenderMixin]

	render: ->
		console.log 'RENDER HomePage'
		div {}, 'Home page'

NumbersPage = createReactClass
	displayName: 'NumbersPage'

	mixins: [PureRenderMixin]

	render: ->
		console.log 'RENDER NumbersPage'
		if @props.sort == 'desc'
			differ = (a, b) -> b - a
		else
			differ = (a, b) -> a - b

		div {},
			_ Link, {to: assoc('sort', 'asc')}, 'Sort 1->9'
			_ Link, {to: assoc('sort', 'desc')}, 'Sort 9->1'
			cc map(@renderNumber), sort(differ), @props.numbers

	renderNumber: (n) -> div {key: n}, n

NumbersPage_ = connect NumbersPage, {numbers: 'numbers', sort: 'query.sort'}

ProfilePage = createReactClass
	displayName: 'ProfilePage'

	mixins: [PureRenderMixin]

	render: ->
		console.log 'RENDER ProfilePage'
		div {}, 'Profile page'

Body = createReactClass
	displayName: 'Body'

	mixins: [PureRenderMixin]

	render: ->
		{page} = @props
		console.log 'RENDER Body'
		div {},
			div {}, 'Counter: ' + @props.counter
			if page == '' then _ HomePage
			else if page == 'numbers' then _ NumbersPage_
			else if page == 'profile' then _ ProfilePage
			else div {}, '404 - Page not found'

Body_ = connect Body, {page: 'page', counter: 'query.counter'}

store = createStore {page: '', query: {}, numbers: [1,2,3,4,5,6,7]}
window.store = store # expose for easier debugging

onRouterChange = (diff) -> store.mutate diff
router = createRouter {onChange: onRouterChange}

assocOrInc = ifElse has('counter'), evolve({counter: inc}), assoc('counter', 0)

module.exports = App = createReactClass
	displayName: 'App'

	render: ->
		div {},
			_ RouterProvider, {router},
				_ StoreProvider, {store},
					div {},
						_ Link, {page: ''}, 'Go Home'
						_ Link, {page: 'numbers'}, 'Go to Numbers page'
						_ Link, {to: assocOrInc}, 'Add'
						_ Link, {page: '', to: identity}, 'Go Home keep queries'
						_ Link, {page: '', to: identity, onClick: -> alert('Hello there')}, 'Go Home and alert'
						_ Body_
