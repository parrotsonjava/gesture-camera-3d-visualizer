define ['cs!coffee/visualizer/socketVisualizer', 'cs!coffee/geometry/point3', 'cs!coffee/geometry/vector3'], (SocketVisualizer, Point3, Vector3) ->
  class IntelSocketVisualizer extends SocketVisualizer

    constructor: (socketClient) ->
      super(socketClient, 'Kinect2')

    _moveLine: (lineId, line) =>
      @_moveElement @_currentLineElements[lineId], getScaleFactor(line), getImagePosition(line),getRotation(line)

    getScaleFactor = (line) ->
      startPosition = getPosition(line.start)
      endPosition = getPosition(line.end)

      scaleFactor = endPosition.subtract(startPosition).length() * 7

      [1, 1, 1]

    getImagePosition = (line) ->
      startPosition = getShownPosition(line.start).toArray()

    getShownPosition = (point) ->
      new Point3(point.x * 500, point.z * 100 - 300, point.y * 1000)

    getRotation = (line) ->
      startPosition = getPosition(line.start)
      endPosition = getPosition(line.end)
      direction = endPosition.subtract(startPosition).normalize()

      return [ -direction.y * 90, 0, direction.x * 90 ]

    getPosition = (point) ->
      return new Point3(point.x, point.y, point.z)