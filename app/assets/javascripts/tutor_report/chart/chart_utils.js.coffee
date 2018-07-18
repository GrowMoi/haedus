class window.ChartUtils
  this.formatBarChartData = (data) ->
    data.map (d) ->
      {
        id: d.user_id
        label: d.username
        value: d.contents_learnt
      }

  this.formatDonutChartData = (data) ->
    dataSort = data.sort (a, b) ->
      titleA = a.title.toUpperCase()
      titleB = b.title.toUpperCase()
      if titleA < titleB
        return -1
      if titleA > titleB
        return 1
      0

    dataSort.map (d) ->
      {
        id: d.id
        parentId: d.parent_id
        title: d.title
        value: d.total_contents_learnt
      }

  this.formatSingleBarChartData = (data) ->
    res = {}
    for key of data
      res[key] =
        maxValue: data[key].max_value
        value: data[key].value
        valueHumanized: if data[key].meta and data[key].meta.value_humanized then data[key].meta.value_humanized else null
        meta: data[key].meta
    res

  this.formatBubbleChartData = (data) ->
    result = []
    i = 0
    while i < data.length
      row = []
      row.push data[i].username
      row.push data[i].value
      row.push data[i].user_id
      row.push data[i].value_humanized
      result.push row
      i++
    result

  this.addLegendValue = (arrayLegends, item) ->
    arrayLegends.push
      label: if item.meta and item.meta.label then item.meta.label else ''
      className: item.className
    return
