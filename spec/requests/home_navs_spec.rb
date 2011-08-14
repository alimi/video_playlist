require 'spec_helper'

describe "HomeNavs" do

  describe "GET 'home'" do
    before(:each) do
      Playlist.create!(:name => "test", :youtube_id => "2FDD934D493C1893")
      @switch_playlist = Playlist.create!(:name => "test_two", :youtube_id => "48BEBC3F884FC594")
      visit root_path
      @home_playlist = assigns(:playlist)
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
      click_link "video playlist"
      assigns(:playlist).id.should be @home_playlist.id
    end
  end

end
