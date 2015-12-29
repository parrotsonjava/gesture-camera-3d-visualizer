define [
  'intel-realSense',
  'intel-realSense-autobahn'
], (realSense, autobahn) ->
  # Hack since Intel RealSense is not AMD ready
  window.autobahn = autobahn
  return intel.realsense
