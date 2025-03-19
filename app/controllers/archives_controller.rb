class ArchivesController < ApplicationController
  def index
    # Get filter parameters
    @q = params[:q]
    @time_range = params[:time_range]
    @label_id = params[:label_id]
    
    # Initialize base query
    @posts = Post.order('posts.created_at': :desc)
    
    # Filter by title if search query exists
    @posts = @posts.where('title like ?', "%#{@q}%") if @q.present?
    
    # Filter by time range
    case @time_range
    when 'month'
      @posts = @posts.where('posts.created_at >= ?', 1.month.ago)
    when 'half_year'
      @posts = @posts.where('posts.created_at >= ?', 6.months.ago)
    when 'three_years'
      @posts = @posts.where('posts.created_at >= ?', 3.years.ago)
    end
    
    # Filter by label if label_id is provided
    if @label_id.present?
      @posts = @posts.joins(:labels).where(labels: { id: @label_id })
      @selected_label = Label.find_by(id: @label_id)
    end
    
    # Get total posts count for filtered results
    @posts_count = @posts.count
    
    # Apply pagination
    @posts = @posts.page(params[:page])
    
    # Fetch all labels for the dropdown
    @labels = Label.all
    
    # Flag to indicate if any filter is applied
    @filtered = @q.present? || @time_range.present? || @label_id.present?
  end
end