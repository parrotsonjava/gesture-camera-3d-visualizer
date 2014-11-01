define ['cs!coffee/visualizer/lineVisualizer',
        'cs!coffee/geometry/point3',
        'cs!coffee/geometry/line'], (LineVisualizer, Point3, Line) ->
  class IntelRealSenseFaceVisualizer extends LineVisualizer

    CONFIDENCE_THRESHOLD = 90;

    constructor: (@_controller) ->
      super()
      @calibration {"multX": 1500, "addX": 0, "multY": 1500, "addY": 450, "multZ": 500, "addZ": -50, "lineThickness": 10, "lineStretch": 1}

    start: =>
      @_controller.on 'frame', @_onFrame

    _onFrame: (frame) =>
      [@_displayFace(face) if face?.landmarks?.landmarksPoints for face in frame.faces] if frame.faces and frame.faces.length

    _displayFace: (face) =>
      landmarksPoints = face?.landmarks?.landmarksPoints
      return if !landmarksPoints

      @_displayLines(@_getLines(face.userID, landmarksPoints))

    _getLines: (userId, landmarksPoints) =>
      lines = []
      lines.push @_getLineSegment(userId, "head", landmarksPoints, [53..69], false)...

      lines.push @_getLineSegment(userId, "outerLips", landmarksPoints, [33..44], true)...
      lines.push @_getLineSegment(userId, "innerLips", landmarksPoints, [45..52], true)...

      lines.push @_getLineSegment(userId, "noseVertical", landmarksPoints, [26, 27, 28, 29, 31])...
      lines.push @_getLineSegment(userId, "noseHorizontal", landmarksPoints, [30..32], false)...

      lines.push @_getLineSegment(userId, "leftEye", landmarksPoints, [10..17], true)...
      lines.push @_getLineSegment(userId, "rightEye", landmarksPoints, [18..25], true)...
      lines.push @_getLineSegment(userId, "leftEyeBrow", landmarksPoints, [0..4], false)...
      lines.push @_getLineSegment(userId, "rightEyeBrow", landmarksPoints, [5..9], false)...

      return lines.filter (line) -> line.start? and line.end?

    _getLineSegment: (userId, bodyPart, landmarksPoints, range, closed) =>
      detectedPoints = (landmarksPoints[i] for i in range).filter((point) -> point.confidenceWorld > CONFIDENCE_THRESHOLD)
      detectedPositions = (@_getPoint(point) for point in detectedPoints).filter((point) -> point?)

      lineIndex = 0;
      lineSegment = (new Line(@_getLineId(userId, bodyPart, lineIndex++),
        detectedPositions[i],
        detectedPositions[(i + 1) % detectedPositions.length]) for i in [0...detectedPositions.length - 1])

      lineSegment.push new Line(@_getLineId(userId, bodyPart, lineIndex++),
        detectedPositions[detectedPositions.length - 1], detectedPositions[0]) if closed

      return lineSegment

    _getLineId: (userId, bodyPart, lineIndex) =>
      return "#{userId}_#{bodyPart}_#{lineIndex}"

    _getPoint: (point) =>
      worldPoint = point?.world
      x = worldPoint?.x
      y = worldPoint?.y
      z = worldPoint?.z

      return if x? and y? and z? then new Point3(x, y, z) else null