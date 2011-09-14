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

  it "should update YouTube playlists for video playlist every Sunday at 7:00 AM" do
    Timecop.freeze(2011, 8, 28, 7, 0, 0)

    @playlists.each do |playlist|
      lambda{ Cron.run(playlist.name) }.should raise_error
    end
  end

  it "should not update YouTube playlists for video playlist any other time" do
    Timecop.freeze(2011, 8, 29, 7, 0, 0)

    @playlists.each do |playlist|
      Cron.run(playlist.name).should == nil
    end
  end
end