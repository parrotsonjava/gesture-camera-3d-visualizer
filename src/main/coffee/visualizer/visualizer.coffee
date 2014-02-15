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

    _moveElement: (element, position, rotation) ->
      element.css 'webkitTransform', "translateX(#{position[0]}px) translateY(#{position[1]}px) translateZ(#{position[2]}px) rotateX(#{rotation[0]}deg) rotateY(#{rotation[1]}deg) rotateZ(#{rotation[2]}deg)"
