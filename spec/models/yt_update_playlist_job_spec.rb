require 'spec_helper'

describe YtUpdatePlaylistJob do
  before(:each) do
    @client = YtDataApi::YtDataApiClient.new(ENV['YT_USER'], ENV['YT_USER_PSWD'], ENV['YT_DEV_AUTH_KEY'])
    response, @youtube_id = @client.create_playlist("delayed_job")
  end
  
  after(:each) do
    @client.delete_playlist(@youtube_id)
  end
  
  it "should update a YouTube playlist" do
    playlist_entries_before = @client.get_client_playlist_entries(@youtube_id)
    before_count = playlist_entries_before.size
    before_count.should == 0
    
    Delayed::Job.enqueue(YtUpdatePlaylistJob.new("delayed_job"))
    Delayed::Worker.new.work_off
    
    playlist_entries_after = @client.get_client_playlist_entries(@youtube_id)
    playlist_entries_after.size.should be > before_count
  end
end