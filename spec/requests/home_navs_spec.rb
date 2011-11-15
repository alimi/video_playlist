require 'spec_helper'

describe "HomeNavs" do

  describe "GET 'home'" do
    before(:each) do
      @client = YtDataApi::YtDataApiClient.new(ENV['YT_USER'], ENV['YT_USER_PSWD'], ENV['YT_DEV_AUTH_KEY'])
      
      response_one, @youtube_id_one = @client.create_playlist("test_playlist_one")
      response_two, @youtube_id_two = @client.create_playlist("test_playlist_two")
      
      Playlist.create!(:name => "test_playlist_one", :youtube_id => @youtube_id_one)
      Playlist.create!(:name => "test_playlist_two", :youtube_id => @youtube_id_two)
      
      visit root_path
      @home_playlist = assigns(:playlist)
      @switch_playlist = Playlist.find_by_name("test_playlist_two")
    end

    after(:each) do
      @client.delete_playlist(@youtube_id_one)
      @client.delete_playlist(@youtube_id_two)  
    end
    
    it "should load a new playlist when playlist link is clicked" do
      click_link @switch_playlist.name
      assigns(:playlist).id.should be @switch_playlist.id
    end

    it "should load the about page when about link is clicked" do
      click_link "alimi"
      response.should have_selector("title", :content => "about")
    end

    it "should load the home page when the home link is clicked" do
      click_link "stormyflower"
      assigns(:playlist).id.should be @home_playlist.id
    end
  end

end
