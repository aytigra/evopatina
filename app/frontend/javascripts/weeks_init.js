WeeksStore = require('./stores/weeks_store');
SectorsStore = require('./stores/sectors_store');
SubsectorsStore = require('./stores/subsectors_store');
ActivitiesStore = require('./stores/activities_store');

var WeeksInit = function() {};

WeeksInit.prototype.initCurrentWeek = function(data) {
  WeeksStore.setInitialState(data);
};

WeeksInit.prototype.initSectors = function(data) {
  SectorsStore.setInitialState(data);
};

WeeksInit.prototype.initSubsectors = function(data) {
  SubsectorsStore.setInitialState(data);
};

WeeksInit.prototype.initActivities = function(data) {
  ActivitiesStore.setInitialState(data);
};

module.exports = new WeeksInit();