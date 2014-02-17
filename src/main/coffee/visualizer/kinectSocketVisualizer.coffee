define ['cs!coffee/visualizer/socketVisualizer', 'cs!coffee/geometry/point3', 'cs!coffee/geometry/vector3'], (SocketVisualizer, Point3, Vector3) ->
  class IntelSocketVisualizer extends SocketVisualizer
    factor = 30

    constructor: (socketClient) ->
      super(socketClient, 'Kinect2')

    _moveLine: (lineId, line) =>
      @_moveElementUsingRotationMatrix @_currentLineElements[lineId], getScaleFactor(line), getImagePosition(line), @_getRotationMatrix(line)

    getImagePosition = (line) ->
      startPosition = getShownPosition(line.start).toArray()

    getShownPosition = (point) ->
      new Point3(point.x * factor * 5, point.z * factor * 3 - factor * 7, point.y * factor * 10 + factor * 15)

    getScaleFactor = (line) ->
      startPosition = getShownPosition(line.start)
      endPosition = getShownPosition(line.end)

      scaleFactor = endPosition.subtract(startPosition).length() / 100

      [factor / 100, scaleFactor, factor / 100]