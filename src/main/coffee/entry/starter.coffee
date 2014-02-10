define ['jquery', 'less', 'cs!coffee/visualizer/visualizer', 'cs!coffee/input/leapController' ], ($, Less, Visualizer, LeapController) ->
  $ ->
    new Visualizer(new LeapController()).start()