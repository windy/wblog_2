class VotesController < ApplicationController
  layout false

  def create
    @post = Post.find(params[:blog_id])
    
    unless @post && @post.enable_voting
      return render json: { success: false, message: "Post not found or voting disabled" }, status: :unprocessable_entity
    end
    
    session_id = request.session[:session_id]
    
    @vote = @post.votes.build(
      vote_type: params[:vote_type],
      session_id: session_id
    )
    
    if @vote.save
      render json: { 
        success: true, 
        excellent: {
          count: @post.vote_count_for('excellent'),
          percentage: @post.vote_percentage_for('excellent')
        },
        normal: {
          count: @post.vote_count_for('normal'),
          percentage: @post.vote_percentage_for('normal')
        },
        poor: {
          count: @post.vote_count_for('poor'),
          percentage: @post.vote_percentage_for('poor')
        },
        total: @post.total_votes
      }
    else
      render json: { 
        success: false, 
        message: @vote.errors.full_messages.join(", ")
      }, status: :unprocessable_entity
    end
  end
end