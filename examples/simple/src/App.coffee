React = require 'react'
{DOM: {div}, PropTypes: {object, func}, Children, createClass, createElement: _} = React = require 'react'
PureRenderMixin = require 'react-addons-pure-render-mixin'
{RouterProvider, Link} = require 'react-functional-router'
RouterProvider_ = React.createFactory RouterProvider
{assoc, evolve, has, ifElse, inc, map, sort} = R = require 'ramda' #auto_require:ramda
{cc} = require 'ramda-extras'

{createStore, StoreProvider, connect} = require './Flux'

##### This is a simple example show-casing how react-functional-router works

HomePage = createClass
	displayName: 'HomePage'

	mixins: [PureRenderMixin]

	render: ->
		console.log 'RENDER HomePage'
		div {}, 'Home page'

NumbersPage = createClass
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

ProfilePage = createClass
	displayName: 'ProfilePage'

	mixins: [PureRenderMixin]

	render: ->
		console.log 'RENDER ProfilePage'
		div {}, 'Profile page'

Body = createClass
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

assocOrInc = ifElse has('counter'), evolve({counter: inc}), assoc('counter', 0)

module.exports = App = createClass
	displayName: 'App'

	render: ->
		div {},
			_ RouterProvider, {onRouterChange},
				_ StoreProvider, {store},
					div {},
						_ Link, {page: ''}, 'Go Home'
						_ Link, {page: 'numbers'}, 'Go to Numbers page'
						_ Link, {to: assocOrInc}, 'Add'
						_ Body_
