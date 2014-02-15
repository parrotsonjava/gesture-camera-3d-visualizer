define ['cs!coffee/event/eventEmitter'], (EventEmitter) ->
  class SocketClient extends EventEmitter

    constructor: (hostName, port, reconnectTimeout) ->
      super()
      @_host = "ws://#{hostName}:#{port}"
      @_reconnectTimeout = reconnectTimeout

      @_reconnect()

    _reconnect: =>
      @_connection = new WebSocket(@_host)

      @_connection.onopen = @_connectionOpened
      @_connection.onmessage = @_messageArrived
      @_connection.onerror = @_errorOccured
      @_connection.onclose = @_connectionClosed

    _connectionOpened: =>
      @_emit 'connected'
      console.log 'Connection opened'

    _messageArrived: (eventArgs) =>
      #try
        data = JSON.parse(eventArgs.data)
        @_emit 'data', data
      #catch e
      #  @_errorOccured(new Error("Error while processing data '#{eventArgs.data}'"))

    _errorOccured: (eventArgs) =>
      @_emit 'error', eventArgs
      console.log 'There was an error', eventArgs

    _connectionClosed: (eventArgs) =>
      setTimeout @_reconnect, @_reconnectTimeout

      @_emit 'disconnected'
      console.log 'Connection closed'