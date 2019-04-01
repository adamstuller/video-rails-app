json.extract! video, :id, :name, :desc, :created_at, :updated_at
json.url video_url(video, format: :json)
