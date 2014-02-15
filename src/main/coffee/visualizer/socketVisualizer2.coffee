define ['cs!coffee/visualizer/visualizer', 'jquery'], (Visualizer, $) ->
  class SocketVisualizer extends Visualizer

    constructor: (socketClient, filteredType) ->
      @_socketClient = socketClient
      @_filteredType = filteredType
      @_currentHandElements = {}

    start: =>
      @_socketClient.on 'data', @_dataArrived

    _dataArrived: (data) =>
      @_recalculateEntities data.entities if data?.entities?

    _recalculateEntities: (frameHands) =>
      idsUsed = {}
      for entity in frameHands
        for line in entity.lines
          lineId = @_getLineId(entity, line)
          idsUsed[lineId] = true
          @_currentHandElements[lineId] = @_currentHandElements[lineId] || @_createElement(lineId, 'hand')
          @_moveElement @_currentHandElements[lineId], getImagePosition(line), getFingerRotation(line)

      @_removeElementsFrom @_currentHandElements, (handId for handId, handElement of @_currentHandElements when !idsUsed[handId])

    _getLineId: (entity, line) =>
      return "id"

    getImagePosition = (position) ->
      return [0, 0, 300]

    getFingerRotation = (finger) ->
      return [0, 0, 0]

