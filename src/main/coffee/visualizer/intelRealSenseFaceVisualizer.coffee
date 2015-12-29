define ['cs!coffee/visualizer/intelRealSenseVisualizer',
        'cs!coffee/geometry/point3',
        'cs!coffee/geometry/line'], (IntelRealSenseVisualizer, Point3, Line) ->
  class IntelRealSenseFaceVisualizer extends IntelRealSenseVisualizer

    CONFIDENCE_THRESHOLD = 90;

    constructor: (@_controller) ->
      super()
      @calibration {"multX": 1500, "addX": 0, "multY": 1500, "addY": 450, "multZ": 500, "addZ": -50, "lineThickness": 10, "lineStretch": 1}

    start: =>
      @_controller.on 'faces', @_onFaces

    _onFaces: (faceData) =>
      faces = if faceData.faces? then faceData.faces else []
      faceLines = @_concatenateLines (@_getLinesForFace(face) for face in faces)

      @_displayLines(faceLines)

    _getLinesForFace: (face) =>
      landmarksPoints = face?.landmarks?.points
      return if landmarksPoints? then @_getLines(face.userID, landmarksPoints) else []

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

    _isDetected: (point) =>
      point.confidenceWorld > CONFIDENCE_THRESHOLD

    _getPoint: (point) =>
      worldPoint = point?.world
      x = worldPoint?.x
      y = worldPoint?.y
      z = worldPoint?.z

      return if x? and y? and z? then new Point3(x, y, z) else null