class Cron
  def self.run
    now = Time.now.utc
    if(now.friday? && now.hour == 11)
      playlists = Playlist.all
         
      playlists.each_with_index do |playlist, index|
        Delayed::Job.enqueue(YtUpdatePlaylistJob.new(playlist.name))
        sleep(30) unless index == playlists.size - 1
      end
    end
  end
end