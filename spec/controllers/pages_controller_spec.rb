require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'home'" do
    before(:each) do
      @client = YtDataApi::YtDataApiClient.new(ENV['YT_USER'], ENV['YT_USER_PSWD'], ENV['YT_DEV_AUTH_KEY'])

      @client.create_playlist("test_playlist_one")
      @client.create_playlist("test_playlist_two")
      @client.create_playlist("test_playlist_three")

      @youtube_id_one = @client.get_client_playlist_id("test_playlist_one")
      @youtube_id_two = @client.get_client_playlist_id("test_playlist_two")
      @youtube_id_three = @client.get_client_playlist_id("test_playlist_three")
      
      Playlist.create!(:name => "test_playlist_one", :youtube_id => @youtube_id_one)
      Playlist.create!(:name => "test_playlist_two", :youtube_id => @youtube_id_two)
      Playlist.create!(:name => "test_playlist_three", :youtube_id => @youtube_id_three)
      
      get :home
      @home_playlist = assigns(:playlist)
      @home_playlists = assigns(:playlists)
      @switch_playlist = Playlist.find_by_name("test_playlist_three")
    end
    
    after(:each) do
      @client.delete_playlist(@youtube_id_one)
      @client.delete_playlist(@youtube_id_two)
      @client.delete_playlist(@youtube_id_three)  
    end

    it "should be successful" do
      response.should be_success
    end

    it "should get the first playlist by default" do
      @home_playlist.id.should be Playlist.first.id
    end

    it "should have links for all playlists except the one that is displayed" do
      @home_playlists.each do |playlist|
        playlist.should_not be assigns(:playlist)
      end
    end

    it "should show a new playlist when it is selected" do
      get :home, :playlist_id => @switch_playlist.id
      assigns(:playlist).id.should be @switch_playlist.id
    end

    it "should update links when a new playlist is selected" do
      get :home, :playlist_id => @switch_playlist.id
      assigns(:playlists).each do |playlist|
        playlist.should_not be assigns(:playlist)
      end
    end

    it "should have the right title" do
      assigns(:title).should be @home_playlist.name
    end

    it "should have a link to the about page" do
      response.should have_selector("a", :href => "/about", :content => "alimi")
    end
 
    it "should have a link to the home page" do
      response.should have_selector("a", :href => "/", :content => "stormyflower")
    end
  end

  describe "GET 'about'" do
    before(:each) do
      get :about
    end

    it "should be successful" do
      response.should be_success
    end

    it "should have the right title" do
      assigns(:title).should == "about"
    end

    it "should have content" do
      response.should have_selector("section")
    end

    it "should have a link to the about page" do
      response.should have_selector("a", :href => "/about", :content => "alimi")
    end
 
    it "should have a link to the home page" do
      response.should have_selector("a", :href => "/", :content => "stormyflower")
    end
  end

end
