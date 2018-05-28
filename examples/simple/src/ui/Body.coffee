React = require 'react'
{path, props} = R = require 'ramda' #auto_require:ramda
{} = require 'ramda-extras' #auto_require:ramda-extras
{Router, Link, withRouter} = require 'react-functional-router'


_ = React.createElement

class Body extends React.Component
	constructor: (props) ->
		super props
		@state = name: '...', countries: []

	render: ->
		_ 'div', {},
			_ Router, {}, ({url}) ->
				_ 'div', {}, JSON.stringify(url, null, 2)
			_ 'br'
			_ 'div', {},
				_ 'div', {}, 'MENU links:'
				_ Link, {path: '/'}, 'Home'
				_ 'br'
				_ Link, {path: '/Customer'}, 'Customer'
			_ 'br'
			_ 'div', {},
				_ 'div', {}, 'Example links:'
				_ Link, {query: {name: 'World!'}}, 'Name = World!'
				_ 'br'
				_ Link, {query: {sidepanel: (x) -> if x then undefined else true}},
					'Toggle sidepanel'
				_ 'br'

			_ Router, {}, ({url: {path0: page}}) ->
				switch page
					when undefined then _ HomePage
					when 'Customer' then _ CustomerPage
					else _ NotFoundPage


HomePage = () ->
	_ 'div', {},
		_ 'h1', {}, 'Home Page'
		_ Hello

CustomerPage = withRouter ({url: {path1: mode}}) ->
	_ 'div', {},
		_ 'h1', {}, 'Customer Page'
		_ 'br'
		switch mode
			when 'edit', 'new' then _ CustomerFormView
			else _ CustomerDetailsView


CustomerDetailsView = withRouter ({nav}) ->
	_ 'div', {},
		_ 'h2', {}, 'Customer details'
		_ 'button', {onClick: -> nav({path: '/*/edit'})}, 'Edit'
		_ 'br'
		_ 'br'
		_ Link, {path: '/*/new'}, '+ Create new customer'

CustomerFormView = () ->
	_ 'div', {},
		_ 'h2', {}, 'Customer form'
		_ 'br'
		_ Link, {path: '/*'}, 'Cancel edit'

NotFoundPage = () ->
	_ 'div', {},
		_ 'h1', {}, 'Page not found'


Hello = withRouter ({url}) ->
	_ 'h2', {s: 'bglime'}, "Hello #{url.name}!!!"


module.exports = Body
