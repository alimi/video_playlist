require 'spec_helper'

describe YtUpdatePlaylistJob do
  before(:each) do
    @client = YtDataApi::YtDataApiClient.new(ENV['YT_USER'], ENV['YT_USER_PSWD'], ENV['YT_DEV_AUTH_KEY'])
    @client.create_playlist("delayed_job")
    @youtube_id = @client.get_client_playlist_id("delayed_job")
  end
  
  after(:each) do
    @client.delete_playlist(@youtube_id)
  end
  
  it "should update a YouTube playlist" do
    Delayed::Job.enqueue(YtUpdatePlaylistJob.new("delayed_job"))
    Delayed::Worker.new.work_off
    
    playlist_entries = @client.get_client_playlist_entries(@youtube_id)
    playlist_entries.size.should be > 0
  end
end