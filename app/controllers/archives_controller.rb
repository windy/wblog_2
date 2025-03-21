class ArchivesController < ApplicationController
  def index
    @time_option = params[:time_option]
    @label_id = params[:label_id]
    @min_views = params[:min_views]
    @min_likes = params[:min_likes]
    @q = params[:q]
    
    @labels = Label.all

    posts_query = Post
    
    # Apply title search filter
    unless @q.blank?
      posts_query = posts_query.where('title like ?', "%#{@q}%")
      @q_size = posts_query.size
    end
    
    # Apply time range filter
    posts_query = posts_query.by_time_range(@time_option) if @time_option.present?
    
    # Apply label filter
    posts_query = posts_query.by_label(@label_id) if @label_id.present?
    
    # Apply views filter
    posts_query = posts_query.by_views(@min_views) if @min_views.present?
    
    # Apply likes filter
    posts_query = posts_query.by_likes(@min_likes) if @min_likes.present?
    
    # Apply final sorting and pagination
    @posts = posts_query.order(created_at: :desc).page(params[:page])
  end
end