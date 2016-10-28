assert = require 'assert'
{empty, flip} = require 'ramda' #auto_require:ramda

{extractPage} = require './utils'

eq = flip assert.equal
deepEq = flip assert.deepEqual
throws = (f) -> assert.throws f, Error

describe 'utils', ->
	describe 'extractPage', ->
		it 'simple case', ->
			eq 'my-page', extractPage '/my-page'
		it 'empty page', ->
			eq '', extractPage '/'
		it 'with slash', ->
			eq 'my-page', extractPage '/my-page/'
		it 'with queries', ->
			eq 'my-page', extractPage '/my-page?query=1&a=2&b=3'
		it 'with queries with slash', ->
			eq 'my-page', extractPage '/my-page/?query=1&a=2&b=3'
		it 'with queries with two slashes', ->
			eq 'my-page', extractPage '/my-page/?query=1&a=2&b=3/'



