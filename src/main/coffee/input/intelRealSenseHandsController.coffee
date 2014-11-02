#noinspection CoffeeScriptUnusedLocalSymbols
define ['intel-realSense', 'cs!coffee/input/intelRealSenseController'], (realSense, IntelRealSenseController) ->
  class IntelRealSenseHandsController extends IntelRealSenseController
    modes = {"2D": 0, "3D": 1}

    constructor: ->
      try
        super()
        @_initialize()
      catch e
        @_setStatus e.message

    _initialize: =>
      captureManager = null
      handConfiguration = null

      realSense().then((sense) =>
        @_sense = sense
        @_sense.EnableHand @_onHand
      ).then(=>
        console.log "RealSense initialization started"
        @_sense.Init(@_onConnect)
      ).then(=>
        @_sense.CreateHandConfiguration()
      ).then((handConfig) =>
        handConfiguration = handConfig
        handConfiguration.DisableAllAlerts()
      ).then(=>
        handConfiguration.DisableAllGestures()
      ).then(=>
        handConfiguration.ApplyChanges()
      ).then(=>
        @_sense.QueryCaptureManager()
      ).then((captureManager) =>
        captureManager.QueryImageSize(captureManager.STREAM_TYPE_DEPTH)
      ).then((image) =>
        @_imageSize = image.size
        @_sense.StreamFrames()
      ).then(=>
        console.log "Frame streaming started"
      ).catch((e) =>
        throw new Error(e)
      )

    _onConnect: =>
      console.log "RealSense initialized"

    _onHand: (mid, module, frame) =>
      @_emit 'frame', frame