
showProgress = (p) ->
	$("#loading_bar").css({"width":p+"%"})

endLoading = ->
	$bar = $("#loading_bar")
	$bar.css({"width":"100%"})	
	setTimeout( ->
		$bar.css({"height":"0px"})
		setTimeout( ->
			$bar.css({"width":"0%"})
			setTimeout( ->
				$bar.css({"height":"4px"})
			,500)
		,500)
	, 500)

class FlipkeyProfile.Routers.Profiles extends Backbone.Router
	routes:
		"": "home"		

	home: ->
		profiles = new FlipkeyProfile.Collections.Profiles()

		$("#search_btn").click( -> 
			name = $("#profile_input").val()
			if name? and name != ""
				showProgress(40)
				profile = new FlipkeyProfile.Models.Profile()
				profile.fetch(
					type: 'GET',
					data: {name: name},
					error: =>
						endLoading()
						alert("Not Found!")
						
					success: =>
						showProgress(60)
						profiles.add(profile)
						profileView = new FlipkeyProfile.Views.Profile({model: profile})
						profileView.render()
						$("#profile_container").prepend(profileView.$el)
						endLoading()
						setTimeout( ->
							profileView.enter_animation()
						, 1)
				)
		)
