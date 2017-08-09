assert = require 'assert'
{empty, flip} = require 'ramda' #auto_require:ramda

{extractPage, extractQuery} = require './utils'

eq = flip assert.strictEqual
deepEq = flip assert.deepStrictEqual
throws = (f) -> assert.throws f, Error
yeq = assert.strictEqual
ydeepEq = assert.deepStrictEqual

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

	describe 'extractQuery', ->
		it 'simple case', ->
			res = extractQuery '?a=2&b=3.2&c=hej&d=true'
			ydeepEq res, {a: 2, b: 3.2, c: 'hej', d: true}



