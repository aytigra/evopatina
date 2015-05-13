var path = require("path");
var webpack = require('webpack');

var config = {
  context: __dirname,
  entry: {
    weeks:  './app/frontend/javascripts/weeks.coffee',
  },
  output: {
    path: path.join(__dirname, 'app', 'assets', 'javascripts'),
    filename: "bundle-weeks.js",
    publicPath: "/js/",
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
      _: 'underscore',
    })
  ]
}

module.exports = config;

// Next line is Heroku specific. You'll have BUILDPACK_URL defined for your Heroku install.
const devBuild = (typeof process.env.BUILDPACK_URL) === 'undefined';
if (devBuild) {
  console.log('Webpack dev build for Rails'); // eslint-disable-line no-console
  config.devtool = 'source-map';
  config.output.devtoolModuleFilenameTemplate = '[resourcePath]';
  config.output.devtoolFallbackModuleFilenameTemplate = '[resourcePath]?[hash]';
  config.module.loaders.push(
    { test: require.resolve("react"), loader: "expose?React" }
  );
  config.plugins.push(
    function () {
      this.plugin("emit", function (compilation, callback) {
        // CRITICAL: This must be a relative path from the railsJsAssetsDir (where gen file goes)
        var asset = compilation.assets["bundle-weeks.js.map"];
        compilation.assets["../../../public/assets/bundle-weeks.js.map"] = asset;
        delete compilation.assets["bundle-weeks.js.map"];
        callback();
      });
    }
  );
} else {
  console.log('Webpack production build for Rails'); // eslint-disable-line no-console
  config.plugins.push(
    new webpack.optimize.UglifyJsPlugin({
      compress: {
        warnings: false
      }
    })
  );
}