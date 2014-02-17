define ['cs!coffee/visualizer/socketVisualizer', 'cs!coffee/geometry/point3', 'cs!coffee/geometry/vector3'], (SocketVisualizer, Point3, Vector3) ->
  class IntelSocketVisualizer extends SocketVisualizer

    constructor: (socketClient) ->
      super(socketClient, 'IntelPerceptual')

    _moveLine: (lineId, line) =>
      @_moveElementUsingRotationMatrix @_currentLineElements[lineId], getScaleFactor(line), getImagePosition(line), @_getRotationMatrixForLine(line)

    getScaleFactor = (line) ->
      startPosition = getPosition(line.start)
      endPosition = getPosition(line.end)
      scaleFactor = endPosition.subtract(startPosition).length() * 40

      return [1, scaleFactor, 1]

    getPosition = (point) ->
      return new Point3(point.x, point.z, point.y)

    _getRotationMatrixForLine: (line) ->
      startPosition = getPosition(line.start)
      endPosition = getPosition(line.end)
      directionVector = startPosition.subtract(endPosition).normalize()
      return @_getRotationMatrix(directionVector)

    getImagePosition = (line) ->
      startPosition = getImagePoint(line.start)
      endPosition = getImagePoint(line.end)
      startPosition.add(endPosition.subtract(startPosition).divide(2)).toArray()
      startPosition.toArray()

    getImagePoint = (worldPosition) ->
      new Point3(worldPosition.x * 4000 - 200, worldPosition.z * 1000 - 700, worldPosition.y * 7000 + 500)

    getRotation = (line) ->
      startPosition = getPosition(line.start)
      endPosition = getPosition(line.end)
      direction = endPosition.subtract(startPosition).normalize()

      return [ -direction.y * 90, 0, direction.x * 90 ]