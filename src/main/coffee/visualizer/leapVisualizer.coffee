define ['cs!coffee/visualizer/visualizer', 'cs!coffee/helper/randomHelper', 'jquery'], (Visualizer, randomHelper, $) ->
  class LeapVisualizer extends Visualizer

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
        @_currentHandElements[hand.id] = @_currentHandElements[hand.id] || @_createElement(randomHelper.randomText() + hand.id, 'hand')
        @_moveElement @_currentHandElements[hand.id], getScaleFactor(), getImagePosition(hand.palmPosition), getHandRotation(hand)

      @_removeElementsFrom @_currentHandElements, (handId for handId, handElement of @_currentHandElements when !idsUsed[handId])

    _recalculateFingers: (frameFingers) =>
      idsUsed = {}
      for finger in frameFingers
        idsUsed[finger.id] = true
        @_currentFingerElements[finger.id] = @_currentFingerElements[finger.id] || @_createElement(randomHelper.randomText() + finger.id, 'finger')
        @_moveElement @_currentFingerElements[finger.id], getScaleFactor(), getImagePosition(finger.tipPosition), getFingerRotation(finger)

      @_removeElementsFrom @_currentFingerElements, (fingerId for fingerId, fingerElement of @_currentFingerElements when !idsUsed[fingerId])

    getScaleFactor = ->
      [1, 1, 1]

    getImagePosition = (position) ->
      [ position[0] * 3, (position[2] * 3) - 200, (position[1] * 3) - 200 ]

    getFingerRotation = (finger) ->
      [ -finger.direction[1] * 90, 0, finger.direction[0] * 90 ]

    getHandRotation = (hand) ->
      [ hand.rotation[1][2] * 90, 0, 0 ]