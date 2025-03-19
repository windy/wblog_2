class ArchivesController < ApplicationController
  def index
    @labels = Label.all
    @time_filter = params[:time_filter]
    @label_id = params[:label_id]
    @q = params[:q]

    @posts = Post.order(created_at: :desc)

    # Filter by label if label_id is provided
    if @label_id.present?
      @posts = @posts.joins(:labels).where(labels: { id: @label_id })
    end

    # Filter by time range if time_filter is provided
    case @time_filter
    when 'three_days'
      @posts = @posts.where('created_at >= ?', 3.days.ago)
    when 'one_month'
      @posts = @posts.where('created_at >= ?', 1.month.ago)
    end

    # Filter by search query if q is provided
    if @q.present?
      @posts = @posts.where('title like ?', "%#{@q}%")
      @q_size = @posts.size
    end

    # Apply pagination
    @posts = @posts.page(params[:page])
  end
end