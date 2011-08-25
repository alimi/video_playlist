require 'spec_helper'

describe Cron do
  before(:each) do
    YtDataApi::YtDataApiClient.stub!(:empty_playlist).and_return(true)
    YtDataApi::YtDataApiClient.stub!(:add_video_to_playlist).and_return("201")

    @playlists = Playlist.all
  end

  it "should update YouTube playlists for video playlist every Sunday at 7:00 AM" do
    Timecop.freeze(2011, 8, 28, 7, 0, 0)

    @playlists.each do |playlist|
      Cron.run(playlist.name)

      YtDataApi::YtDataApiClient.should_receive(:empty_playlist).with(playlist.id)
      YtDataApi::YtDataApiClient.should_receive(:add_video_to_playlist).with(anything(), playlist.id)
    end
  end

  it "should not update YouTube playlist for video playlist any other time" do
    Timecop.freeze(2011, 8, 29, 7, 0, 0)

    @playlists.each do |playlist|
      Cron.run(playlist.name)

      YtDataApi::YtDataApiClient.should_not_receive(:empty_playlist).with(playlist.id)
      YtDataApi::YtDataApiClient.should_not_receive(:add_video_to_playlist).with(anything(), playlist.id)
    end
  end

  after(:each) do
    Timecop.return
  end
end