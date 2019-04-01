
class Video < ApplicationRecord

  attr_reader :thumbnail

  after_create :after_create

  has_one_attached :video_file
  has_one_attached :thumbnail

  # After creation, thumbnail is added
  def after_create

    file = Rails.root.join('tmp', 'storage', 'Stefan.jpg').to_s
    video_path = ActiveStorage::Blob.service.send(:path_for, self.video_file.key).to_s

    system "if [ -e #{file} ]; do rm #{file}; done &&
            ffmpeg -ss 00:00:01 -i #{video_path} -vframes 1 -q:v 2 #{file}"


    self.thumbnail.purge if self.thumbnail.attached?
    self.thumbnail.attach(
        io: File.open("#{file}"),
        filename: 'image.jpg'
    )
  end


end
