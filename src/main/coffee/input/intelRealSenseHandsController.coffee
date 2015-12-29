#noinspection CoffeeScriptUnusedLocalSymbols
define [
  'cs!coffee/input/intelRealSenseController',
  'cs!coffee/input/intelRealSenseWrapper'
], (RealSenseController, realSense) ->
  class RealSenseHandsController extends RealSenseController
    constructor: ->
        super()
        @startController()

    startController: =>
      try
        @_checkPlatform('hand', @_initialize)
      catch e
        console.error e

    _initialize: =>
      handModule = null
      handConfiguration = null

      realSense.SenseManager.createInstance().then((sense) =>
        @_sense = sense
        window.onbeforeunload = @_releaseRealSense
        return realSense.hand.HandModule.activate(@_sense);
      ).then((hand) =>
        handModule = hand
        console.log 'RealSense initialization started'

        @_sense.onDeviceConnected = @_onConnect
        handModule.onFrameProcessed = @_onFrame
        return @_sense.init()
      ).then(=>
        handModule.createActiveConfiguration()
      ).then((handConfig) =>
        handConfiguration = handConfig
        handConfiguration.allAlerts = true
        handConfiguration.allGestures = true

        return handConfiguration.applyChanges()
      ).then(=>
        return handConfiguration.release();
      ).then(=>
        @_imageSize = @_sense.captureManager.queryImageSize(realSense.StreamType.STREAM_TYPE_DEPTH)
        return @_sense.streamFrames()
      ).then(=>
        @_emit 'initialized'
        console.log 'Frame streaming started'

      ).catch((e) =>
        @_emit 'error', {error: e}
      )

    _onConnect: =>
      console.log 'RealSense initialized'

    _onFrame: (sender, data) =>
      handsData = { numberOfHands: data.numberOfHands }

      if data.numberOfHands > 0
        handsData.hands = data.queryHandData(realSense.hand.AccessOrderType.ACCESS_ORDER_NEAR_TO_FAR)

      @_emit 'hands', handsData