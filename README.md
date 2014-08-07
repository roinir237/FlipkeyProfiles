FlipkeyProfiles
===============

This is an example web scraping application. The main webscraping class can be found in lib/PageMapper.rb. The webapp is hosted on heroku http://stark-bastion-1451.herokuapp.com/ 

About the webapp
----------------
The app uses Backbonejs to draw the profile widgets. The profiles are stored in a mongodb and the communication between the front and beckend is done via a Grape API. The database was populated on creating using a rake job that scraped profiles from flipkey. 

The available vendor names can be found in names.txt (some examples: "Summit 54 Vacation Property Management LLC", "Jackson Mountain Homes", "American Patriot Getaways")

About PageMapper.rb
--------------------

PageMapper is a generic class that uses Mechanize to extract data from a web page and serve it in a hash. 
It excpects to receive two hases in its constructor one specifying the schema of the data and one the css rules to extract 
each data item from the page. 

```ruby
schema = {
  :name => String,
  :age => Integer,
  :pets => [{
    :name => String,
    :species => String
  }]
}

rules = {
  :name => "#name",
  :age => ".....",
  :pets => [{
    :name => "....",
    :species => "...,"
  }]
}

pageMapper = PageMapper.new schema: schema, rules: rules 
```
The schema and the rules hashes must follow the same structure. In the future they could be combined to a single "data model" object. The schema currently only supports Integer and String as fundemental types. The schema, as shown in the example support nested hashs and arrays of any type.

Once the object is defined we can pass it a url and it will try to extract the data from the webpage. Pieces of information it doesn't find are set to nil.

```ruby
data = pageMapper.data_from(url)
```

data is a hash of the structure defined in the schema. 

I extended the support of Mechanize to include the :content("...") css rules for finding a node by applying a preprocessing step before applying the rule to the page. 
