define [
  'less',
  'jquery',
  'jquery-purl',
  'cs!coffee/input/socketClient',
  'cs!coffee/input/leapController',
  'cs!coffee/input/intelRealSenseFaceController'
  'cs!coffee/visualizer/leapVisualizer',
  'cs!coffee/visualizer/intelSocketVisualizer'
  'cs!coffee/visualizer/kinectSocketVisualizer'
  'cs!coffee/visualizer/intelRealSenseFaceVisualizer'
], (Less, $, urlParser,
    SocketClient, LeapController, IntelRealSenseFaceController,
    LeapVisualizer, IntelSocketVisualizer, KinectSocketVisualizer, IntelRealSenseFaceVisualizer) ->
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
    else if (filter == 'IntelRealSense')
      (visualizer = new IntelRealSenseFaceVisualizer(new IntelRealSenseFaceController())).start()
    else
      startSocketVisualizer(filter)

  startSocketVisualizer = (filter) ->
    hostName = 'localhost'
    port = 8100

    new IntelSocketVisualizer(new SocketClient(hostName, port), filter).start() if filter == 'IntelPerceptual'
    new KinectSocketVisualizer(new SocketClient(hostName, port), filter).start() if filter == 'Kinect2'

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