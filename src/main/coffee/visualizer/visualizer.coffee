define ['jquery'], ($) ->
  class Visualizer

    constructor: (leapController) ->
      @_leapController = leapController
      @_currentHandElements = {}
      @_currentFingerElements = {}

    start: =>
      @_leapController.on 'frame', @_onFrame

    _onFrame: (frame) =>
      @_recalculateHands frame.hands
      @_recalculateFingers frame.pointables

    _recalculateHands: (frameHands) =>
      idsUsed = {}
      for hand in frameHands
        idsUsed[hand.id] = true
        @_currentHandElements[hand.id] = @_currentHandElements[hand.id] || @_createElement(hand.id, 'hand')
        moveElement @_currentHandElements[hand.id], getImagePosition(hand.palmPosition), getHandRotation(hand)

      @_removeElementsFrom @_currentHandElements, (handId for handId, handElement of @_currentHandElements when !idsUsed[handId])

    _recalculateFingers: (frameFingers) =>
      idsUsed = {}
      for finger in frameFingers
        idsUsed[finger.id] = true
        @_currentFingerElements[finger.id] = @_currentFingerElements[finger.id] || @_createElement(finger.id, 'finger')
        moveElement @_currentFingerElements[finger.id], getImagePosition(finger.tipPosition), getFingerRotation(finger)

      @_removeElementsFrom @_currentFingerElements, (fingerId for fingerId, fingerElement of @_currentFingerElements when !idsUsed[fingerId])

    _createElement: (id, elementIdToClone) =>
      newElement = $('#' + elementIdToClone).clone(true).css('backgroundColor', getRandomColor())
      $('#scene').append newElement
      return newElement

    _removeElementsFrom: (allElements, elementIdsToRemove) =>
      for id in elementIdsToRemove
        allElements[id].remove()
        delete allElements[id]

    getRandomColor = ->
      "##{Math.floor(Math.random() * 16777215).toString(16)}"

    moveElement = (element, position, rotation) ->
      element.css 'webkitTransform', "translateX(#{position[0]}px) translateY(#{position[1]}px) translateZ(#{position[2]}px) rotateX(#{rotation[0]}deg) rotateY(#{rotation[1]}deg) rotateZ(#{rotation[2]}deg)"

    getImagePosition = (position) ->
      [ position[0] * 3, (position[2] * 3) - 200, (position[1] * 3) - 200 ]

    getFingerRotation = (finger) ->
      [ -finger.direction[1] * 90, 0, finger.direction[0] * 90 ]

    getHandRotation = (hand) ->
      [ hand.rotation[1][2] * 90, 0, 0 ]