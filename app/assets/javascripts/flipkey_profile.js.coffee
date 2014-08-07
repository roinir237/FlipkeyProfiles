@FlipkeyProfile =
  Models: {}
  Collections: {}
  Views: {}
  Routers: {}
  	

$(document).ready ->
  @router = new FlipkeyProfile.Routers.Profiles()
  Backbone.history.start()
