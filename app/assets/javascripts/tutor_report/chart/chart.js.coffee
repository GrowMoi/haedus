class window.Chart

  #------- Donut Chart -------
  renderDonutChart : (options) ->
    defaults =
      selector: ''
      width: 500
      height: 300
      data: []

    settings = $.extend({}, defaults, options)
    settings.radius = Math.min(settings.width, settings.height) / 2
    legendRectSize = 15
    legendSpacing = 4
    legendRightPadding = 15
    legendVerticalPadding = 20
    legendVerticalHeight = 50
    maxValue = getMaxValue(settings.data)

    arc = d3.svg.arc()
            .outerRadius(settings.radius - 10)
            .innerRadius(settings.radius - 70)

    pie = d3.layout.pie()
            .sort(null)
            .value((d) ->
              d.value
            )

    svg = d3.select(settings.selector)
            .append('svg')
            .attr('width', settings.width)
            .attr('height', settings.height)
            .append('g')
            .attr('transform', 'translate(' + settings.width / 3 + ',' + settings.height / 2 + ')')

    div = d3.select('body').append('div').attr('class', 'tooltip-donut')

    g = svg.selectAll('.arc')
            .data(pie(settings.data))
            .enter()
            .append('g')
            .attr('class', 'arc')

    g.append('path')
            .attr('d', arc)
            .attr('class', (d, i) ->
              addClass('donut-color-', d, i)
            )

    g.append('text')
            .attr('transform', (d) ->
              'translate(' + arc.centroid(d) + ')'
            )
            .attr('dy', '.35em')
            .attr('class', 'donut-text')
            .text((d) ->
              res = d.data.value * 100 / maxValue
              res.toFixed(2) + '%'
            )
            .each((d) ->
              bb = @getBBox()
              center = arc.centroid(d)
              topLeft =
                x: center[0] + bb.x
                y: center[1] + bb.y
              topRight =
                x: topLeft.x + bb.width
                y: topLeft.y
              bottomLeft =
                x: topLeft.x
                y: topLeft.y + bb.height
              bottomRight =
                x: topLeft.x + bb.width
                y: topLeft.y + bb.height
              d.visible = pointIsInArc(topLeft, d, arc) and
                          pointIsInArc(topRight, d, arc) and
                          pointIsInArc(bottomLeft, d, arc) and
                          pointIsInArc(bottomRight, d, arc)
              return
            ).style 'display', (d) ->
              if d.visible then null else 'none'

    g.on('mousemove', (d) ->
      div.style('left', d3.event.pageX + 10 + 'px')
      div.style('top', d3.event.pageY - 25 + 'px')
      div.style('display', 'inline-block')
      div.html('Contenidos aprendidos en la rama \'' + (d.data.title ) + '\'' + ': ' + (d.value))
    )
    .on('mouseout', (d) ->
      div.style('display', 'none')
    )
    legend = svg.selectAll('.legend')
                .data(settings.data)
                .enter()
                .append('g')
                .attr('class', 'legend')
                .attr('transform', (d, i) ->
                  dataHeight = legendRectSize + legendSpacing
                  offset = dataHeight + i
                  horz = legendRightPadding * legendRectSize
                  vert = (i * legendVerticalPadding) - legendVerticalHeight
                  'translate(' + horz + ',' + vert + ')'
                )
                .on('mousemove', (d) ->
                  div.style('left', d3.event.pageX + 10 + 'px')
                  div.style('top', d3.event.pageY - 30 + 'px')
                  div.style('display', 'inline-block')
                  res = d.value * 100 / maxValue
                  div.html('Progreso: ' + res.toFixed(2) + '%')
                )
                .on('mouseout', (d) ->
                  div.style('display', 'none')
                )

    legend.append('rect')
          .attr('width', legendRectSize)
          .attr('height', legendRectSize)
          .attr('class', (d, i) ->
            addClass('donut-color-', d, i)
          )

    legend.append('text')
          .attr('class', 'donut-legend-text')
          .attr('x', legendRectSize + legendSpacing)
          .attr('y', legendRectSize - legendSpacing).text (d) ->
            d.title

    return

  #------- Bar Chart -------
  renderBarChart: (options) ->
    defaults =
      selector: ''
      data: []
      width: 960
      height: 500
      margin:
        top: 20
        right: 20
        bottom: 30
        left: 40

    settings = $.extend({}, defaults, options)
    dimensionName = 'label'
    rangeFillClasses = [0, 6]
    legendRectSize = 15
    legendSpacing = 4
    margin = settings.margin
    width = settings.width - (margin.left) - (margin.right)
    height = settings.height - (margin.top) - (margin.bottom)

    x0 = d3.scale.ordinal().rangeRoundBands([0, width], .1)
    x1 = d3.scale.ordinal()
    y = d3.scale.linear().range([height, 0])
    xAxis = d3.svg.axis().scale(x0).orient('bottom')
    yAxis = d3.svg.axis().scale(y).orient('left').tickFormat(d3.format('.2s'))

    settings.data.forEach (d) ->
      d.categories = [ {
        name: 'id'
        value: +d.value
      } ]
      return

    x0.domain settings.data.map((d) ->
      d.id
    )

    x1.domain([ 'value' ]).rangeRoundBands [0, x0.rangeBand()]

    y.domain [0, d3.max(settings.data, (d) ->
        d3.max d.categories, (d) ->
          d.value
      )
    ]

    svg = d3.select(settings.selector)
            .append('svg')
            .attr('class', 'bar-chart')
            .attr('width', width + margin.left + margin.right)
            .attr('height', height + margin.top + margin.bottom)
            .append('g')
            .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

    div = d3.select('body').append('div').attr('class', 'tooltip-bar')

    xAxisEl = svg.append('g')
                .attr('class', 'x axis')
                .attr('transform', 'translate(0,' + height + ')')
                .call(xAxis)

    xAxisEl.selectAll('text')
          .style('text-anchor', 'end')
          .attr('dx', '-1em')
          .attr('y', '-.5em')
          .attr('transform', 'rotate(-80)')
          .text (d) ->
            item = settings.data.find((ud) ->
              ud.id == d
            )
            label = item.label or ''
            label

    yAxisEl = svg.append('g')
                .attr('class', 'y axis')
                .call(yAxis)

    layer = svg.selectAll('.category')
              .data(settings.data)

    containers = layer.enter()
                      .append('g')
                      .attr('class', 'g')
                      .attr('transform', (d) ->
                        'translate(' + x0(d.id) + ',0)'
                      )

    bars = containers.selectAll('rect').data((d) ->
      d.categories
    )

    bars.enter()
        .append('rect')
        .attr('width', x1.rangeBand())
        .attr('x', (d) ->
          x1 d.label
        ).attr('y', (d) ->
          if !isNaN(d.value)
            return y(d.value)
          return
        ).attr('height', (d) ->
          if !isNaN(d.value)
            return height - y(d.value)
          return
        ).attr('class', (d, v, i) ->
          maxVal = rangeFillClasses[1]
          addClassInRange 'fill-color-', i, maxVal
        )
        .on('mousemove', (d) ->
          div.style('left', d3.event.pageX + 10 + 'px')
          div.style('top', d3.event.pageY - 25 + 'px')
          div.style('display', 'inline-block')
          div.html('Aprendidos: '+ (d.value))
        )
        .on('mouseout', (d) ->
          div.style('display', 'none')
        )

    svg.selectAll('.y.axis')
      .selectAll('.tick line')
      .call(yAxis)
      .attr 'x2', width

    legend = svg.selectAll('.legend')
                .data(settings.data)
                .enter()
                .append('g')
                .attr('class', 'legend')
                .attr('transform', (d, i) ->
                  horz = width + 30
                  vert = i * 20
                  'translate(' + horz + ',' + vert + ')'
                )

    legend.append('rect')
          .attr('width', legendRectSize)
          .attr('height', legendRectSize)
          .attr 'class', (d, i) ->
            maxVal = rangeFillClasses[1]
            addClassInRange 'fill-color-', i, maxVal

    legend.append('text')
          .attr('x', legendRectSize + legendSpacing)
          .attr('y', legendRectSize - legendSpacing)
          .text (d) ->
            d.label

  #------- Single Bar Chart -------
  renderSingleBarChart: (options) ->
    defaults =
      selector: ''
      data: {}
      type: 'number'
      format: 'hours'
      width: 500
      height: 300
      showYaxis: false
      margin:
        top: 20
        right: 20
        bottom: 80
        left: 80
    settings = $.extend({}, defaults, options)
    margin = settings.margin
    width = settings.width - (margin.left) - (margin.right)
    height = settings.height - (margin.top) - (margin.bottom)
    type = settings.type
    data = settings.data
    x = d3.scale.ordinal().rangeRoundBands([0, width], .05)
    y = d3.scale.linear().range([height, 0])
    xAxis = d3.svg.axis().scale(x).orient('bottom')
    yAxis = d3.svg.axis().scale(y).orient('left')
    svg = d3.select(settings.selector)
            .append('svg')
            .attr('width', width + margin.left + margin.right)
            .attr('height', height + margin.top + margin.bottom)
            .append('g')
            .attr('transform', 'translate(' + margin.left + ',' + margin.top + ')')

    x.domain [ data.value ]
    y.domain [0, data.maxValue]

    div = d3.select('body').append('div').attr('class', 'tooltip-single-bar')

    svg.append('g')
        .attr('class', 'x axis')
        .attr('transform', 'translate(0,' + height + ')')
        .call(xAxis)
        .selectAll('text')
        .style('text-anchor', 'center')
        .attr('dx', '0')
        .attr('dy', '1.5em')
        .attr('y', 0)
        .attr('transform', 'rotate(0)')
        .text (d) ->
          formatTextLabel type, data, settings.format
    if settings.showYaxis
      svg.append('g')
        .attr('class', 'y axis')
        .call(yAxis)
        .selectAll('text')
        .text((d) ->
          d
        )

    svg.selectAll('bar')
      .data([ data ])
      .enter()
      .append('path')
      .attr('class', settings.className)
      .attr 'd', (d, i) ->
        _x = x(d.value)
        _y = y(d.value)
        _width = x.rangeBand()
        _height = height - y(d.value)
        _radius = 2
        rectangle _x, _y, _width, _height, _radius
      .on('mousemove', (d) ->
        div.style 'left', d3.event.pageX + 10 + 'px'
        div.style 'top', d3.event.pageY - 25 + 'px'
        div.style 'display', 'inline-block'
        if type == 'time'
          div.html 'Tiempo: ' + d.valueHumanized
        else
          div.html 'Valor: ' + d.value
        return
      ).on 'mouseout', (d) ->
        div.style 'display', 'none'
        return

    return

  #------- Bubble Chart -------
  renderBubbleChart: (options) ->
    defaults =
      selector: ''
      data: []
      width: 400
      height: 400
      yAxisLabel: ''
      margin:
        right: 200
    settings = $.extend({}, defaults, options)
    rangeFillClasses = [0, 6]
    data = settings.data
    root = {}
    legendRectSize = 15
    legendSpacing = 4
    root.name = 'Interactions'
    root.children = []
    i = 0
    while i < data.length
      item = {}
      item.name = data[i][0]
      item.value = Number(data[i][1])
      item.id = data[i][2]
      item.valueHumanized = data[i][3]
      root.children.push item
      i++

    bubble = d3.layout.pack()
                .sort(null)
                .size([settings.width, settings.height])
                .padding(5)

    svg = d3.select(settings.selector)
            .append('svg')
            .attr('width', settings.width + settings.margin.right)
            .attr('height', settings.height)
            .attr('class', 'bubble')

    node = svg.selectAll('.node')
              .data(bubble.nodes(root)
                .filter((d) ->
                  !d.children
                ))
              .enter()
              .append('g')
              .attr('class', 'node')
              .attr('transform', (d) ->
                'translate(' + d.x + ',' + d.y + ')'
              )

    div = d3.select('body').append('div').attr('class', 'tooltip-bubble')

    node.append('circle')
        .attr('r', (d) ->
          d.r
        )
        .attr('id', (d) ->
          d.id
        )
        .attr 'class', (d, i) ->
          maxVal = rangeFillClasses[1]
          addClassInRange 'fill-color-', i, maxVal

    node.append('clipPath')
        .attr('id', (d) ->
          'clip-' + d.id
        )
        .append('use')
        .attr 'xlink:href', (d) ->
          '#' + d.id

    node.append('text')
        .attr('clip-path', (d) ->
          'url(#clip-' + d.id + ')'
        )
        .attr('dy', '.3em')
        .attr('class', 'circle-text')
        .style('text-anchor', 'middle')
        .text (d, ind) ->
          maxLength = 10
          if (d.name.length > maxLength)
            return d.name.substring(0, maxLength).concat('...')

          return d.name

    node.on('mousemove', (d) ->
      div.style 'left', d3.event.pageX + 10 + 'px'
      div.style 'top', d3.event.pageY - 25 + 'px'
      div.style 'display', 'inline-block'
      div.html 'Nombre: ' + d.name + '<br/>' + 'Tiempo de lectura: ' + d.valueHumanized
      return
    )
    .on 'mouseout', (d) ->
      div.style 'display', 'none'
      return

    legend = svg.selectAll('.legend')
                .data(data)
                .enter()
                .append('g')
                .attr('class', 'legend')
                .attr('transform', (d, i) ->
                  horz = settings.width + 20
                  vert = (i * 20) + 60
                  'translate(' + horz + ',' + vert + ')'
                )

    legend.on('mousemove', (d) ->
            div.style 'left', d3.event.pageX + 10 + 'px'
            div.style 'top', d3.event.pageY - 25 + 'px'
            div.style 'display', 'inline-block'
            timeReading = if d[3] == '' then '0' else d[3]
            div.html 'Tiempo de lectura: ' + timeReading
            return
          )
          .on('mouseout', (d) ->
            div.style 'display', 'none'
            return
          )

    legend.append('rect')
          .attr('width', legendRectSize)
          .attr('height', legendRectSize)
          .attr('class', (d, i) ->
            maxVal = rangeFillClasses[1]
            addClassInRange 'fill-color-', i, maxVal
          )

    legend.append('text')
          .attr('x', legendRectSize + legendSpacing)
          .attr('y', legendRectSize - legendSpacing)
          .text (d) ->
            d[0]

  #------- Isolated Legend -------
  renderIsolatedLegend: (options) ->
    defaults =
      selector: ''
      data: []
      width: 200
      height: 500
    settings = $.extend({}, defaults, options)
    rangeFillClasses = [
      0
      6
    ]
    legendRectSize = 15
    legendSpacing = 4
    width = settings.width
    height = settings.height
    svg = d3.select(settings.selector)
            .append('svg')
            .attr('class', 'bar-chart')
            .attr('width', width)
            .attr('height', height)
    legend = svg.selectAll('.legend')
                .data(settings.data)
                .enter()
                .append('g')
                .attr('class', 'legend')
                .attr('transform', (d, i) ->
                  horz = 30
                  vert = (i * 20) + 30
                  'translate(' + horz + ',' + vert + ')'
                )

    legend.append('rect')
          .attr('width', legendRectSize)
          .attr('height', legendRectSize)
          .attr 'class', (d, i) ->
            d.className

    legend.append('text')
          .attr('x', legendRectSize + legendSpacing)
          .attr('y', legendRectSize - legendSpacing)
          .text (d) ->
            d.label

  #------- Additional Functions -------
  generateColor = ->
    rgbStr = getComputedStyle(this).getPropertyValue('fill')
    rgb = d3.rgb(rgbStr)
    rgb

  addClass = (prefix, d, i) ->
    prefix + i

  getMaxValue = (data) ->
    result = 0
    values = data.map((d) ->
      d.value
    )
    if values.length > 0
      result = values.reduce (prevVal, newVal) ->
        prevVal + newVal
    result

  addClassInRange = (prefix, i, max) ->
    itemData =
      index: i
      max: max
    recursiveIndexGenerator itemData
    prefix + itemData.index

  recursiveIndexGenerator = (itemData) ->
    if itemData.index > itemData.max
      itemData.index = itemData.index - (itemData.max + 1)
      recursiveIndexGenerator itemData
    else
      itemData.index
    return

  formatTextLabel = (type, data, format) ->
    if type == 'time'
      return formatTimeLabel(data.value, format)
    data.value

  rectangle = (x, y, width, height, radius) ->
    str1 = 'M' + (x + radius) + ',' + y + 'h' + (width - (2 * radius))
    str2 = 'a' + radius + ',' + radius + ' 0 0 1 ' + radius + ',' + radius
    str3 = 'v' + (height - (2 * radius)) + 'v' + radius + 'h' + (-radius) + 'h'
    str4 = (2 * radius - width) + 'h' + (-radius) + 'v' + (-radius) + 'v'
    str5 = (2 * radius - height) + 'a' + radius + ',' + radius + ' 0 0 1 ' + radius + ',' + (-radius) + 'z'
    str1 + str2 + str3 + str4 + str5

  formatTimeLabel = (millisecondsString, format) ->
    milliseconds = parseInt(millisecondsString)
    if isNaN(milliseconds)
      0
    else
      duration = moment.duration(milliseconds)
      hours = Math.floor(duration.asHours())
      mins = Math.floor(duration.asMinutes()) - hours * 60
      seconds = Math.floor(duration.asSeconds()) - mins * 60
      hours = if hours < 10 then '0' + hours else hours
      mins = if mins < 10 then '0' + mins else mins
      seconds = if seconds < 10 then '0' + seconds else seconds
      if format == 'hours'
        finalString = hours + ':' + mins
      else if format == 'mins'
        finalString = mins + ':' + seconds
      else
        finalString = hours + ':' + mins

      finalString

  pointIsInArc = (pt, ptData, d3Arc) ->
    r1 = d3Arc.innerRadius()(ptData)
    r2 = d3Arc.outerRadius()(ptData)
    theta1 = d3Arc.startAngle()(ptData)
    theta2 = d3Arc.endAngle()(ptData)
    dist = pt.x * pt.x + pt.y * pt.y
    angle = Math.atan2(pt.x, -pt.y)
    angle = if angle < 0 then angle + Math.PI * 2 else angle
    r1 * r1 <= dist and dist <= r2 * r2 and theta1 <= angle and angle <= theta2
