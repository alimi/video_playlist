class Cron
  def self.run(playlist_name)
    now = Time.now
    if(now.sunday? && now.hour == 7)
      client = YtDataApi::YtDataApiClient.new(ENV['YT_USER'], ENV['YT_USER_PSWD'], ENV['YT_DEV_AUTH_KEY'])

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
      else
        raise "No matching feed for playlist #{playlist_name}"
      end

      playlist_id = client.get_client_playlist_id(playlist_name)

      if(playlist_id.nil?)
        client.create_playlist(playlist_name)
        playlist_id = client.get_client_playlist_id(playlist_name)
      else
        #empty = client.empty_playlist(playlist_id)
        client.delete_playlist(playlist_id)
        client.create_playlist(playlist_name)
        playlist_id = client.get_client_playlist_id(playlist_name)
      end

      rss_query_result.items.each do |item|
        song = item.title[/^[0-9]*: (.*)/, 1]
        song.gsub!(/ /, "+")
        song.gsub!(/,/, "")
        song.gsub!(/"/, "")

        video_id = client.get_video_id(song)

        if(video_id.nil?)
          puts "Unable to find video id for #{song}"
          puts "Unable to add #{song} to #{playlist_name}"
        else
          client.add_video_to_playlist(video_id, playlist_id)
          puts "Added #{song} (#{video_id}) to #{playlist_name} (#{playlist_id})"
        end
      end
    else
        return nil
    end
  end

  private
    #Use Ruby RSS Parser to return parseable info from RSS feed
    def self.parse_rss(rss_feed)
      rss_content = ""

      #Get feed information
      open (rss_feed) do |f|
        rss_content = f.read
      end

      RSS::Parser.parse(rss_content, false)
    end
end