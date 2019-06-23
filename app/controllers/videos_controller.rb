# require 'VideoWorker'
require 'will_paginate/array'

class VideosController < ApplicationController
  before_action :set_video, only: [:show, :edit, :update, :destroy, :add_subtitle, :display_editor, :add_audio]

  skip_before_action :require_user, only: [:index]

  def index

    # @videos = Video.paginate(page: params[:page])
    @all_tags = Tag.all

    tag_counts = Video.joins(:video_tags).distinct.select('videos.id, COUNT(video_tags.*) AS tags_count').group('videos.id')
    @tag_hash = {}
    tag_counts.each do |tc|
      @tag_hash[tc.id] = tc.tags_count
    end

    if params[:tag]
      @videos = Video.tagged_with(params[:tag]).paginate(page: params[:page], per_page: 10)
    else
      @videos = Video.paginate(page: params[:page])
    end

  end

  def show

  end

  def new
    @video = Video.new
    @all_tags = Tag.all
    @curr_tags = @video.tags.to_a
  end

  def edit
    @all_tags = Tag.all
    @curr_tags = @video.tags.to_a
  end

  def create

    tag_hash = {"tags" => Tag.get_tags(video_params[:tag_list]) }
    new_params = video_params.merge(tag_hash)
    new_params.delete('tag_list')

    @video = Video.new(new_params)

    respond_to do |format|
      if @video.save
        format.html { redirect_to @video, notice: 'Video was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      tag_hash = {"tags" => Tag.get_tags(video_params[:tag_list]) }
      new_params = video_params.merge(tag_hash)
      new_params.delete('tag_list')

      if @video.update(new_params)
        format.html { redirect_to @video, notice: 'Video was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    # VideoWorker.perform_async(@video.id, "Halloc")

    @video.destroy
    respond_to do |format|
      format.html { redirect_to videos_url, notice: 'Video was successfully destroyed.' }
    end
  end

  def add_subtitle
    @video.add_subtitle(params[:subtitle], params[:fontsize], params[:font], params[:color])
  end

  def add_audio
    @video.add_audio params[:audio_id]
  end

  def display_editor

    @fonts = Font.all.order(:name)
    @audios = Audio.all.order(:name)

    respond_to do |format|
      format.html { render :editor }
    end
  end


  private

  def set_video
    @video = Video.find(params[:id])
    # VideoWorker.perform_async(@video.id, "Hallloc")

  end

  def video_params
    params.require(:video).permit(:name, :desc, :video_file, :thumbnail, :id, :subtitle, :fontsize, :font, :page, :tag_list, :tags, :color, :audio_id)
  end
end
