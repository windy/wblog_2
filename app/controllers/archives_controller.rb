class ArchivesController < ApplicationController
  def index
    @sort_by = params[:sort_by] || 'created_at'
    @direction = params[:direction] || 'desc'

    # Validate sort parameters
    allowed_sort_fields = %w[created_at liked_count visited_count]
    allowed_directions = %w[asc desc]
    
    @sort_by = 'created_at' unless allowed_sort_fields.include?(@sort_by)
    @direction = 'desc' unless allowed_directions.include?(@direction)

    if (@q = params[:q]).blank?
      @posts = Post.order(@sort_by => @direction.to_sym).page(params[:page])
    else
      @q_size = Post.where('title like ?', "%#{@q}%").size
      @posts = Post.where('title like ?', "%#{@q}%").order(@sort_by => @direction.to_sym).page(params[:page])
    end
  end
end