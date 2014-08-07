class Profile
  include Mongoid::Document
  field :name, type: String
  field :photo, type: String
  field :details, type: Hash
  field :overall_rating, type: Integer
  field :rating_breakdown, type: Array
  field :listings, type: Array
end
