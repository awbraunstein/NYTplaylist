require 'rubygems'
require 'net/http'
require 'json'


class GetArtists
  @get_request = "http://api.nytimes.com/svc/news/v3/content/all/arts/24.json?api-key=11f1caeab6d826d5fc68adfabc901d1a:3:64948349"
  
  def GetArtists.make_json_request()
    Net::HTTP.get_print URI.parse(@get_request)
  end
  
  
  
end
g = GetArtists.make_json_request