class CommentsController < ApplicationController
  layout false

  def create
    cookies[:name] = comment_params[:name]
    cookies[:email] = comment_params[:email]

    @post = Post.find(params[:blog_id])
    @comments = @post.comments.order(created_at: :desc)

    @comment = @post.comments.build(comment_params)
    
    original_content = @comment.content.dup
    if @comment.save
      if @comment.content != original_content
        flash.now[:notice] = '评论发表成功,但包含敏感词已被过滤'
      else
        flash.now[:notice] = '评论发表成功'
      end
      # 重置评论
      @comment = Comment.new
    else
      flash.now[:alert] = '评论发表失败'
    end
  rescue StandardError => e
    Rails.logger.error "Comment creation failed: #{e.message}"
    flash.now[:alert] = '评论发表失败,请稍后重试'
  end

  def refresh
    @post = Post.find(params[:blog_id])
    @comments = @post.comments.order(created_at: :desc)
  end

  private
  def comment_params
    params.require(:comment).permit(:content, :name, :email)
  end
end