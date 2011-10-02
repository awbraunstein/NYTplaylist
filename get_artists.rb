require 'rubygems'
require 'net/http'
require 'json'


class GetArtists
  @get_request = "http://api.nytimes.com/svc/news/v3/content/all/arts/24.json?api-key=11f1caeab6d826d5fc68adfabc901d1a:3:64948349"
  
  def GetArtists.make_json_request()
    Net::HTTP.get_response URI.parse(@get_request)
  end
  
  #give data.body from make_json_request
  def GetArtists.create_list(json_data)
    artists = []
    json_obj = JSON.parse(json_data)
    
    json_obj["results"].each do |result|

      #checks that article has correct data
      unless result["des_facet"] == nil.to_s || (result["org_facet"] == nil.to_s && result["per_facet"] == nil.to_s)
        is_music=false
        result["des_facet"].each do |des|
          
          #makes sure it is music
          if des.include?("Music")
            is_music = true
          end
        end

        #adds an artist if present in article
        if is_music
          artists << result["org_facet"][0] unless result["org_facet"].to_s.empty?
          
          #only add person if org has nothing
          if result["org_facet"].to_s.empty?
            artists << result["per_facet"][0] unless result["per_facet"].to_s.empty?
          end
        
        end

      end
    end
    artists
  end
  
end



data = GetArtists.make_json_request
artists = GetArtists.create_list(data.body)

File.open("artists.txt", 'w') {|f| 
  artists.each do |artist|
    f.write(artist.to_s + "\n")
  end
}