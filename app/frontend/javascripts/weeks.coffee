weeksInit = require './weeks_init'
SectorList = require './components/sector_list'

$(document).on "ready page:change", ->
  $('[data-toggle="tooltip"]').tooltip({delay: { "show": 200, "hide": 100 }})

  for id, sector of weeksInit.store_data
    React.render React.createElement(SectorList, { "key": id, "subsectors": sector }), document.getElementById('sector-list-' + id)