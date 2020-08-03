React = require 'react'
 #auto_require: srcramda
{} = require 'ramda-extras' #auto_require: ramda-extras

Context = require './Context'

_ = React.createElement


Router = ({children}) ->
	_ Context.Consumer, {}, ({url, router}) ->
		children({url, nav: router.navigate})


module.exports = Router
