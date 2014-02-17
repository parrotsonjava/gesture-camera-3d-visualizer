define ['cs!coffee/visualizer/socketVisualizer', 'cs!coffee/geometry/point3', 'cs!coffee/geometry/vector3'], (SocketVisualizer, Point3, Vector3) ->
  class IntelSocketVisualizer extends SocketVisualizer

    factor = 100

    constructor: (socketClient) ->
      super(socketClient, 'Kinect2')

    _moveLine: (lineId, line) =>
      @_moveElementNew @_currentLineElements[lineId], getScaleFactor(line), getImagePosition(line), getRotationMatrix(line)

    getScaleFactor = (line) ->
      startPosition = getShownPosition(line.start)
      endPosition = getShownPosition(line.end)

      scaleFactor = endPosition.subtract(startPosition).length() / factor

      [1, scaleFactor, 1]

    getImagePosition = (line) ->
      startPosition = getShownPosition(line.start).toArray()

    getShownPosition = (point) ->
      new Point3(point.x * factor * 5, point.z * factor * 3 - factor * 7, point.y * factor * 10 + factor * 5)

    getRotationMatrix = (line) ->
      startPosition = getShownPosition(line.start)
      endPosition = getShownPosition(line.end)
      directionVector = startPosition.subtract(endPosition).normalize()
      upVector = new Vector3(0, 0, 1)

      xAxis = upVector.cross(directionVector).normalize()
      yAxis = directionVector.cross(xAxis).normalize()

      return [ xAxis.x, xAxis.y, xAxis.z, 0
               directionVector.x, directionVector.y, directionVector.z, 0,
               yAxis.x, yAxis.y, yAxis.z, 0,
               0, 0, 0, 1]

    getPosition = (point) ->
      return new Point3(point.x, point.z, point.y)

    _moveElementNew: (element, scale, position, rotationMatrix) ->
      rotationText = rotationMatrix.reduce (text, newText) -> "#{text}, #{newText}"

      transform = ""
      transform += "translateX(#{position[0]}px) translateY(#{position[1]}px) translateZ(#{position[2]}px) "
      transform += "matrix3d(#{rotationText})"
      transform += "scaleX(#{scale[0]}) scaleY(#{scale[1]}) scaleZ(#{scale[2]})"

      element.css 'webkitTransform', transform