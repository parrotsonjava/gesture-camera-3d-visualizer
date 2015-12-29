#noinspection CoffeeScriptUnusedLocalSymbols
define [
  'cs!coffee/input/intelRealSenseController',
  'cs!coffee/input/intelRealSenseWrapper'
], (RealSenseController, realSense) ->
  class RealSenseFaceController extends RealSenseController

    DEFAULT_NUMBER_OF_TRACKED_FACES = 1
    TRACKING_MODE_3D = 1

    constructor: (options) ->
      super()
      @_maxTrackedFaces = if options?.maxTrackedFaces? then options.maxTrackedFaces else DEFAULT_NUMBER_OF_TRACKED_FACES
      @startController()

    startController: =>
      try
        @_checkPlatform('face3d', @_initialize)
      catch e
        console.error e

    _initialize: =>
      faceModule = null
      faceConfiguration = null

      realSense.SenseManager.createInstance().then((sense) =>
        @_sense = sense
        window.onbeforeunload = @_releaseRealSense
        return realSense.face.FaceModule.activate(@_sense)
      ).then((module) =>
        faceModule = module
        return faceModule.createActiveConfiguration()
      ).then((faceConfig) =>
        faceConfiguration = faceConfig

        faceConfiguration.detection.isEnabled = true
        faceConfiguration.detection.maxTrackedFaces = @_maxTrackedFaces
        faceConfiguration.trackingMode = TRACKING_MODE_3D

        return faceConfiguration.applyChanges()
      ).then(=>
        console.log 'RealSense initialization started'
        @_sense.onDeviceConnected = @_onConnect
        @_sense.onStatusChanged = @_onStatus
        faceModule.onFrameProcessed = @_onFrame


        return @_sense.init()
      ).then(=>
        faceConfiguration.landmarks.isEnabled = true
        faceConfiguration.landmarks.maxTrackedFaces = @_maxTrackedFaces
        faceConfiguration.pose.isEnabled = false
        faceConfiguration.expressions.properties.isEnabled = false

        return faceConfiguration.applyChanges()
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

    _onStatus: (sts) =>
      if sts < 0
        console.log('Module error with status code: ' + sts);
        clear();

    _onFrame: (sender, data) =>
      @_emit 'faces', data