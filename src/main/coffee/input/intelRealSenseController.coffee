#noinspection CoffeeScriptUnusedLocalSymbols
define [
  'intel-realSense-promise',
  'intel-realSense',
  'intel-realSense-info',
  'cs!coffee/event/eventEmitter'
], (IntelRealSensePromise, realSense, realSenseInfo, EventEmitter) ->
  class IntelRealSenseController extends EventEmitter
    constructor: ->
      super()
      @_checkPlatform()

    _checkPlatform: =>
      realSenseInfo ['face3d'], (info) =>
        if info.IsReady
          console.log "The SDK is ready to be used"
        else if !info.IsPlatformSupported
          throw new Error("This platform is not supported")
        else if !info.IsBrowserSupported
          throw new Error("This browser is not supported")
        else
          requiredUpdates = [update.href for update in info.Updates].join(", ")
          throw new Error("The following updates need to be installed: #{requiredUpdates}")

    _setStatus: (message) =>
      console.log message