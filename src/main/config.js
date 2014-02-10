require({
    paths: {
        'coffee-script': 'js/vendor/coffeescript',
        'cs': 'js/vendor/cs',
        'less': 'js/vendor/less',
        'jquery': 'js/vendor/jquery',

        'leap': 'js/vendor/leap'
    },
    shim: {
        'leap': { exports: 'Leap' }
    }
}, ['cs!coffee/entry/starter']);