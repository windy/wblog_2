class Admin::PostsController < Admin::BaseController
  def new
    @post = Post.new
    # Initialize a default Poll with 3 empty PollOptions
    @post.build_poll
    3.times { @post.poll.poll_options.build }
  end

  def edit
    @post = Post.find( params[:id] )
    # If post doesn't have a poll, create one with 3 empty options
    if @post.poll.nil?
      @post.build_poll
      3.times { @post.poll.poll_options.build }
    elsif @post.poll.poll_options.empty?
      # If poll exists but has no options, create 3 empty ones
      3.times { @post.poll.poll_options.build }
    end
  end

  def destroy
    @post = Post.find( params[:id] )
    if @post.destroy
      flash[:notice] = '删除博客成功'
      redirect_to admin_posts_path
    else
      flash[:error] = '删除博客失败'
      redirect_to admin_posts_path
    end
  end

  def index
    @posts = Post.order(created_at: :desc).page(params[:page]).per(25)
  end

  def create
    @post = Post.new( post_params )

    if @post.save
      flash[:notice] = '创建博客成功'
      redirect_to admin_posts_path
    else
      flash.now[:error] = '创建失败'
      render :new, status: 422
    end
  end

  def update
    @post = Post.find( params[:id] )

    if @post.update( post_params )
      flash[:notice] = '更新博客成功'
      redirect_to admin_posts_path
    else
      flash[:error] = '更新博客失败'
      render :edit
    end
  end

  def preview
    render plain: Post.render_html(params[:content] || "")
  end

  private
  def post_params
    params.require(:post).permit(
      :title, 
      :content, 
      label_ids: [], 
      poll_attributes: [
        :id, 
        :title, 
        :_destroy, 
        poll_options_attributes: [:id, :content, :_destroy]
      ]
    )
  end
end