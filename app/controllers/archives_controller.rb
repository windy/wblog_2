class ArchivesController < ApplicationController
  def index
    @period = params[:period]
    @likes_count = params[:likes_count]

    base_query = Post
    
    # Apply filters
    if (@q = params[:q]).present?
      base_query = base_query.where('posts.title like ?', "%#{@q}%")
      @q_size = base_query.size
    end
    
    # Apply time period filter
    base_query = base_query.by_period(@period)
    
    # Apply likes count filter
    base_query = base_query.by_likes_count(@likes_count)
    
    # Apply sorting and pagination
    @posts = base_query.order('posts.created_at DESC').page(params[:page])
  end
end