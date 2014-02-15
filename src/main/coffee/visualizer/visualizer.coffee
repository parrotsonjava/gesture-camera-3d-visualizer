define [], ->
  class Visualizer

    _createElement: (id, elementIdToClone) =>
      newElement = $('#' + elementIdToClone).clone(true).css('backgroundColor', @_getRandomColor())
      $('#scene').append newElement
      return newElement

    _removeElementsFrom: (allElements, elementIdsToRemove) =>
      for id in elementIdsToRemove
        allElements[id].remove()
        delete allElements[id]

    _getRandomColor: ->
      "##{Math.floor(Math.random() * 16777215).toString(16)}"

    _moveElement: (element, scale, position, rotation) ->
      transform = ""
      transform += "translateX(#{position[0]}px) translateY(#{position[1]}px) translateZ(#{position[2]}px)"
      transform += "scaleX(#{scale[0]}) scaleY(#{scale[1]}) scaleZ(#{scale[2]})"
      transform += "rotateX(#{rotation[0]}deg) rotateY(#{rotation[1]}deg) rotateZ(#{rotation[2]}deg)"

      element.css 'webkitTransform', transform
