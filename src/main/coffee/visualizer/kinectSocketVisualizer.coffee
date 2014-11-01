#noinspection CoffeeScriptUnusedLocalSymbols
define ['cs!coffee/visualizer/socketVisualizer'], (SocketVisualizer) ->
  class KinectSocketVisualizer extends SocketVisualizer
    constructor: (socketClient) ->
      super(socketClient, 'Kinect2')
      @calibration {"multX": 150, "addX": 0, "multY": 300, "addY": 450, "multZ": 90, "addZ": -210, "lineThickness": 30}