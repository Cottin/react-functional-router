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
				_ Link, {link: {path0: undefined}}, 'Home'
				_ 'br'
				_ Link, {link: {path0: '/Customer'}}, 'Customer'
			_ 'br'
			_ 'div', {},
				_ 'div', {}, 'Example links:'
				_ Link, {link: {name: 'World!'}}, 'Name = World!'
				_ 'br'
				_ Link, {link: {sidepanel: (x) -> if x then undefined else true}},
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
		_ 'button', {onClick: -> nav({path1: 'edit'})}, 'Edit'
		_ 'br'
		_ 'br'
		_ Link, {link: {path1: 'new'}}, '+ Create new customer'

CustomerFormView = () ->
	_ 'div', {},
		_ 'h2', {}, 'Customer form'
		_ 'br'
		_ Link, {link: {path1: undefined}}, 'Cancel edit'

NotFoundPage = () ->
	_ 'div', {},
		_ 'h1', {}, 'Page not found'


Hello = withRouter ({url}) ->
	_ 'h2', {s: 'bglime'}, "Hello #{url.name}!!!"


module.exports = Body
