var webpack = require('webpack');
var WebpackDevServer = require('webpack-dev-server');
var config = require('./webpack.config');

config.entry.unshift("webpack-dev-server/client?/", "webpack/hot/dev-server");
config.plugins.unshift(new webpack.HotModuleReplacementPlugin(), new webpack.NoErrorsPlugin());
//config.devtool = 'eval';
config.module.loaders.forEach(function(l) {
  if (l.loaders != undefined) {
    l.loaders.unshift('react-hot');
  }
});

new WebpackDevServer(webpack(config), {
  publicPath: config.output.publicPath,
  hot: true,
  contentBase: "/assets/",
  proxy: {"*": 'http://localhost:3000'},
  historyApiFallback: true,
  stats: { colors: true },
  //noInfo: true
}).listen(8080, '0.0.0.0', function (err, result) {
  if (err) {
    console.log(err);
  }

  console.log('Listening at 0.0.0.0:8080');
});