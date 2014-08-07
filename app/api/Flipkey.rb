require 'grape'
require 'PageMapper'
require 'uri'

module Flipkey
	class API < Grape::API
		version 'v1', using: :path
  	format :json

		params do
			requires :name, type: String, desc: "The vendor's name"
		end
		get '/profile' do
			p = Profile.where(name: params[:name]).first
			if p.nil? then error! 'Not found', 404 else p end
		end
	end
end