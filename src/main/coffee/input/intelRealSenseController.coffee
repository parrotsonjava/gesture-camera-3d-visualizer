#noinspection CoffeeScriptUnusedLocalSymbols
define [
  'cs!coffee/event/eventEmitter',
  'cs!coffee/input/intelRealSenseWrapper'
], (EventEmitter, realSense) ->
  class RealSenseController extends EventEmitter

    constructor: ->
      super()

    _checkPlatform: (desiredFeature, successCallback) =>
      console.log 'Checking platform for RealSense usage'
      realSense.SenseManager.detectPlatform([desiredFeature], ['front']).then((info) =>
        if info.nextStep == 'ready'
          console.log 'The SDK is ready to be used'
          successCallback()
        else if info.nextStep == 'unsupported'
          @_emit 'error', {error: new Error('This platform is not supported')}
        else if info.nextStep == 'browser'
          @_emit 'error', {error: new Error('The browser is not supported')}
        else if info.nextStep == 'driver'
          @_emit 'error', {error: new Error('The RealSense driver is missing')}
        else if info.nextStep == 'runtime'
          @_emit 'error', {error: new Error('The RealSense web runtime is missing')}
      ).catch (error) =>
        @_emit 'error', {error: new Error("Error while detecting the platform #{error.message}")}

    _releaseRealSense: =>
      if @_sense?
        @_sense.release().then =>
          console.log 'released'
          @_sense = undefined