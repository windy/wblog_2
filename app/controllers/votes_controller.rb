class VotesController < ApplicationController
  layout false

  def create
    post = Post.find(params[:blog_id] || params[:post_id])
    ip_address = request.remote_ip
    session_id = request.session.id.to_s

    # Check if user has already voted using both identifiers
    existing_vote = post.votes.find_by_identifiers(ip_address, session_id)
    
    if existing_vote
      # Update existing vote
      if existing_vote.vote_type != vote_params[:vote_type]
        existing_vote.vote_type = vote_params[:vote_type]
        if existing_vote.save
          render_success(post, "Vote updated successfully")
        else
          render_error(post, "Failed to update vote")
        end
      else
        render_success(post, "Already voted")
      end
    else
      # Create new vote
      vote = post.votes.build(vote_params)
      vote.ip_address = ip_address
      vote.session_id = session_id
      
      if vote.save
        render_success(post, "Vote recorded successfully")
      else
        render_error(post, "Failed to save vote")
      end
    end
  rescue ActiveRecord::RecordNotFound
    render json: { success: false, message: "Post not found" }, status: :not_found
  rescue => e
    render json: { success: false, message: "An error occurred: #{e.message}" }, status: :internal_server_error
  end

  private

  def vote_params
    params.require(:vote).permit(:vote_type)
  end
  
  def render_success(post, message)
    render json: { 
      success: true, 
      message: message,
      recommends_count: post.recommends_count,
      so_sos_count: post.so_sos_count,
      swipe_aways_count: post.swipe_aways_count,
      current_vote: post.vote_type_for(request.remote_ip, request.session.id.to_s)
    }
  end
  
  def render_error(post, message)
    render json: { 
      success: false, 
      message: message,
      recommends_count: post.recommends_count,
      so_sos_count: post.so_sos_count,
      swipe_aways_count: post.swipe_aways_count,
      current_vote: post.vote_type_for(request.remote_ip, request.session.id.to_s)
    }, status: :unprocessable_entity
  end
end