define ['cs!coffee/visualizer/visualizer',  'jquery'], (Visualizer, $) ->
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
          @_currentLineElements[lineId] = @_currentLineElements[lineId] || @_createElement(lineId, 'line')
          @_moveLine(lineId, line)

      @_removeElementsFrom @_currentLineElements, (lineId for lineId, lineElement of @_currentLineElements when !idsUsed[lineId])

    _getLineId: (entity, line) =>
      return "#{entity.id}_#{line.id}"