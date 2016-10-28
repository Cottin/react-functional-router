var path = require('path');
var webpack = require('webpack');

module.exports = {
  devtool: 'cheap-module-eval-source-map',
  entry: [
    'eventsource-polyfill', // necessary for hot reloading with IE
    'webpack-hot-middleware/client',
    './src/main'
  ],
  output: {
    path: path.join(__dirname, 'dist'),
    filename: 'bundle.js',
    publicPath: '/static/'
  },
  plugins: [
    new webpack.HotModuleReplacementPlugin(),
    new webpack.NoErrorsPlugin()
  ],
  resolve: {
    extensions: ['', '.js', '.coffee'],
    alias: {
      'react-functional-router': path.join(__dirname, '../../src')
    }
  },
  module: {
    loaders: [
    {
      test: /\.coffee?$/,
      loaders: ['babel', 'coffee-loader'],
      include: [
        path.join(__dirname, 'src'),
        path.join(__dirname, '../../src')
      ]
    },
    // {
    //   test: /\.coffee?$/,
    //   loaders: ['coffee-loader'],
    //   include: path.join(__dirname, '../../src')
    // }
    ]
  }
};
