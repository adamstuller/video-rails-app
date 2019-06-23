# frozen_string_literal: true

class Video < ApplicationRecord
  attr_reader :thumbnail

  after_create :after_create

  has_many :video_tags, dependent: :destroy
  has_many :tags, through: :video_tags

  has_many :user_videos, dependent: :destroy
  has_many :users, through: :user_videos

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

  def add_subtitle(subtitle, fontsize, font, color)
    video_path = ActiveStorage::Blob.service.send(:path_for, video_file.key).to_s
    temp_storage = Rails.root.join('tmp', 'storage', 'temp.mp4').to_s

    if font != ''
      font_option = 'fontfile=' + font + ':'
    else
      font_option = ''
    end

    font_color = 'fontcolor=' + color + ':'

    File.delete(temp_storage) if File.file?(temp_storage)

    system `ffmpeg -i #{video_path} -vf drawtext="#{font_option}fontsize=#{fontsize}: #{font_color} text='#{subtitle}': x=(w-text_w)/2: y=(h-text_h)*(3/4)"  #{temp_storage}`


    if File.file?(temp_storage)
      video_file.purge
      video_file.attach(
        io: File.open(temp_storage),
        filename: 'new_video.mp4'
      )
    end
  end


  def add_audio( audio_id )

    video_path = ActiveStorage::Blob.service.send(:path_for, video_file.key).to_s
    temp_storage = Rails.root.join('tmp', 'storage', 'temp.mp4').to_s
    audio = Audio.find(audio_id)
    audio_path = ActiveStorage::Blob.service.send(:path_for, audio.audio_file.key).to_s


    File.delete(temp_storage) if File.file?(temp_storage)
    system `ffmpeg -i #{video_path} -i #{audio_path}  -map 0:v:0 -map 1:a:0 -shortest #{temp_storage} `


    if File.file?(temp_storage)
      video_file.purge
      video_file.attach(
          io: File.open(temp_storage),
          filename: 'new_video.mp4'
      )
    end

  end

  def self.tagged_with(tag_names)
    require 'set'
    ids = Set.new
    tagged_videos = []
    Tag.where(name: tag_names).to_a.each do |t|
      t.video.to_a.each do |v|
        unless ids.include?(v.id)
          ids.add(v.id)
          tagged_videos.push(v)
        end

      end
    end
    tagged_videos
  end


  def tag_list
    tags.map(&:name).join(', ')
  end
end
