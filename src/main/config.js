require({
    paths: {
        'coffee-script': 'js/vendor/coffeescript',
        'cs': 'js/vendor/cs',

        'less': 'js/vendor/less',
        'jquery': 'js/vendor/jquery',
        'jquery-purl': 'js/vendor/jquery-purl',

        'leap': 'js/vendor/leap',
        'intel-realSense': 'js/vendor/intel/realsense-10.0',
        'intel-realSense-promise': 'js/vendor/intel/promise-6.1.0',
        'intel-realSense-autobahn': 'js/vendor/intel/autobahn'
    },
    shim: {
        'leap': { exports: 'Leap' },
        'intel-realSense': ['intel-realSense-promise', 'intel-realSense-autobahn']
    }
}, ['cs!coffee/entry/starter', 'cs!coffee/calibration/calibration']);