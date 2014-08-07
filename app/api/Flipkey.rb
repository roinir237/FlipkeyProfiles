require 'grape'
require 'PageMapper'
require 'uri'

module Flipkey
	class API < Grape::API
		version 'v1', using: :path
  	format :json

		desc "Save a vendors profile to the data base"
		params do
			requires :src, type: String, desc: "URL to vendor's flipkey profile"
		end
		post '/profile' do

			# mapper = PageMapper.new schema: schema, rules: rules 
			# mapper.data_from(params[:src])
		end

		params do
			requires :name, type: String, desc: "The vendor's name"
		end
		get '/profile' do
			Profile.where(name: params[:name]).first
		end
	end
end