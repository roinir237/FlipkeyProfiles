require 'grape'
require 'PageMapper'

module Flipkey
	class API < Grape::API
		version 'v1', using: :path
  	format :json

  	helpers do 
  		def schema 
	  		{
		      :name => String,
		      :photo => String,
		      :details => {
		        :location => String,
		        :phone_number => String
		      },
		      :overall_rating => Integer, 
		      :rating_breakdown => [
		        {
		          :level => String,
		          :rate => Integer 
		        }
		      ],
		      :listings => [String]
		    }
  		end 

  		def rules 
	  		{
		      :name => "h1 text()",
		      :photo => "#photo-primary:first-child @src",
		      :details => {
		        :location => ':content("Office located in:")+ .text_data > text()',
		        :phone_number => ':content("Phone number:")+ .text_data > text()'
		      },
		      :overall_rating => "#fd_sidebar .general-rating-full @style", 
		      :rating_breakdown => [
		        {
		          :level => ".rate_line #rate-description > text()",
		          :rate => ".rate_line" 
		        }
		      ],
		      :listings => [".overview .pdp-link > text()"]
	    	}
  		end
  	end

		desc "This is a test vendor's profile"
		params do
			requires :src, type: String, desc: "URL to vendor's flipkey profile"
		end
		post '/profile' do
			mapper = PageMapper.new schema: schema, rules: rules 
			mapper.data_from(params[:src])
		end

		get '/profile' do
			{name:"Apartments Florence",photo:"http://i4.fkimg.com/img/photos/frontdesk_photos/484757/large_484757-FD-001-1395764281.jpg",details:{location:"Firenze, Italy",phone_number:"+39 55 247 9309"},overall_rating: 90,rating_breakdown:[{level:"Excellent",rate:53},{level:"Very Good",rate:36},{level:"Average",rate:9},{level:"Poor",rate:2},{level:"Terrible",rate:1}],listings:["San Zanobi","Pandolfini Street","Casa del Cacciatore - Tuscan Villa Apartment","Melegnano 3bd","Via delle Oche","Stufa","Maggio 34 1bd","Convent Roof","Via Macci (Laura)","Pinzochere (Mansarda)","Giordano 2bd","Pergola in Palazzo Leopardi","Casa Rosa - Bolgheri","Malenchini 1p","Piazza della Passera | Delightful Apartment with 2 Bedrooms in Charming Piazza","Signoria Venus","Alfani 3P 1bd","Alfani 3P 2bd","Vecchietti 2bd","Pandolfini Roof","Borgo Albizi 6","Lambertesca Terrace","Pinzochere 2bd","De' Neri","Suite Florence","Chiesa Blue","Ronco Giardino","Dante's 1 bedroom D","San Lorenzo 17","Ghibellina 69 3P","Pinzochere (2DX)","Indipendenza Senior","Malenchini 1bd 3p","Sant'Antonino","Vigna Nuova #1","Spada 2BD","Spada wood","Casa Gaia","Mentana 2bd","Le Pergole","Vasari 3b in Santa Croce","Brunelleschi | Lovely vacation rental with picturesque views","Menicucci","Micheli","Anguillara - Santa Croce's heart","Spada 1bd","Ognissanti","Barbadori Apartment","Pergola Studio","S. Agostino"]}
		end
	end
end