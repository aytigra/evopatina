class EPutils

  normalize_count: (count) ->
    count = count + ''
    if count.indexOf('.') is -1
      count = count.replace(/^0/, '0.') if /^0\d/.test(count)
      count = count.replace(/,/, '.')
      count = count.replace(/\//, '.')
      count = count.replace(/ю/, '.')
    count

  round: (value, decimals) ->
    Number(Math.round(value+'e'+decimals)+'e-'+decimals)

  sector_status_icon: (ratio) ->
    if ratio >= 1
      'heart'
    else if ratio >= 0.75 and ratio < 1
      'arrow-up'
    else if ratio >= 0.5 and ratio < 0.75
      'triangle-top'
    else if ratio >= 0.25 and ratio < 0.5
      'minus'
    else if ratio > 0 and ratio < 0.25
      'triangle-bottom'
    else
      'arrow-down'


  # hash = { id: { position: x } }
  map_by_position: (hash, callback) ->
    Object.keys(hash).sort((a, b) -> hash[a].position - hash[b].position).map (key) ->
      callback(hash[key], key)


module.exports = new EPutils();