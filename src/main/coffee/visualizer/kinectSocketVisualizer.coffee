define ['cs!coffee/visualizer/socketVisualizer', 'cs!coffee/geometry/point3', 'cs!coffee/geometry/vector3'], (SocketVisualizer, Point3, Vector3) ->
  class IntelSocketVisualizer extends SocketVisualizer
    factor = 30

    constructor: (socketClient) ->
      super(socketClient, 'Kinect2')

    _moveLine: (lineId, line) =>
      @_moveElementUsingRotationMatrix @_currentLineElements[lineId], getScaleFactor(line), getImagePosition(line), @_getRotationMatrixForLine(line)

    _getRotationMatrixForLine: (line) ->
      startPosition = getImagePoint(line.start)
      endPosition = getImagePoint(line.end)
      directionVector = startPosition.subtract(endPosition).normalize()
      return @_getRotationMatrix(directionVector)

    getImagePosition = (line) ->
      startPosition = getImagePoint(line.start).toArray()

    getImagePoint = (worldPosition) ->
      new Point3(worldPosition.x * factor * 5, worldPosition.z * factor * 3 - factor * 7, worldPosition.y * factor * 10 + factor * 15)

    getScaleFactor = (line) ->
      startPosition = getImagePoint(line.start)
      endPosition = getImagePoint(line.end)
      scaleFactor = endPosition.subtract(startPosition).length() / 100

      [factor / 100, scaleFactor, factor / 100]