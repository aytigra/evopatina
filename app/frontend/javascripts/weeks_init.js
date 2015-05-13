WeeksStore = require('./stores/weeks_store');
SectorsStore = require('./stores/sectors_store');
SubsectorsStore = require('./stores/subsectors_store');
ActivitiesStore = require('./stores/activities_store');

//for Marty Developer Tools
window.Marty = require('marty')

var WeeksInit = function() {};

WeeksInit.prototype.initWeeks = function(data) {
  WeeksStore.setInitialState(data);
};


module.exports = new WeeksInit();