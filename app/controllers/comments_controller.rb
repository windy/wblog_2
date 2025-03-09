class CommentsController < ApplicationController
  layout false

  def create
    cookies[:name] = comment_params[:name]
    cookies[:email] = comment_params[:email]

    @post = Post.find( params[:blog_id] )
    @comments = @post.comments.order(created_at: :desc)

    @comment = @post.comments.build(comment_params)
    
    # 过滤评论内容中的敏感词
    filter_service = TencentCloudTextFilter.new
    filter_result = filter_service.filter_text(@comment.content)
    
    # 更新评论的敏感词相关字段
    @comment.filtered_content = filter_result[:filtered_content]
    @comment.has_sensitive_words = filter_result[:has_sensitive_words]
    @comment.sensitive_word_count = filter_result[:sensitive_word_count]
    
    if @comment.save
      if @comment.has_sensitive_words
        flash.now[:warning] = '评论成功，但含有敏感词，已被自动过滤'
      else
        flash.now[:notice] = '发表成功'
      end
      # 重置评论
      @comment = Comment.new
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