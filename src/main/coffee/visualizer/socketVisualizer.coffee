define ['cs!coffee/visualizer/visualizer', 'cs!coffee/geometry/point3', 'cs!coffee/geometry/vector3', 'jquery'], (Visualizer, Point3, Vector3, $) ->
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
          @_moveElement @_currentLineElements[lineId], getScaleFactor(line), getImagePosition(line),getRotation(line)

      @_removeElementsFrom @_currentLineElements, (lineId for lineId, lineElement of @_currentLineElements when !idsUsed[lineId])

    _getLineId: (entity, line) =>
      return "#{entity.id}_#{line.id}"

    getScaleFactor = (line) ->
      [1, 1, 1]

    getImagePosition = (line) ->
      startPosition = getShownPosition(line.start)
      endPosition = getShownPosition(line.end)
      startPosition.add(endPosition.subtract(startPosition).divide(2)).toArray()
      #startPosition.toArray()

    getShownPosition = (point) ->
      new Point3(point.x * 4000 - 200, point.z * 1000 - 700, point.y * 7000 + 500)

    getRotation = (line) ->
      startPosition = getPosition(line.start)
      endPosition = getPosition(line.end)
      direction = endPosition.subtract(startPosition).normalize()

      return [ -direction.y * 90, 0, direction.x * 90 ]

    getPosition = (point) ->
      return new Point3(point.x, point.y, point.z)
