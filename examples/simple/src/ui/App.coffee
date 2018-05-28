{hot} = require 'react-hot-loader'
React = require 'react'
{createRouter, RouterProvider} = require 'react-functional-router'

Body = require './Body'

console.log 'react', React
_ = React.createElement 

router = createRouter()


App = ->
	_ RouterProvider, {router},
		_ Body

module.exports = hot(module)(App)
