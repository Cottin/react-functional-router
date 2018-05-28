React = require 'react'
{isNil, merge, path, props} = R = require 'ramda' #auto_require:ramda
{fomit} = require 'ramda-extras' #auto_require:ramda-extras

Context = require './Context'

_ = React.createElement


Link = (props) ->
	_ Context.Consumer, {}, ({router}) ->
		url = router.buildUrl {path: props.path, query: props.query}
		props_ = fomit props, ['query', 'path']
		props__ = merge props_,
			href: url
			onClick: (e) ->
				if !isNil props.onClick then props.onClick(e)
				router.navigateCallback(url)(e)
		_ 'a', props__


module.exports = Link
