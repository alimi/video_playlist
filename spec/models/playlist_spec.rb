require 'spec_helper'

describe Playlist do
  before(:each) do
    @client = YtDataApi::YtDataApiClient.new(ENV['YT_USER'], ENV['YT_USER_PSWD'], ENV['YT_DEV_AUTH_KEY'])
    
    @client.create_playlist("test_playlist_one")
    @client.create_playlist("test_playlist_two")
    
    @youtube_id_one = @client.get_client_playlist_id("test_playlist_one")
    @youtube_id_two = @client.get_client_playlist_id("test_playlist_two")
    
    @attr = {
      :name => "test_playlist_one",
      :youtube_id => @youtube_id_one
    }
  end

  after(:each) do
    @client.delete_playlist(@youtube_id_one)
    @client.delete_playlist(@youtube_id_two)  
  end
  
  it "should create a new instance given valid attributes" do
    Playlist.create!(@attr)
  end

  it "should require a name" do
    no_name = Playlist.new(@attr.merge(:name => ""))
    no_name.should_not be_valid
  end

  it "should have a unique name" do
    Playlist.create!(@attr)
    duplicate_name = Playlist.new(@attr.merge(:youtube_id => @youtube_id_two))
    duplicate_name.should_not be_valid
  end

  it "should require a youtube id" do
    no_id = Playlist.new(@attr.merge(:youtube_id => ""))
    no_id.should_not be_valid
  end

  it "should have an active youtube id" do
    invalid_id = Playlist.new(@attr.merge(:youtube_id => "trash"))
    invalid_id.should_not be_valid
  end

  it "should have a unique youtube id" do
    Playlist.create!(@attr)
    duplicate_id = Playlist.new(@attr.merge(:name => "test_playlist_two"))
    duplicate_id.should_not be_valid
  end  
end
