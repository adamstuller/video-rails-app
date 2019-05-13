class Tag < ApplicationRecord

  has_many :video_tags
  has_many :video, through: :video_tags

  validates :name, uniqueness: true

  def self.get_tags(tags_list)
    tag_names = tags_list.split(',')
    tags = tag_names.map{ |name| Tag.find_by(name: name) }
    tags
  end
end
