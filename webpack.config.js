var path = require("path");
var webpack = require('webpack');

module.exports = {
  context: __dirname,
  entry: {
    weeks:  './app/frontend/javascripts/weeks.coffee',
  },
  output: {
    path: path.join(__dirname, 'app', 'assets', 'javascripts'),
    filename: "bundle-weeks.js",
    publicPath: "/js/",
    //devtoolModuleFilenameTemplate: '[resourcePath]',
    //devtoolFallbackModuleFilenameTemplate: '[resourcePath]?[hash]'
  },
  resolve: {
    extensions: ["", ".jsx", ".cjsx", ".coffee", ".js"]
  },
  module: {
    loaders: [
      { test: /\.js$/, loader: 'babel-loader'},
      { test: /\.jsx$/, loader: "jsx-loader?insertPragma=React.DOM" },
      { test: /\.cjsx$/, loaders: ["coffee", "cjsx"]},
      { test: /\.coffee$/,   loader: "coffee-loader"},
      {
        test: path.join(__dirname, 'app', 'frontend', 'javascripts', 'weeks_init.js'),
        loader: 'expose?weeksInit'
      }
    ]
  },
  externals: {
    jquery: "var jQuery"
  },
  plugins: [
    new webpack.ProvidePlugin({
      'React': 'react',
      'Marty': 'marty',
      $: 'jquery',
      jQuery: 'jquery',
    })
  ]
}