class VideoWorker
  include Sidekiq::Worker

  def perform(clip_id, text)

    clip = Video.find(clip_id)
    clip_path = ActiveStorage::Blob.service.send(:path_for, clip.video_file.key).to_s



    output = "~/Desktop/output.mp4"
    input = "~/Desktop/Stefan.mp4"

    system "if [ -e #{output} ]; then rm #{output}; fi && \
            ffmpeg -i #{input} -vf drawtext=\"fontsize=50: fontcolor=white: text='#{text}': x=(w-text_w)/2: y=(h-text_h)*(3/4)\"  #{output}"

  end
end
