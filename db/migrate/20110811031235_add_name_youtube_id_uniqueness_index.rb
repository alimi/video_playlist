class AddNameYoutubeIdUniquenessIndex < ActiveRecord::Migration
  def self.up
    add_index :playlists, :name, :unique => true
    add_index :playlists, :youtube_id, :unique => true
  end

  def self.down
    remove_index :playlists, :name
    remove_index :playlists, :youtube_id
  end
end
