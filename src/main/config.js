require({
    paths: {
        'coffee-script': 'js/vendor/coffeescript',
        'cs': 'js/vendor/cs',

        'less': 'js/vendor/less',
        'jquery': 'js/vendor/jquery',
        'jquery-purl': 'js/vendor/jquery-purl',

        'leap': 'js/vendor/leap',
        'intel-realSense': 'js/vendor/intel/realsense-4.0',
        'intel-realSense-info': 'js/vendor/intel/realsenseinfo-4.0',
        'intel-realSense-promise': 'js/vendor/intel/promise-1.0.0.min'
    },
    shim: {
        'leap': { exports: 'Leap' },
        'intel-realSense': { exports: 'PXCMSenseManager_CreateInstance' },
        'intel-realSense-info': { exports: 'RealSenseInfo' }
    }
}, ['cs!coffee/entry/starter', 'cs!coffee/calibration/calibration']);