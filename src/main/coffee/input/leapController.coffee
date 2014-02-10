#noinspection CoffeeScriptUnusedLocalSymbols
define ['leap', 'cs!coffee/event/eventEmitter'], (Leap, EventEmitter) ->
  class LeapController extends EventEmitter

    constructor: ->
      super()
      @_initialize()

    _initialize: =>
      Leap.loop (frame) =>
        @_emit 'frame', frame