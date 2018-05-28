require('dotenv').config()

/* eslint-disable */
const path = require('path')
const webpack = require('webpack')
const HtmlWebpackPlugin = require('html-webpack-plugin')

module.exports = {
  entry: ['./src/index'],
  output: {
    path: path.join(__dirname, 'dist'),
    filename: 'bundle.js',
    publicPath: '/static/'
  },
  module: {
    rules: [
      {
        exclude: /node_modules|packages/,
        test: /\.js$/,
        use: 'babel-loader',
      },
      // {
      //   test: /\.coffee?$/,
      //   loaders: ['babel-loader', 'coffee-loader'],
      //   include: [
      //     path.join(__dirname, 'src')
      //   ]
      // },
      {
        exclude: /node_modules|packages/,
        test: /\.coffee$/,
        use: [ 'coffee-loader' ]
      }
    ],
  },
  resolve: {
    extensions: ['.js', '.coffee'],
    alias: {
      'react-functional-router': path.join(__dirname, '../../src')
    }
  },
  plugins: [
    new HtmlWebpackPlugin({
      title: 'Custom template',
      // Load a custom template (lodash by default see the FAQ for details)
      template: 'index.html',
      inject: true,
      // filename: '/index.html'
    }),
    new webpack.NamedModulesPlugin(),
  ],
  devServer: {
    host: 'localhost',
    port: process.env.PORT,

    historyApiFallback: true,
    // respond to 404s with index.html

    hot: true,
    // enable HMR on the server
  },
}
