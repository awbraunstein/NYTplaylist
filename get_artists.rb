require 'rubygems'
require 'net/http'
require 'json'


class GetArtists
  @nytimes_get_request = "http://api.nytimes.com/svc/news/v3/content/all/arts/24.json?api-key=11f1caeab6d826d5fc68adfabc901d1a:3:64948349"
  # @spotify_artist_get_request = "http://ws.spotify.com/search/1/artist.json?q="
  @spotify_get_request = "http://ws.spotify.com/search/1/track.json?q="
    
  def GetArtists.make_json_request()
    Net::HTTP.get_response URI.parse(@nytimes_get_request)
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
  
  
  def GetArtists.get_spotify_URIs(artists)
    uri_list = []
    artists.each do |artist|
      encoded_artist = artist.gsub(/\s/, '+')
      request_url = @spotify_get_request+encoded_artist
      data = Net::HTTP.get_response URI.parse(request_url)
      json_obj = JSON.parse(data.body)
      
      track_uri = json_obj["tracks"][0]["href"]
      
      p track_uri
      
      uri_list << track_uri
    end
    uri_list
  end  
  
end



data = GetArtists.make_json_request
artists = GetArtists.create_list(data.body)
spotify_URIs = GetArtists.get_spotify_URIs(artists)


File.open("tracks.txt", 'w') {|f| 
  spotify_URIs.each do |uri|
    f.write(uri.to_s + "\n")
  end
}