define ['cs!coffee/visualizer/socketVisualizer', 'cs!coffee/geometry/point3', 'cs!coffee/geometry/vector3'], (SocketVisualizer, Point3, Vector3) ->
  class IntelSocketVisualizer extends SocketVisualizer

    constructor: (socketClient) ->
      super(socketClient, 'IntelPerceptual')

    _moveLine: (lineId, line) =>
      @_moveElementUsingRotationAngles @_currentLineElements[lineId], getScaleFactor(line), getImagePosition(line),getRotation(line)

    getScaleFactor = (line) ->
      startPosition = getPosition(line.start)
      endPosition = getPosition(line.end)

      scaleFactor = endPosition.subtract(startPosition).length() * 40

      [1, scaleFactor, 1]

    getImagePosition = (line) ->
      startPosition = getShownPosition(line.start)
      endPosition = getShownPosition(line.end)
      startPosition.add(endPosition.subtract(startPosition).divide(2)).toArray()
      startPosition.toArray()

    getShownPosition = (point) ->
      new Point3(point.x * 4000 - 200, point.z * 1000 - 700, point.y * 7000 + 500)

    getRotation = (line) ->
      startPosition = getPosition(line.start)
      endPosition = getPosition(line.end)
      direction = endPosition.subtract(startPosition).normalize()

      return [ -direction.y * 90, 0, direction.x * 90 ]

    getPosition = (point) ->
      return new Point3(point.x, point.y, point.z)