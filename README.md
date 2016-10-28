Routing can get a bit complex sometimes... In some apps, using the query string brings you a long way. 

# React Functional Router
What if you could only use the query-string for routing?
What if you could think of that query string as a simple object?

- You wouldn't have to do any regexp pattern matching to figure out where you are, you just destruct the part you want.

```
{showPopup} = query
```

- You wouldn't have to do any concatenation to create an href, you just supply a function.

```
newQuery = assoc('showPopup', true, query)
```

This is essentially what React-Functional-Router lets you do :)


## Motivation
The goto alternative React-Router is quite big and prior to version 4, it feels somewhat over-engineered. 

If you just have some basic routing needs in your application, React-Functional-Router can give that to you at a fraction of the complexity. Read through the code for yourself, it's just around 200 lines.


## How it works
This router simplifies routing to two small building blocks "page" and "query"

```
  www.my-app.com/users?sort=asc&sidepanel=true
                   ^           ^
                   |           |
                 page          |
                             query
```

The idea is that these two building blocks are quite enough for building non-huge apps. When you interact with this router, the page is just a string and the query is just a javascript object like so:

```
{page: 'user', query: {sort: 'asc', sidepanel: true}}
```

And because of this simplification, thinking about routing becomes much simpler :)

Creating a link to...
...open a page: `Link {page: 'profile'}, 'Profile'`
...open a sidepanel: `Link {to: assoc('sidepanel', true)}, 'Open sidepanel'`

**The point is that** if you can think of the current url as an object, you can supply a simple function to change that url. And that's the whole point :)

Also, the router assumes you are using some kind of immutable data and shouldComponentUpdate optimizations. Therefore, it provides you with an `onChange`event that lets you update your data-store when the url changes. However, it provides you with only the delta of changes so that you can do a minimal update to your data-store.

```
ex. TODO
```

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
		Link {page: 'day', to: merge(__, {date: '2016-11-01'}}), 'Open dayview in November'
```

