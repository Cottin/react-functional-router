# React Functional Router
Routing can get a bit complex sometimes... :(

In some apps, using the query string brings you a long way. 

## Examples

```
...
render: ->
	div {},

		# using functions to 
		Link {to: assoc('showPanel', true)}, 'Open panel'
		Link {to: dissoc('showPanel')}, 'Hide panel'

		# using page to change the [...] part of the url
		# e.g.  www.my-app.com/[...]?a=1&b=2
		Link {page: ''}, 'Goto Home page'
		Link {page: 'profile'}, 'Goto Profile page'
		Link {page: 'logout'}, 'Logout'

		# using both
		Link {page: 'day', to: {date: '2016-11-01'}}, 'Open dayview in November'

		# using active css class
		Link {activeClass: 'active', page: 'profile'}, 'Goto Profile page'

		# using activeClass with query string
		Link
			to: assoc('showPanel', true)
			activeClass: 'active'
			isActive: propEq('showPanel', true)
		, 'Goto Profile page'
```

