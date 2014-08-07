FlipkeyProfiles
===============

This is an example web scraping application. The main webscraping class can be found in lib/PageMapper.rb. 

PageMapper.rb
--------------

PageMapper is a generic class that uses Mechanize to extract data from a web page and serve it in a hash. 
It excpects to receive two hases in its constructor one specifying the schema of the data and one the css rules to extract 
each data item from the page. 

```ruby

schema = "test"

pageMapper = PageMapper.new schema: schema, rules: rules 
```
