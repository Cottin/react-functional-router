React = require 'react'
{isNil, merge, path, props} = R = require 'ramda' #auto_require:ramda
{fomit} = require 'ramda-extras' #auto_require:ramda-extras

Context = require './Context'

_ = React.createElement


Link = (props) ->
	_ Context.Consumer, {}, ({router}) ->
		url = router.buildUrl props.link
		props_ = fomit props, ['link', 'path']
		onClick = (e) ->
			if !isNil props.onClick then props.onClick(e)
			router.navigateCallback(url)(e)

		props__ = merge props_,
			href: url
			onClick: if props.target != '_blank' then onClick
		_ 'a', props__


module.exports = Link
