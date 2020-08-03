React = require 'react'
isNil = require('ramda/src/isNil'); merge = require('ramda/src/merge'); omit = require('ramda/src/omit'); path = require('ramda/src/path'); props = require('ramda/src/props'); #auto_require: srcramda
{$} = require 'ramda-extras' #auto_require: ramda-extras

Context = require './Context'

_ = React.createElement


Link = (props) ->
	_ Context.Consumer, {}, ({router}) ->
		props_ = $ props, omit ['link', 'path']

		if props.link == undefined || props.disabled
			onClick = () ->
			url = 'javascript:void(0)'
		else
			url = router.buildUrl props.link
			onClick = (e) ->
				if !isNil props.onClick then props.onClick(e)
				router.navigateCallback(url)(e)

		props__ = merge props_,
			href: url
			onClick: if props.target != '_blank' then onClick

		_ 'a', props__


module.exports = Link
