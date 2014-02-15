define ['cs!coffee/geometry/vector3'], (Vector3) ->
  class Point3
    constructor: (x, y, z) ->
      @x = x
      @y = y
      @z = z

    add: (vector) =>
      new Point3(@x + vector.x, @y + vector.y, @z + vector.z)

    subtract: (element) =>
      if element instanceof Vector3
        new Point3(@x - element.x, @y - element.y, @z - element.z)
      else
        new Vector3(@x - element.x, @y - element.y, @z - element.z)

    toArray: =>
      return [@x, @y, @z]