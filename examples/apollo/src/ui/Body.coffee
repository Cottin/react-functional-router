React = require 'react'
{Query} = require "react-apollo"
gql = require "graphql-tag"
{props} = require 'ramda' #auto_require:ramda
{fmap} = require 'ramda-extras' #auto_require:ramda-extras
{Link, withRouter} = require 'react-functional-router'

_ = React.createElement


class Body extends React.Component
	constructor: (props) ->
		super props

	render: ->
		_ 'div', {},
			_ CinemaList, {}



CinemaList = withRouter ({url: {first}}) ->
	_ Query,
		query: gql"""
			query allCinama($first: Int) {
				allCinemaDetails(first: $first) {
					edges {
						node {
							id	
							hallName
						}
					}
				}
			}
			"""
		variables: {first}
	,
		({ loading, error, data }) ->
			_ 'div', {},
				_ Link, {link: {first: 5}}, '6 cinemas'
				_ 'br'
				_ Link, {link: {first: 10}}, '10 cinemas'
				_ 'br'
				_ 'br'
				loading && _ 'div', {}, 'Loading...'
				error && _ 'div', {}, 'Error!'
				data && data.allCinemaDetails && fmap data.allCinemaDetails.edges, (e) ->
					_ Cinema, {key: e.node.id, cinema: e.node}


Cinema = ({cinema}) ->
	_ 'div', {}, cinema.hallName

module.exports = Body
