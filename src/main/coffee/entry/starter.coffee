define [
  'less',
  'jquery',
  'jquery-purl',
  'cs!coffee/input/socketClient',
  'cs!coffee/input/leapController',
  'cs!coffee/input/intelRealSenseFaceController'
  'cs!coffee/input/intelRealSenseHandsController'
  'cs!coffee/visualizer/leapVisualizer',
  'cs!coffee/visualizer/intelSocketVisualizer'
  'cs!coffee/visualizer/kinectSocketVisualizer'
  'cs!coffee/visualizer/intelRealSenseFaceVisualizer'
  'cs!coffee/visualizer/intelRealSenseHandsVisualizer'
], (Less, $, urlParser,
    SocketClient, LeapController, IntelRealSenseFaceController, IntelRealSenseHandsController
    LeapVisualizer, IntelSocketVisualizer, KinectSocketVisualizer,
    IntelRealSenseFaceVisualizer, IntelRealSenseHandsVisualizer) ->
  visualizer = null

  getFilter = () ->
    urlParser().param('filter')
  shouldBeCalibrated = () ->
    urlParser().param('calibration')?

  start = ->
    startVisualizer(getFilter())
    if (shouldBeCalibrated())
      window.itemToCalibrate = visualizer

  startVisualizer = (filter) ->
    if (filter == 'Leap')
      new LeapVisualizer(new LeapController()).start()
    else if (/^IntelRealSense/.test filter)
      startIntelRealSenseVisualizer(filter)
    else
      startSocketVisualizer(filter)

  startSocketVisualizer = (filter) ->
    hostName = 'localhost'
    port = 8100

    new IntelSocketVisualizer(new SocketClient(hostName, port), filter).start() if filter == 'IntelPerceptual'
    new KinectSocketVisualizer(new SocketClient(hostName, port), filter).start() if filter == 'Kinect2'

  startIntelRealSenseVisualizer = (filter) ->
    visualizer = new IntelRealSenseFaceVisualizer(new IntelRealSenseFaceController()) if filter == 'IntelRealSense-Face'
    visualizer = new IntelRealSenseHandsVisualizer(new IntelRealSenseHandsController())if filter == 'IntelRealSense-Hands'

    visualizer.start()

  zoomWindow = ->
    setZoomLevel()
    $(window).resize setZoomLevel

  setZoomLevel = ->
    $('body').css('zoom', window.innerWidth / 1024)

  waitForPurl = (callback) ->
    if !$? || !$.url?
      setTimeout((-> waitForPurl(callback)), 100)
    else
      callback()

  $ ->
    zoomWindow()
    start()
#waitForPurl(start)