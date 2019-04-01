require 'streamio-ffmpeg'

class Video < ApplicationRecord

  after_create :after_create

  has_one_attached :video_file
  has_one_attached :thumbnail


  def after_create

    # if !video_file.nil?
    #   # puts "AFTER_INITIALIZE #{ActiveStorage::Blob.service.send(:path_for, video_file.key)}"
    #
    #
    # end

    # movie = FFMPEG::Movie.new("#{ActiveStorage::Blob.service.send(:path_for, video_file.key)}")
    # puts "AFTER CREATION !!!!!!!!!!!!!!!!!!!!!!!! MOVIE DURATION: #{movie.duration}"
    # movie.screenshot('~/Desktop/screen.jpg' )


  end


end
