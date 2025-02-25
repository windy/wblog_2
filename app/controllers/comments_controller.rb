class CommentsController < ApplicationController
  layout false

  def create
    cookies[:name] = comment_params[:name]
    cookies[:email] = comment_params[:email]

    @post = Post.find(params[:blog_id])
    @comments = @post.comments.order(created_at: :desc)
    
    @comment = @post.comments.build(comment_params)
    if @comment.save
      flash.now[:notice] = '发表成功'
      # 重置评论
      @comment = Comment.new
      render :create
    else
      if @comment.errors[:content].include?(:sensitive_words)
        flash.now[:alert] = "评论包含敏感词: #{@comment.errors.details[:content].first[:words]}"
      else
        flash.now[:alert] = '评论发表失败'
      end
      render :create, status: :unprocessable_entity
    end
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