class VotesController < ApplicationController
  layout false

  def create
    @post = Post.find(params[:blog_id])
    
    unless already_voted?
      # Generate a session_id if not present
      session[:session_id] ||= SecureRandom.hex(16)
      
      @vote = @post.votes.build(vote_params)
      @vote.session_id = session[:session_id]
      
      if @vote.save
        flash.now[:notice] = '投票成功'
      else
        flash.now[:alert] = '投票失败'
      end
    else
      flash.now[:alert] = '您已经投过票了'
    end
    
    # Prepare data for result display
    @votes_count = @post.votes.count_by_option
    @total_votes = @post.votes.count
    @user_vote = @post.votes.find_by(session_id: session[:session_id])
  end

  private
  
  def vote_params
    params.require(:vote).permit(:option)
  end
  
  def already_voted?
    session[:session_id] && @post.votes.exists?(session_id: session[:session_id])
  end
end