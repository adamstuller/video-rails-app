# frozen_string_literal: true

class Video < ApplicationRecord
  attr_reader :thumbnail

  after_create :after_create

  has_one_attached :video_file
  has_one_attached :thumbnail

  self.per_page = 10
  # After creation, if no thumbnail is added, new one is generated => not when editing
  def after_create
    file = Rails.root.join('tmp', 'storage', 'Stefan.jpg').to_s
    video_path = ActiveStorage::Blob.service.send(:path_for, video_file.key).to_s

    system "if [ -e #{file} ]; then rm #{file}; fi &&
            ffmpeg -ss 00:00:01 -i #{video_path} -vframes 1 -q:v 2 #{file}"

    unless thumbnail.attached?
      thumbnail.attach(
        io: File.open(file.to_s),
        filename: 'image.jpg'
      )
    end
  end

  def add_subtitle(subtitle)
    video_path = ActiveStorage::Blob.service.send(:path_for, video_file.key).to_s
    temp_storage = Rails.root.join('tmp', 'storage', 'temp.mp4').to_s


    if File.file?(temp_storage)
      File.delete(temp_storage)
    end

    system `ffmpeg -i #{video_path} -vf drawtext="fontsize=50: fontcolor=white: text='#{subtitle}': x=(w-text_w)/2: y=(h-text_h)*(3/4)"  #{temp_storage}`

    if File.file?(temp_storage)
      video_file.purge
      video_file.attach(
        io: File.open(temp_storage),
        filename: 'new_video'
      )
    end
  end
end
