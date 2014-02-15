define ['cs!coffee/visualizer/visualizer', 'jquery'], (Visualizer, $) ->
  class SocketVisualizer extends Visualizer

    constructor: (socketClient, filteredType) ->
      @_socketClient = socketClient
      @_filteredType = filteredType
      @_currentLineElements = {}

    start: =>
      @_socketClient.on 'data', @_dataArrived
      @_socketClient.on 'disconnected', @_disconnected

    _disconnected: =>
      @_removeElementsFrom @_currentLineElements, (lineId for lineId, lineElement of @_currentLineElements)

    _dataArrived: (data) =>
      return if !@_filteredType? || @_filteredType != data.type
      @_recalculateEntities data.entities if data?.entities?

    _recalculateEntities: (entities) =>
      idsUsed = {}
      for entity in entities
        for line in entity.lines
          lineId = @_getLineId(entity, line)
          idsUsed[lineId] = true
          @_currentLineElements[lineId] = @_currentLineElements[lineId] || @_createElement(lineId, 'finger')
          @_moveElement @_currentLineElements[lineId], getImagePosition(line), getRotation(line)

      @_removeElementsFrom @_currentLineElements, (lineId for lineId, lineElement of @_currentLineElements when !idsUsed[lineId])

    _getLineId: (entity, line) =>
      return "#{entity.id}_#{line.id}"

    getImagePosition = (line) ->
      startPosition = getPosition(line.start)
      endPosition = getPosition(line.end)
      (startPosition[index] + (endPosition[index] - startPosition[index]) / 2 for index in [0..2])

    getPosition = (point) ->
      [point.x * 4000 - 200, -point.z * 1000, point.y * 10000]

    getRotation = (line) ->
      direction = [ line.end.x - line.start.x, line.end.y - line.start.y, line.end.z - line.start.z ]
      directionLength = Math.sqrt(direction[0] * direction[0] + direction[1] * direction[1] + direction[2] * direction[2]);
      direction = ( direction[index] / directionLength for index in [0..2])

      return [ -direction[1] * 90, 0, direction[0] * 90 ]
