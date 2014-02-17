define ['cs!coffee/visualizer/socketVisualizer', 'cs!coffee/geometry/point3', 'cs!coffee/geometry/vector3'], (SocketVisualizer, Point3, Vector3) ->
  class IntelSocketVisualizer extends SocketVisualizer

    constructor: (socketClient) ->
      super(socketClient, 'Kinect2')

    _moveLine: (lineId, line) =>
      @_moveElementNew @_currentLineElements[lineId], getScaleFactor(line), getImagePosition(line), getRotation(line)

    getScaleFactor = (line) ->
      startPosition = getPosition(line.start)
      endPosition = getPosition(line.end)

      scaleFactor = endPosition.subtract(startPosition).length() * 5

      [1, scaleFactor, 1]

    getImagePosition = (line) ->
      startPosition = getShownPosition(line.start).toArray()

    getShownPosition = (point) ->
      new Point3(point.x * 500, point.z * 300 - 700, point.y * 1000)

    getRotation = (line) ->
      startPosition = getShownPosition(line.start)
      endPosition = getShownPosition(line.end)
      directionVector = endPosition.subtract(startPosition).normalize()

      rotation = directionVector.projectionOnto(new Vector3(0, 0, 1)).angleToDeg(new Vector3(1, 0, 0), new Vector3(0, 0, 1))

      return [ 0, 0, 90 - rotation ]

    getRotationMatrix = (line) ->



      #upVector = new Vector3(0, 1, 0)

      #xAxis = upVector.cross(directionVector)
      #yAxis = directionVector.cross(xAxis)

      #return [ xAxis.x, xAxis.y, xAxis.z, 0
      #         yAxis.x, yAxis.y, yAxis.z, 0,
      #         directionVector.x, directionVector.y, directionVector.z, 0
      #         0, 0, 0, 1]

    getPosition = (point) ->
      return new Point3(point.x, point.z, point.y)

    _moveElementNew: (element, scale, position, rotation) ->
      #rotationText = rotationMatrix.reduce (text, newText) -> "#{text}, #{newText}"

      transform = ""
      transform += "translateX(#{position[0]}px) translateY(#{position[1]}px) translateZ(#{position[2]}px) "
      transform += "rotateX(#{rotation[0]}deg) rotateY(#{rotation[1]}deg) rotateZ(#{rotation[2]}deg)"
      transform += "scaleX(#{scale[0]}) scaleY(#{scale[1]}) scaleZ(#{scale[2]})"
      #transform += "matrix3d(#{rotationText})"

      element.css 'webkitTransform', transform