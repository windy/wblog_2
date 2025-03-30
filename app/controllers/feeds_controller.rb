class FeedsController < ApplicationController
  def index
    @posts = Post.all.order(created_at: :desc).limit(10)
    respond_to do |format|
      format.rss { render layout: false }
    end
  end
end