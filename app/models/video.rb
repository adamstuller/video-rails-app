# frozen_string_literal: true

class Video < ApplicationRecord
  attr_reader :thumbnail

  after_create :after_create

  has_one_attached :video_file
  has_one_attached :thumbnail

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
end
