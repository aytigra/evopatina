#= require application

$(document).on "ready page:change", ->
  $('[data-toggle="tooltip"]').tooltip({delay: { "show": 200, "hide": 100 }})