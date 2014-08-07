class FlipkeyProfile.Views.Profile extends Backbone.View
	model: new FlipkeyProfile.Models.Profile()
	
	className: "row profile"

	template: JST['profiles/index']
	
	render: -> 
		@$el.html(@template(@model.attributes))
		@

	enter_animation: -> 
		@$el.find(".progress-bar").each((ind, bar) ->
			$(bar).css("width",$(bar).attr("aria-valuenow")+"%")
		)
		@

