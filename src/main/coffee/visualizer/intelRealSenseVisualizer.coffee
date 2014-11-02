define ['cs!coffee/visualizer/lineVisualizer',
        'cs!coffee/geometry/point3',
        'cs!coffee/geometry/line'], (LineVisualizer, Point3, Line) ->
  class IntelRealSenseVisualizer extends LineVisualizer
    constructor: ->
      super()

    _getLineSegment: (userId, bodyPart, landmarksPoints, range, closed) =>
      detectedPoints = (landmarksPoints[i] for i in range).filter((point) => @_isDetected(point))
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

    _concatenateLines: (lines) =>
      [].concat lines...