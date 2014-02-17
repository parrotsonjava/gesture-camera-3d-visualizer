define ['cs!coffee/helper/colorHelper'], (colorHelper) ->
  class Visualizer

    _createElement: (id, elementIdToClone) =>
      newElement = $('#' + elementIdToClone).clone(true).css('backgroundColor', colorHelper.getColorFor(id))
      $('#scene').append newElement
      return newElement

    _removeElementsFrom: (allElements, elementIdsToRemove) =>
      for id in elementIdsToRemove
        allElements[id].remove()
        delete allElements[id]

    _moveElementUsingRotationAngles: (element, scale, position, rotation) ->
      transform = ""
      transform += "translateX(#{position[0]}px) translateY(#{position[1]}px) translateZ(#{position[2]}px)"
      transform += "rotateX(#{rotation[0]}deg) rotateY(#{rotation[1]}deg) rotateZ(#{rotation[2]}deg)"
      transform += "scaleX(#{scale[0]}) scaleY(#{scale[1]}) scaleZ(#{scale[2]})"

      element.css 'webkitTransform', transform

    _moveElementUsingRotationMatrix: (element, scale, position, rotationMatrix) ->
      rotationText = rotationMatrix.reduce (text, newText) -> "#{text}, #{newText}"

      transform = ""
      transform += "translateX(#{position[0]}px) translateY(#{position[1]}px) translateZ(#{position[2]}px) "
      transform += "matrix3d(#{rotationText})"
      transform += "scaleX(#{scale[0]}) scaleY(#{scale[1]}) scaleZ(#{scale[2]})"

      element.css 'webkitTransform', transform
