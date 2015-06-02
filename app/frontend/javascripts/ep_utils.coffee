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

module.exports = new EPutils();