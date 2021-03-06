class YtUpdatePlaylistJob < Struct.new(:playlist_name)
  def perform
    case playlist_name
    when "top 100"
      rss_query_result = parse_rss("http://www.billboard.com/rss/charts/hot-100")
    when "hip-hop"
      rss_query_result = parse_rss("http://www.billboard.com/rss/charts/r-b-hip-hop-songs")
    when "country"
      rss_query_result = parse_rss("http://www.billboard.com/rss/charts/country-songs")
    when "rock"
      rss_query_result = parse_rss("http://www.billboard.com/rss/charts/rock-songs")
    when "latin"
      rss_query_result = parse_rss("http://www.billboard.com/rss/charts/latin-songs")
    when "pop"
      rss_query_result = parse_rss("http://www.billboard.com/rss/charts/pop-songs")
    when "dance"
      rss_query_result = parse_rss("http://www.billboard.com/rss/charts/dance-club-play-songs")
    when "delayed_job"
      rss_query_result = parse_rss("http://www.billboard.com/rss/charts/dance-club-play-songs")
    else
      rss_query_result = false
    end
    
    if(rss_query_result)
      client = yt_data_api_call{
        YtDataApi::YtDataApiClient.new(ENV['YT_USER'], ENV['YT_USER_PSWD'], ENV['YT_DEV_AUTH_KEY'])
      }
      
      playlist_id = yt_data_api_call{ client.get_playlist_id(playlist_name) }

      if(playlist_id.nil?)
        response, playlist_id = yt_data_api_call{ client.create_playlist(playlist_name) }
      else
        yt_data_api_call{ client.delete_playlist(playlist_id) }
        response, playlist_id = yt_data_api_call{ client.create_playlist(playlist_name) }
      end

      rss_query_result.items.each do |item|
        song = item.title[/^[0-9]*: (.*)/, 1]
        song.gsub!(/ /, "+")
        song.gsub!(/,/, "")
        song.gsub!(/"/, "")
        
        video_id = yt_data_api_call{ client.get_video_ids(song) }
          
        if(video_id.nil?)
          puts "Unable to find video id for #{song}"
          puts "Unable to add #{song} to #{playlist_name}"
        else
          yt_data_api_call{ client.add_video_to_playlist(video_id, playlist_id) }
          puts "Added #{song} (#{video_id}) to #{playlist_name} (#{playlist_id})"
        end
      end
    else
      puts "Unable to match #{playlist_name} with source playlist"
    end
  end
  
  private
    #Use Ruby RSS Parser to return parseable info from RSS feed
    def parse_rss(rss_feed)
      rss_content = ""

      #Get feed information
      open (rss_feed) do |f|
        rss_content = f.read
      end

      RSS::Parser.parse(rss_content, false)
    end
    
    def yt_data_api_call(&block)
      count = 1
      
      begin
        response = block.call
        if(response.respond_to?('code') && response.code == "403")
          raise OpenURI::HTTPError.new(nil, nil) 
        end
        response
      rescue OpenURI::HTTPError
        if(count < 5)
          puts "Wait #{30 * count}..."
          sleep(30 * count)
          count += 1
          retry
        end 
      end
    end
end
