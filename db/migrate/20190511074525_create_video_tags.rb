class CreateVideoTags < ActiveRecord::Migration[5.2]
  def change
    create_table :video_tags do |t|
      t.belongs_to :tag, foreign_key: true
      t.belongs_to :video, foreign_key: true

      t.timestamps
    end
  end
end
