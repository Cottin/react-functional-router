React = require 'react'
ReactDOM = require 'react-dom'
App = React.createFactory require('./App')

ReactDOM.render(App(), document.getElementById('root'))
