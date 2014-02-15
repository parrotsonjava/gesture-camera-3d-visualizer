define [
  'less',
  'jquery',
  'jquery-purl',
  'cs!coffee/input/socketClient',
  'cs!coffee/input/leapController',
  'cs!coffee/visualizer/leapVisualizer',
  'cs!coffee/visualizer/socketVisualizer'
], (Less, $, urlParser, SocketClient, LeapController, LeapVisualizer, SocketVisualizer) ->

  getFilter = () ->
    $.url().param('filter')

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
    new SocketVisualizer(new SocketClient(hostName, port), filter).start()

  waitForPurl = (callback) ->
    if !$? || !$.url?
      setTimeout((-> waitForPurl(callback)), 100)
    else
      callback()

  $ ->
    waitForPurl(start)