class ArchivesController < ApplicationController
  def index
    @labels = Label.all.order(:name)
    @label_id = params[:label_id]
    @q = params[:q]

    posts_query = Post.includes(:labels).order(created_at: :desc)

    # Filter by title if search query present
    posts_query = posts_query.where('title like ?', "%#{@q}%") if @q.present?

    # Filter by label if label_id present
    if @label_id.present?
      posts_query = posts_query.joins(:labels).where(labels: { id: @label_id })
    end

    # Get the total count for search results before pagination
    @q_size = posts_query.size if @q.present? || @label_id.present?
    
    # Apply pagination
    @posts = posts_query.page(params[:page])
  end
end