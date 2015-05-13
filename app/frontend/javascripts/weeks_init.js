WeeksStore = require('./stores/weeks_store');

//for Marty Developer Tools
window.Marty = require('marty')

var WeeksInit = function() {};

WeeksInit.prototype.initWeeks = function(data) {
  WeeksStore.setInitialState(data);
};


module.exports = new WeeksInit();