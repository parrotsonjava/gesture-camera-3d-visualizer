#noinspection CoffeeScriptUnusedLocalSymbols
define ['cs!coffee/visualizer/socketVisualizer'], (SocketVisualizer) ->
  class IntelSocketVisualizer extends SocketVisualizer
    constructor: (socketClient) ->
      super(socketClient, 'IntelPerceptual')
      @calibration {"multX": 1500, "addX": 0, "multY": 1500, "addY": 450, "multZ": 500, "addZ": -50, "lineThickness": 10, "lineStretch": 4000}