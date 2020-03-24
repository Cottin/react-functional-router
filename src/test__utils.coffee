{append, dec, empty, inc, match, path, remove, without} = R = require 'ramda' #auto_require: ramda
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
		it 'star + inc', ->
			eq '/aa/b/cc/dd/e?q1=2&q3=3',
				buildUrl {path: '/aa/*/cc/dd/e', query: {q1: inc, q3: 3}}, state1

		it 'remove + undefined', ->
			eq '/a/bb?q3=3',
				buildUrl {path: '/*/bb', query: {q1: undefined, q3: 3}}, state1

		it 'remove query', ->
			eq '/a/bb',
				buildUrl {path: '/*/bb', query: undefined}, state1

		# it 'assoc new query', ->
		# 	eq '/a/bb?q2=2',
		# 		buildUrl {path: '/*/bb', query: {$assoc: {q2: 2}}}, state1

		it 'only query', ->
			eq '/a/b/c?q1=0&q2=2',
				buildUrl {query: {q1: dec, q2: 2}}, state1

		it 'only path', ->
			eq '/a/bb/c?q1=1',
				buildUrl {path: '/*/bb/*'}, state1

		it 'array', ->
			eq '/a/b/c?q1=[1,2,3]', buildUrl {query: {q1: append(3)}}, state2
			eq '/a/b/c?q1=[1]', buildUrl {query: {q1: without([2])}}, state2
			eq '/a/b/c?q2=1', buildUrl {query: {q1: without([2])}}, {...state2, q2: 1, q1: []}

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

