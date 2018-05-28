React = require 'react'
{ hot } = require 'react-hot-loader'
ApolloClient = require("apollo-boost").default
{ ApolloProvider } = require "react-apollo"
{ createRouter, RouterProvider } = require 'react-functional-router'

Body = require './Body'

_ = React.createElement 

router = createRouter()

apolloClient = new ApolloClient({
	uri: CONFIG_API_URL
})


App = ->
	_ RouterProvider, {router},
		_ ApolloProvider, {client: apolloClient},
			_ Body

module.exports = hot(module)(App)
