reportPage = ".container-report"
chart = new Chart()
loading = new Loading()

loadBubbleChart = () ->
  container = '.bubble-chart-container'
  loading.show(container)
  $.get "/tutor/report/time_reading", (res) ->
    data = ChartUtils.formatBubbleChartData(res.data)
    chart.renderBubbleChart
      data: data
      width: 500
      margin:
        top: 20
        right: 300
        bottom: 30
        left: 40
      selector: container

    loading.hide(container)

isReportPage = ->
  $(reportPage).length > 0

loadCharts = ->
  if isReportPage()
    userId = getParam('user_id')
    loadDonutChart(userId)
    loadBarChart()
    loadSingleBarCharts(userId)
    loadBubbleChart()
  return

loadDonutChart = (userId) ->
  container = '.donut-chart-container'
  loading.show(container)
  $.get "/tutor/report/root_contents_learnt", user_id: userId, (res) ->
    data = ChartUtils.formatDonutChartData(res.data)
    chart.renderDonutChart
      width: 550
      height: 350
      data: data
      selector: container
      margin:
        right: 200
    loading.hide(container)
  return

loadBarChart = ->
  container = '.bar-chart-container'
  loading.show(container)
  $.get "/tutor/report/tutor_users_contents_learnt", (res) ->
    data = ChartUtils.formatBarChartData(res.data)
    chart.renderBarChart
      width: 900
      height: 600
      data: data
      selector: container
      margin:
        top: 20
        right: 300
        bottom: 250
        left: 90

    loading.hide(container)
  return

loadSingleBarCharts = (userId) ->
  container = '.analytics-chart-container'
  loading.show(container)
  fields = [
    "used_time",
    "total_neurons_learnt",
    "total_content_readings",
    "average_used_time_by_content",
    "total_notes",
    "images_opened_in_count"
  ]
  $.get "/tutor/report/analytics_details", user_id: userId, fields: fields, (res) ->
    data = ChartUtils.formatSingleBarChartData(res.data)
    legends = []
    data.used_time.className = 'fill-used-time-chart'
    data.used_time.maxValue = adjustMaxTime(data.used_time)
    ChartUtils.addLegendValue(legends, data.used_time)
    data.total_neurons_learnt.className = 'fill-total-neurons-learnt-chart'
    ChartUtils.addLegendValue(legends, data.total_neurons_learnt)
    data.total_content_readings.className = 'fill-total-content-readings-chart'
    ChartUtils.addLegendValue(legends, data.total_content_readings)
    data.average_used_time_by_content.className = 'fill-average-used-time-by-content-chart'
    ChartUtils.addLegendValue(legends, data.average_used_time_by_content)
    data.images_opened_in_count.className = 'fill-images-opened-in-count-chart'
    ChartUtils.addLegendValue(legends, data.images_opened_in_count)
    data.total_notes.className =  'fill-total-notes-chart'
    ChartUtils.addLegendValue(legends, data.total_notes)
    width = 100
    height = 450
    commonMargin =
      top: 20
      right: 0
      bottom: 50
      left: 0

    chart.renderSingleBarChart
      selector: '.used-time-chart'
      type: 'time'
      format: 'hours'
      data: data.used_time
      width: width
      className: data.used_time.className
      height: height
      margin: commonMargin

    chart.renderSingleBarChart
      selector: '.total-neurons-learnt-chart'
      type: 'number'
      data: data.total_neurons_learnt
      width: width
      className: data.total_neurons_learnt.className
      height: height
      margin: commonMargin

    chart.renderSingleBarChart
      selector: '.total-content-readings-chart'
      type: 'number'
      data: data.total_content_readings
      width: width
      className: data.total_content_readings.className
      height: height
      margin: commonMargin

    chart.renderSingleBarChart
      selector: '.average-used-time-by-content-chart'
      type: 'time'
      format: 'mins'
      data: data.average_used_time_by_content
      width: width
      className: data.average_used_time_by_content.className
      height: height
      margin: commonMargin

    chart.renderSingleBarChart
      selector: '.images-opened-in-count-chart'
      type: 'number'
      data: data.images_opened_in_count
      width: width
      className: data.images_opened_in_count.className
      height: height
      margin: commonMargin

    chart.renderSingleBarChart
      selector: '.total-notes-chart'
      type: 'number'
      data: data.total_notes
      width: width
      className: data.total_notes.className
      height: height
      margin: commonMargin

    chart.renderIsolatedLegend
      selector: ".chart-legends"
      data: legends
      width: 250
      height: 550

    loading.hide(container)
    return

getParam = (name) ->
  (location.search.split(name + '=')[1] or '').split('&')[0]

adjustMaxTime = (item) ->
  maxTimeLimit = moment.duration(90, 'days').asMilliseconds()
  return  if item.value > maxTimeLimit then item.maxValue else maxTimeLimit

$(document).on "ready page:load", loadCharts
