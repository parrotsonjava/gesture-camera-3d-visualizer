define [
  'less',
  'jquery',
  'jquery-purl',
  'cs!coffee/input/socketClient',
  'cs!coffee/input/leapController',
  'cs!coffee/visualizer/leapVisualizer',
  'cs!coffee/visualizer/intelSocketVisualizer'
  'cs!coffee/visualizer/kinectSocketVisualizer'
], (Less, $, urlParser, SocketClient, LeapController, LeapVisualizer, IntelSocketVisualizer, KinectSocketVisualizer) ->

  getFilter = () ->
    urlParser().param('filter')

  start = ->
    filter = getFilter()
    leapController = new LeapController()

    if (filter == 'Leap')
      startLeapVisualizer(leapController)
    else
      startSocketVisualizer(filter)

  startLeapVisualizer = (leapController) ->
    new LeapVisualizer(leapController).start()

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