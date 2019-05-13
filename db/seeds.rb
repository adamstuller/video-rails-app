# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

def seed_users(rows)
  sql_q = "INSERT INTO users
 (name, email, password_digest, created_at, updated_at)
 VALUES "

  for a in (0..rows) do
    q = "(
     '#{PG::Connection.escape_string(Faker::Name.name)}',
      '#{PG::Connection.escape_string(Faker::Internet.email)}',
      '$2a$10$PakeGt7/As5CD.jBV4Mzm.cI3D9XCAFNbVZWGrOxtBg6tKgaijhSG',
     CURRENT_TIMESTAMP,
     CURRENT_TIMESTAMP
   ),"
    sql_q += q
  end

  return sql_q.chomp(",") # remove last ','

end


# query = seed_users(10)
# ActiveRecord::Base.connection.execute(query)

# count = 0.0
# all = 500_000.0
# for _ in (0..1000) do
#   query = seed_users(1000)
#   ActiveRecord::Base.connection.execute(query)
#   count += 500
#   puts count / all
#   puts "Users were inserted"
# end
#
# puts "Users were inserted!!!!"
#

def seed_videos(rows)
  stefan = Rails.root.join('tmp', 'storage', 'Stefan.mp4').to_s
  stefan_thumbnail = Rails.root.join('tmp', 'storage', 'Stefan.jpg').to_s
  (0..rows).each { |a|
    v = Video.new(name: Faker::Superhero.name, desc: Faker::Superhero.descriptor)

    v.video_file.attach(
      io: File.open(stefan),
      filename: 'new_video'
    )
    v.thumbnail.attach(
      io: File.open(stefan_thumbnail),
      filename: 'new_thumbnail'
    )
    v.save
    puts a
  }

end

# seed_videos(5000)
#

def seed_tags(rows)
  sql_q = "INSERT INTO tags
 (name, created_at, updated_at)
 VALUES "

  for a in (0..rows) do
    q = "(
     '#{PG::Connection.escape_string(Faker::Books::Lovecraft.words(1)[0])}',
     CURRENT_TIMESTAMP,
     CURRENT_TIMESTAMP
   ),"
    sql_q += q
  end

  return sql_q.chomp(",") # remove last ','
end

# query = seed_tags(10)
# ActiveRecord::Base.connection.execute(query)
# count = 0.0
# all = 500_000.0
# for _ in (0..1000) do
#   query = seed_users(1000)
#   ActiveRecord::Base.connection.execute(query)
#   count += 500
#   puts count / all
#   puts "Tags were inserted"
# end

# puts " were inserted!!!!"

def add_tags()
  Video.all.to_a.each do |video|
    t = Random.rand(5)
    t.times do
      begin
        tag_id = Random.rand(40)
        tag = Tag.find(tag_id)
        video.video_tags.create(tag: tag)
      rescue
        puts 'nevyslo'
      end
    end
  end
end

add_tags