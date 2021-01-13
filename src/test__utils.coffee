all = require('ramda/src/all'); always = require('ramda/src/always'); append = require('ramda/src/append'); empty = require('ramda/src/empty'); inc = require('ramda/src/inc'); match = require('ramda/src/match'); path = require('ramda/src/path'); remove = require('ramda/src/remove'); without = require('ramda/src/without'); #auto_require: srcramda
{cc} = RE = require 'ramda-extras' #auto_require: ramda-extras
[] = [] #auto_sugar
qq = (f) -> console.log match(/return (.*);/, f.toString())[1], f()
qqq = (...args) -> console.log ...args
_ = (...xs) -> xs

{eq, deepEq} = require 'testhelp'#auto_require:testhelp

{buildUrl, extractPathParts, extractQuery} = require './utils'

state0 = {path: ''}

state1 = {path: '/a/b/c', path0: 'a', path1: 'b', path2: 'c', q1: 1}
state2 = {path: '/a/b/c', path0: 'a', path1: 'b', path2: 'c', q1: [1, 2]}

describe 'utils', ->
	describe 'buildUrl', ->
		it 'inc', ->
			eq '/aa/b/cc/dd?q1=2&q3=3',
				buildUrl {path0: 'aa', path2: 'cc', path3: 'dd', q1: inc, q3: 3}, state1

		it 'remove + undefined', ->
			eq '/a/bb?q3=3',
				buildUrl {path1: 'bb', path2: undefined, q1: undefined, q3: 3}, state1
		it 'remove all', ->
			eq '/aa?q8=1',
				buildUrl always({path0: 'aa', q8: 1}), state1

		it 'array', ->
			eq '/a/b/c?q1=[1,2,3]', buildUrl {q1: append(3)}, state2
			eq '/a/b/c?q1=[1]', buildUrl {q1: without([2])}, state2
			eq '/a/b/c?q2=1', buildUrl {q1: without([2])}, {...state2, q2: 1, q1: []}

	describe 'extractPathParts', ->
		it 'simple case', ->
			deepEq {path0: 'a', path1: 'b', path2: 'cc'}, extractPathParts '/a/b/cc'

		it 'only /', ->
			deepEq {}, extractPathParts '/'

	describe 'extractQuery', ->
		it 'simple', ->
			deepEq {q1: [1, 2]}, extractQuery '?q1=[1,2]'
		it 'empty', ->
			deepEq {q1: []}, extractQuery '?q1=[]'

