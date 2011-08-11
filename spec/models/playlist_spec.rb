require 'spec_helper'

describe Playlist do
  before(:each) do
    @attr = {
      :name => "test",
      :youtube_id => "2FDD934D493C1893"
    }
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
    duplicate_name = Playlist.new(@attr.merge(:youtube_id => "48BEBC3F884FC594"))
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
    duplicate_id = Playlist.new(@attr.merge(:name => "test_two"))
    duplicate_id.should_not be_valid
  end  
end
