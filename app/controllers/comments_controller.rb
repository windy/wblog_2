class CommentsController < ApplicationController
  layout false

  def create
    cookies[:name] = comment_params[:name]
    cookies[:email] = comment_params[:email]

    @post = Post.find( params[:blog_id] )
    @comments = @post.comments.order(created_at: :desc)

    @comment = @post.comments.build(comment_params)

    # 处理图片上传
    if params[:comment][:photo].present?
      begin
        photo = Photo.new(image: params[:comment][:photo])
        if photo.save
          @comment.photo = photo
        else
          flash.now[:alert] = '图片上传失败，但评论仍会保存'
        end
      rescue => e
        flash.now[:alert] = '图片处理出错，但评论仍会保存'
        Rails.logger.error("图片上传错误: #{e.message}")
      end
    end

    if @comment.save
      flash.now[:notice] = '发表成功'
      # 重置评论
      @comment = Comment.new
    else
      flash.now[:alert] = @comment.errors.full_messages.join(', ')
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