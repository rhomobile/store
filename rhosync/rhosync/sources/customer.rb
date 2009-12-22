require 'json'
require 'open-uri'

class Customer < SourceAdapter
  def initialize(source,credential)
    super(source,credential)
  end
 
  def login
  end
 
  def query(conditions=nil,limit=nil,offset=nil)
    # backend for this source adapter implements condtions
    
    logger = Logger.new('log/store.log', File::WRONLY | File::APPEND)
    logger.debug "query called with conditions=#{conditions} limit=#{limit} and offset=#{offset}"
    
    parsed=nil
    conditions=nil if conditions and conditions.size<1
    url="http://rhostore.heroku.com/customers.json"
    url=url+"?#{hashtourl(conditions)}" if conditions
    logger.debug "Searching with #{url}"
    open(url) do |f|
      parsed=JSON.parse(f.read)
    end
    
    logger.debug parsed.inspect.to_s
    @result={}
    
    parsed.each { |item|@result[item["customer"]["id"].to_s]=item["customer"] } if parsed
    logger.debug @result.inspect.to_s
    
    @result
  end
  
  def hashtourl(conditions)
    url=""
    first=true
    conditions.keys.each do |condition|
      if condition.length > 0
        url=url+"&" if not first
        url=url+"conditions[#{condition}]=#{conditions[condition]}"
        first=nil
      end
    end
    url
  end

=begin REENABLE THIS IF YOU WANT TO DO PAGED QUERY
  def page(num)
    letter='A'
    num.times {letter=letter.next}
    if letter.size>1
      nil
    else
      p "Page #{letter}"
      parsed=nil
      open("http://rhostore.heroku.com/customers.json?firstletter=#{letter}") do |f|
        parsed=JSON.parse(f.read)
      end
      @result={}
      parsed.each { |item|@result[item["customer"]["id"].to_s]=item["customer"] } if parsed
      p "Result size: #{@result.size.to_s}"
      @result
    end
  end
=end 
 
  def sync
    # TODO: write code here that converts the data you got back from query into an @result object
    # where @result is an array of hashes,  each array item representing an object
    super # this creates object value triples from an @result variable that contains an array of hashes
  end
 
  def create(name_value_list)
    attrvals={}
    name_value_list.each { |nv| attrvals["customer["+nv["name"]+"]"]=nv["value"]} # convert name-value list to hash
    res = Net::HTTP.post_form(URI.parse("http://rhostore.heroku.com/customers"),attrvals)

    # after create we are redirected to the new record. We need to get the id of that record and return it as part of create
    # so rhosync can establish connection from its temporary object on the client to this newly created object on the server
    case res
      when Net::HTTPRedirection 
        parsed = {}
        open(res['location']+".json") do |f|
          parsed=JSON.parse(f.read)
        end
      return parsed["customer"]["id"] rescue nil
    end
  end
 
  def update(name_value_list) 
    obj_id = name_value_list.find { |item| item['name'] == 'id' }
    name_value_list.delete(obj_id)

    params={}     
    name_value_list.each {|nv|params[nv["name"]]=nv["value"]}

    uri = URI.parse('http://rhostore.heroku.com')
    Net::HTTP.start(uri.host) do |http|
      request = Net::HTTP::Put.new(uri.path + "/customers/#{obj_id['value']}.xml", {'Content-type' => 'application/xml'})
      request.body = xml_template(params)
      response = http.request(request)
    end
  end
 
  def delete(name_value_list)
    attrvals={}     
    name_value_list.each {|nv|attrvals["product["+nv["name"]+"]"]=nv["value"]}
    http=Net::HTTP.new(‘rhostore.heroku.com’,80)
    path="/customers/#{attrvals['id']}"
    resp=http.delete(path)
  end
 
  def logoff
    #TODO: write some code here if applicable
    # no need to do a raise here
  end
  
  protected
  # API is expecting us to send XML content
  def xml_template(params)
    xml_str = "<customer>"
    params.each do |key,value|
      xml_str += "<#{key}>#{value}</#{key}>"
     end
     xml_str += "</customer>"
     xml_str
   end
end