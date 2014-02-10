define [], ->
  class EventEmitter
    constructor: ->
      @eventMap = {}

    on: (eventName, eventListener) =>
      if !@eventMap[eventName]?
        @eventMap[eventName] = []

      @eventMap[eventName].push eventListener

    _emit: (eventName, eventData) =>
      eventListeners = if @eventMap[eventName]? then this.eventMap[eventName] else []
      (eventListener(eventData) for eventListener in eventListeners)