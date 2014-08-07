
##
# USAGE EXAMPLE 
#
# schema = {
#   :name => String,
#   :details => {
#     :location => String,
#     :phone_number => String
#   },
#   :overall_rating => Integer, 
#   :rating_breakdown => [
#     {
#       :level => String,
#       :rate => Integer 
#     }
#   ],
#   :listings => [String]
# }

# rules = {
#   :name => "h1 text()",
#   :details => {
#     :location => ':content("Office located in:")+ .text_data > text()',
#     :phone_number => ':content("Phone number:")+ .text_data > text()'
#   },
#   :overall_rating => "#fd_sidebar .general-rating-full @style", 
#   :rating_breakdown => [
#     {
#       :level => ".rate_line #rate-description > text()",
#       :rate => ".rate_line" 
#     }
#   ],
#   :listings => [".overview .pdp-link > text()"]
# }

# mapper = PageMapper.new schema: schema, rules: rules 
# pp mapper.data_from("http://www.flipkey.com/frontdesk/view/425/grand+strand+vacations+and+rentals/")
# 

require 'mechanize'
require 'diff/lcs'

class PageMapper
  attr_accessor :schema, :rules, :data, :features

  def initialize(params)
    @agent = Mechanize.new
    @schema = params[:schema]
    @rules = params[:rules]
    @data = params[:data] 
    @features = params[:features]
  end
  
  def data_from(url) 
    convert = lambda{|item,type| PageMapper.node_to_data(item,type)}
    @data = PageMapper.extract(@agent.get(url), @schema, @rules, convert: convert)
    @data
  end

  def features_from(url)
    page = @agent.get(url)
    body = page.body
    convert = lambda{|item,type| PageMapper.node_to_feature(body,item)}
    @features = PageMapper.extract(page, @schema, @rules, convert: convert)
    @features
  end

  def self.find(page,rule)
    rule = rule.gsub(/:content *\(\".*\"\)/) do |match| 
      content = match.scan(/(?<=:content\(\").*(?=\")/).first
      node = PageMapper.find_by_string(page,content)
      if node.nil? then return nil 
      else 
        node.parent.css_path 
      end
    end

    page.search(rule)
  end

  def self.node_to_feature(body, item)
    body = body.strip.gsub(/\s+/, " ")
    unique_node = item
    unique_node = unique_node.parent until body.scan(unique_node.to_s.strip.gsub(/\s+/, " ")).count == 1
    unique_node.to_s
  end

  def self.node_to_data(item,type)
    if type == String
      return item.to_s.strip
    elsif type == Integer
      return item.to_s.strip.scan(/[0-9]+/)[0].to_i
    else 
      return nil
    end 
  end

  def self.extract(page, schema, rules, p = {})
    i = p[:ind].nil? ? 0:p[:ind]
    convert = p[:convert].nil? ? lambda{|item,type| item} : p[:convert]

    if schema.respond_to? :each
      result = {}
      schema.each do |k,type|
        case type 
        when Class 
          item = PageMapper.find(page,rules[k])
          if !item.nil? and item.size > i then result[k] = convert.call(item[i], type) else result[k] = nil end
        when Hash then result[k] = extract(page, type, rules[k], p)
        when Array 
          ary = [extract(page,type[0],rules[k][0], ind: 0, convert: convert)]
          j = 0
          until ary.last.nil? or (ary.last.respond_to? :values and ary.last.values.all?(&:nil?))
            j += 1
            ary << extract(page,type[0],rules[k][0], ind: j, convert: convert)
          end
          ary.pop
          result[k] = ary
        end
      end
      result
    else
      item = PageMapper.find(page,rules)
      if !item.nil? and item.size > i then convert.call(item[i], schema) else nil end
    end
  end

  def self.find_by_string(page, str) 	
  	page.search('text()').each do |node| 
  		text = node.text.strip.gsub(/\s+/, " ")
  		if text === str then return node end
  	end
  	
  	nil
  end
end


   