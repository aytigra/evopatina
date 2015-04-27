var WeeksInit = function() {
  this.store_data = {};
};

WeeksInit.prototype.setStoreInitialState = function(id, data) {
  this.store_data[id] = data;
};

module.exports = new WeeksInit();