#noinspection CoffeeScriptUnusedLocalSymbols
define ['intel-realSense', 'cs!coffee/input/intelRealSenseController'], (realSense, IntelRealSenseController) ->
  class IntelRealSenseFaceController extends IntelRealSenseController
    modes = {"2D": 0, "3D": 1}

    constructor: ->
      try
        super()
        @_initialize()
      catch e
        @_setStatus e.message

    _initialize: =>
      captureManager = null
      faceConfiguration = null

      realSense().then((sense) =>
        @_sense = sense
        @_sense.EnableFace @_onFace
      ).then((faceModule) =>
        faceModule.CreateActiveConfiguration()
      ).then((faceConfig) =>
        faceConfiguration = faceConfig
        @_setFaceConfiguration(faceConfiguration)
      ).then(=>
        faceConfiguration.ApplyChanges()
      ).then(=>
        console.log "RealSense initialization started"
        @_sense.Init()
      ).then(=>
        @_sense.QueryCaptureManager()
      ).then((captureManager) =>
        captureManager.QueryImageSize(captureManager.STREAM_TYPE_COLOR)
      ).then((image) =>
        @_imageSize = image.size
        @_sense.StreamFrames()
      ).then(=>
        console.log "Frame streaming started"
      ).catch((e) =>
        throw new Error(e)
      )

    _setFaceConfiguration: (faceConfiguration) =>
      faceConfiguration.configs.detection.isEnabled = true
      faceConfiguration.configs.landmarks.isEnabled = true
      faceConfiguration.configs.pose.isEnabled = false
      faceConfiguration.configs.expressionProperties.isEnabled = false
      return faceConfiguration.SetTrackingMode(modes["3D"])

    _onFace: (mid, module, frame) =>
      @_emit 'frame', frame