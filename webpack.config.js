var path = require("path");
var webpack = require('webpack');

var sourcepath = path.join(__dirname, 'app', 'frontend', 'javascripts');

var config = {
  context: __dirname,
  entry: [
    sourcepath + '/weeks.coffee'
  ],
  output: {
    path: path.join(__dirname, 'app', 'assets', 'javascripts'),
    filename: "bundle-weeks.self.js",
    publicPath: "/assets/",
  },
  resolve: {
    extensions: ["", ".js", ".cjsx", ".coffee"]
  },
  module: {
    loaders: [
      { test: /\.js$/, loader: 'babel', include: sourcepath },
      { test: /\.(cjsx|coffee)$/, loaders: ["coffee", "cjsx"], include: sourcepath },
    ]
  },
  externals: {
    jquery: "var jQuery"
  },
  plugins: [
    new webpack.ProvidePlugin({
      'React': 'react',
      'Marty': 'marty',
      'AppStore': sourcepath + '/stores/app_store',
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
  config.module.loaders.push(
    { test: require.resolve("react"), loader: "expose?React" },
    { test: require.resolve("marty"), loader: "expose?Marty" }
  );
} else {
  console.log('Webpack production build for Rails'); // eslint-disable-line no-console
}