#noinspection CoffeeScriptUnusedLocalSymbols
define ['cs!coffee/visualizer/lineVisualizer', 'cs!coffee/geometry/line'], (LineVisualizer, Line) ->
  class SocketVisualizer extends LineVisualizer

    constructor: (socketClient, filteredType) ->
      super()
      @_socketClient = socketClient
      @_filteredType = filteredType

    start: =>
      @_socketClient.on 'data', @_dataArrived
      @_socketClient.on 'disconnected', @_disconnected

    _disconnected: =>
      @_removeAllLines()

    _dataArrived: (data) =>
      return if !@_filteredType? || @_filteredType != data.type
      @_displayEntities data.entities if data?.entities?

    _displayEntities: (entities) =>
      @_displayLines @_getLinesForEntities(entities)

    _getLinesForEntities: (entities) =>
      lines = []
      for entity in entities
        for line in entity.lines
          lines.push(new Line(@_getLineId(entity, line), line.start, line.end))
      return lines

    _getLineId: (entity, line) =>
      return "#{entity.id}_#{line.id}"