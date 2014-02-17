define [], ->
  class Vector3
    constructor: (x, y, z) ->
      @x = x
      @y = y
      @z = z

    length: =>
      Math.sqrt(@x * @x +  @y * @y + @z * @z)

    multiply: (factor) =>
      new Vector3(@x * factor, @y * factor, @z * factor)

    divide: (divident) =>
      @multiply(1 / divident)

    normalize: =>
      @divide @length()

    dot: (otherVector) =>
      @x * otherVector.x + @y * otherVector.y + @z * otherVector.z

    cross: (otherVector) =>
      new Vector3(@y * otherVector.z - @z * otherVector.y, @z * otherVector.x - @x * otherVector.z, @x * otherVector.y - @y * otherVector.x)

    projectionOnto: (planeNormal) =>
      dotProduct = @dot planeNormal
      new Vector3(@x - dotProduct * planeNormal.x, @y - dotProduct * planeNormal.y, @z - dotProduct * planeNormal.z).normalize()

    angleToDeg: (otherVector, upVector) =>
      @angleTo(otherVector, upVector) * 180 / Math.PI;

    angleTo: (otherVector, upVector) =>
      normalVector = otherVector.cross upVector
      sign = if @dot(normalVector) > 0 then 1 else -1

      angle = Math.abs(Math.acos(bindTo(@dot(otherVector) / (@length() * otherVector.length()), -1, 1)))

      sign * angle

    toArray: =>
      return [@x, @y, @z]

    bindTo = (value, minValue, maxValue) ->
      if value < minValue then minValue else if value > maxValue then maxValue else value