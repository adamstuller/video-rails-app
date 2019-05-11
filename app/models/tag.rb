class Tag < ApplicationRecord

  has_many :video_tags
  has_many :video, through: :video_tags
end
