React = require 'react'
 #auto_require: srcramda
{} = require 'ramda-extras' #auto_require: ramda-extras

Context = require './Context'
Router = require './Router'

_ = React.createElement


withRouter = (f) -> (args) ->
	_ Router, {}, ({url, nav}) -> f {url, nav, ...args}


module.exports = withRouter
