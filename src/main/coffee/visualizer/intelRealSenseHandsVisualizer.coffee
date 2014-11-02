define ['cs!coffee/visualizer/intelRealSenseVisualizer',
        'cs!coffee/geometry/point3',
        'cs!coffee/geometry/line'], (IntelRealSenseVisualizer, Point3, Line) ->
  class IntelRealSenseHandsVisualizer extends IntelRealSenseVisualizer

    CONFIDENCE_THRESHOLD = 90

    constructor: (@_controller) ->
      super()
      @calibration {"multX": 1500, "addX": 0, "multY": 1500, "addY": 450, "multZ": 500, "addZ": -50, "lineThickness": 20, "lineStretch": 1}

    start: =>
      @_controller.on 'frame', @_onFrame

    _onFrame: (frame) =>
      handIndex = 0
      hands = if frame.hands? then frame.hands else []

      handLines = @_concatenateLines (@_getLinesForHand(hand, handIndex++) for hand in hands)
      @_displayLines(handLines)

    _getLinesForHand: (hand, handIndex) =>
      joints = hand?.trackedJoint
      return if joints then @_getLines("#{hand.userId}-#{handIndex}", joints) else []

    _getLines: (userHandIndex, trackedJoints) =>
      lines = []
      lines.push @_getLineSegment(userHandIndex, "center", trackedJoints, [0, 1], false)...

      lines.push @_getLineSegment(userHandIndex, "thumb", trackedJoints, [0, [2..5]...], false)...
      lines.push @_getLineSegment(userHandIndex, "index", trackedJoints, [0, [6..9]...], false)...
      lines.push @_getLineSegment(userHandIndex, "middle", trackedJoints, [0, [10..13]...], false)...
      lines.push @_getLineSegment(userHandIndex, "ring", trackedJoints, [0, [14..17]...], false)...
      lines.push @_getLineSegment(userHandIndex, "pinky", trackedJoints, [0, [18..21]...], false)...

      return lines.filter (line) -> line.start? and line.end?

    _isDetected: (point) =>
      point? and point.confidence? and point.confidence > CONFIDENCE_THRESHOLD

    _getPoint: (point) =>
      worldPoint = point?.positionWorld
      x = worldPoint?.x
      y = worldPoint?.y
      z = worldPoint?.z

      return if x? and y? and z? then new Point3(x, y, z) else null