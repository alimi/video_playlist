class YoutubeIdValidator < ActiveModel::EachValidator
  # implement method called during validation
  # from PerfectLine.ee Building Rails 3 custom validators

  require 'net/http'

  def validate_each(record, attribute, value)
    uri = URI.parse("http://www.youtube.com/playlist?list=PL#{value}")
    record.errors[value] << 'must be valid YouTube Playlist ID' unless Net::HTTP.get_response(uri).code == "200"
  end
end

class Playlist < ActiveRecord::Base
  attr_accessible :name, :youtube_id

  validates :name, :presence => true, :uniqueness => true
  validates :youtube_id, :presence => true, :uniqueness => true, :youtube_id => true
end
