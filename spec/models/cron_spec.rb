require 'spec_helper'

describe Cron do
  before(:each) do
    @client = YtDataApi::YtDataApiClient.new(ENV['YT_USER'], ENV['YT_USER_PSWD'], ENV['YT_DEV_AUTH_KEY'])

    @client.create_playlist("test_playlist_one")
    @client.create_playlist("test_playlist_two")

    @youtube_id_one = @client.get_client_playlist_id("test_playlist_one")
    @youtube_id_two = @client.get_client_playlist_id("test_playlist_two")

    Playlist.create!(:name => "test_playlist_one", :youtube_id => @youtube_id_one)
    Playlist.create!(:name => "test_playlist_two", :youtube_id => @youtube_id_two)

    @playlists = Playlist.all
  end
  
  after(:each) do
    Timecop.return
    @client.delete_playlist(@youtube_id_one)
    @client.delete_playlist(@youtube_id_two)
  end

  it "should schedule YtUpdatePlaylistJob to update all playlists every Sunday at 7:00 AM" do
    Timecop.freeze(2011, 8, 28, 7, 0, 0)
    Cron.run
    jobs = Delayed::Job.all
    jobs.size.should be > 0
  end

  it "should not schedule YtUpdatePlaylistJob any other time" do
    Timecop.freeze(2011, 8, 28, 8, 0, 0)
    Cron.run
    jobs = Delayed::Job.all
    jobs.size.should == 0
  end
end