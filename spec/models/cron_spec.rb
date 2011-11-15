require 'spec_helper'

describe Cron do
  before(:each) do
    @client = YtDataApi::YtDataApiClient.new(ENV['YT_USER'], ENV['YT_USER_PSWD'], ENV['YT_DEV_AUTH_KEY'])

    response_one, @youtube_id_one = @client.create_playlist("test_playlist_one")
    response_two, @youtube_id_two = @client.create_playlist("test_playlist_two")

    Playlist.create!(:name => "test_playlist_one", :youtube_id => @youtube_id_one)
    Playlist.create!(:name => "test_playlist_two", :youtube_id => @youtube_id_two)

    @playlists = Playlist.all
  end
  
  after(:each) do
    Timecop.return
    @client.delete_playlist(@youtube_id_one)
    @client.delete_playlist(@youtube_id_two)
  end

  it "should schedule YtUpdatePlaylistJob to update all playlists every Friday at 11:00 UTC" do
    time = Time.utc(2011, 10, 14, 11)
    Timecop.freeze(time)
    Cron.run
    jobs = Delayed::Job.all
    jobs.size.should be > 0
  end

  it "should not schedule YtUpdatePlaylistJob any other time" do
    time = Time.utc(2011, 10, 14, 12)
    Timecop.freeze(time)
    Cron.run
    jobs = Delayed::Job.all
    jobs.size.should == 0
  end
end