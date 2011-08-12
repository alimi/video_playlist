class PagesController < ApplicationController
  def home
    if(params[:playlist_id].nil?)
      @playlist = Playlist.first
    else
      @playlist = Playlist.find(params[:playlist_id])
    end

    @playlists = Playlist.where("id != ?", @playlist.id)
    @title = @playlist.name
  end

  def about
    @title = "about"
  end

end
