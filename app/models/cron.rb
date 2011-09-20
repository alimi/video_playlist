class Cron
  def self.run
    now = Time.now
    if(now.sunday? && now.hour == 7)
      playlists = Playlist.all
         
      playlists.each do |playlist|
        Delayed::Job.enqueue(YtUpdatePlaylistJob.new(playlist.name))
      end
    end
  end
end