class ArchivesController < ApplicationController
  def index
    @labels = Label.all
    
    # Get search parameters
    @q = params[:q]
    @label_id = params[:label_id]
    @time_range = params[:time_range]
    
    # Build the query
    posts = Post.order(created_at: :desc)
    
    # Apply search filter if provided
    unless @q.blank?
      posts = posts.where('title like ?', "%#{@q}%")
      @q_size = posts.size
    end
    
    # Apply label filter if provided
    posts = posts.with_labels(@label_id)
    
    # Apply time range filter if provided
    posts = posts.by_time_range(@time_range)
    
    # Paginate the results
    @posts = posts.page(params[:page])
  end
end