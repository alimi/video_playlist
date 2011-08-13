require 'spec_helper'

describe PagesController do
  render_views

  describe "GET 'home'" do
    before(:each) do
      Playlist.create!(:name => "test", :youtube_id => "2FDD934D493C1893")
      Playlist.create!(:name => "test_two", :youtube_id => "48BEBC3F884FC594")
      @switch_playlist = Playlist.create!(:name => "test_three", :youtube_id => "38F91850BDBECF3B")
      get :home
      @home_playlist = assigns(:playlist)
      @home_playlists = assigns(:playlists)
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
      response.should have_selector("a", :href => "/", :content => "video playlist")
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
      response.should have_selector("a", :href => "/", :content => "video playlist")
    end
  end

end
