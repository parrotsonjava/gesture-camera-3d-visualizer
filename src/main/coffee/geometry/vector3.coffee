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

    toArray: =>
      return [@x, @y, @z]