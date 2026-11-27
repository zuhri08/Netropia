
  cordova.define('cordova/plugin_list', function(require, exports, module) {
    module.exports = [
      {
          "id": "cordova-plugin-applovin-max.AppLovinMAX",
          "file": "plugins/cordova-plugin-applovin-max/www/applovinmax.js",
          "pluginId": "cordova-plugin-applovin-max",
        "clobbers": [
          "applovin"
        ]
        }
    ];
    module.exports.metadata =
    // TOP OF METADATA
    {
      "cordova-plugin-applovin-max": "1.1.2"
    };
    // BOTTOM OF METADATA
    });
    