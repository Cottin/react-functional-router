all = require 'ramda/es/all'; always = require 'ramda/es/always'; append = require 'ramda/es/append'; empty = require 'ramda/es/empty'; inc = require 'ramda/es/inc'; match = require 'ramda/es/match'; path = require 'ramda/es/path'; remove = require 'ramda/es/remove'; without = require 'ramda/es/without'; #auto_require: srcramda
{cc} = RE = require 'ramda-extras' #auto_require: ramda-extras
[] = [] #auto_sugar
qq = (f) -> console.log match(/return (.*);/, f.toString())[1], f()
qqq = (f) -> console.log match(/return (.*);/, f.toString())[1], JSON.stringify(f(), null, 2)
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

