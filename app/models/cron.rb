class Cron
  def self.run
    now = Time.now.utc
    if(now.friday? && now.hour == 11)
      playlists = Playlist.all
         
      playlists.each do |playlist|
        Delayed::Job.enqueue(YtUpdatePlaylistJob.new(playlist.name))
      end
    end
  end
end