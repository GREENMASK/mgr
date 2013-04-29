# Shelly Dependencies

This gem loads gems required on [Shelly Cloud](https://shellycloud.com).

When using Rails 3.x it detects if application is deployed on Shelly and sets recommended settings.

Current gem dependencies:

* [thin](http://code.macournoyer.com/thin/)
* [rake](http://rake.rubyforge.org/)

Changed settings for Rails 3.x applications ran on Shelly

* config.serve_static_assets = true
* config.assets.compile = true
