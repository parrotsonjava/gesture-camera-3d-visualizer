define ['cs!coffee/visualizer/visualizer',
        'cs!coffee/geometry/point3'
        'jquery'], (Visualizer, Point3, $) ->
  class LineVisualizer extends Visualizer
    constructor: ->
      super()
      @_calibrationValues = {}
      @_currentLineElements = {}

      @calibration {"multX": 100, "addX": 0, "multY": 100, "addY": 0, "multZ": 100, "addZ": 0, "lineThickness": 30, "lineStretch": 1}

    calibration: (calibrationValues) =>
      if !calibrationValues?
        return @_calibrationValues
      else
        @_calibrationValues = calibrationValues # $.merge calibrationValues, @_calibrationValues

    _removeAllLines: =>
      @_removeElementsFrom @_currentLineElements, (lineId for lineId, lineElement of @_currentLineElements)

    _displayLines: (lines) =>
      idsUsed = {}
      for line in lines
        idsUsed[line.id] = true
        @_currentLineElements[line.id] = @_currentLineElements[line.id] || @_createElement(line.id, 'line')
        @_moveLine(line)

      @_removeElementsFrom @_currentLineElements, (lineId for lineId, lineElement of @_currentLineElements when !idsUsed[lineId])

    _moveLine: (line) =>
      @_moveElementUsingRotationMatrix @_currentLineElements[line.id], @_getScaleFactor(line), @_getImagePosition(line), @_getRotationMatrixForLine(line)

    _getScaleFactor: (line) =>
      startPosition = @_getImagePoint(line.start)
      endPosition = @_getImagePoint(line.end)
      scaleFactor = (endPosition.subtract(startPosition).length() / 100) * @_calibrationValues.lineStretch

      [@_calibrationValues.lineThickness / 100, scaleFactor, @_calibrationValues.lineThickness / 100]

    _getImagePosition: (line) =>
      return @_getImagePoint(line.start).toArray()

    _getImagePoint: (worldPosition) =>
      new Point3(
        worldPosition.x * @_calibrationValues.multX + @_calibrationValues.addX,
        worldPosition.z * @_calibrationValues.multZ + @_calibrationValues.addZ,
        worldPosition.y * @_calibrationValues.multY + @_calibrationValues.addY)

    _getRotationMatrixForLine: (line) ->
      startPosition = @_getImagePoint(line.start)
      endPosition = @_getImagePoint(line.end)
      directionVector = startPosition.subtract(endPosition).normalize()
      return @_getRotationMatrix(directionVector)