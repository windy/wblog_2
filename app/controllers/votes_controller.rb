class VotesController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create
  
  def create
    @poll_option = PollOption.find_by(id: params[:poll_option_id])
    
    if @poll_option.nil?
      render json: { error: "Poll option not found" }, status: :not_found
      return
    end
    
    # Get the poll associated with this option
    @poll = @poll_option.poll
    
    # Check if the user has already voted on this poll
    existing_vote = Vote.joins(:poll_option)
                      .where(session_id: session.id.to_s, poll_options: { poll_id: @poll.id })
                      .first
                      
    if existing_vote
      render json: { 
        error: "You have already voted in this poll",
        voted_option_id: existing_vote.poll_option_id
      }, status: :unprocessable_entity
      return
    end
    
    @vote = @poll_option.votes.new(session_id: session.id.to_s, poll_id: @poll.id)
    
    if @vote.save
      # Get all options for this poll to return the complete results
      @poll_options = @poll.poll_options.includes(:votes)
      
      # Calculate total votes for percentage calculation
      total_votes = @poll_options.sum(:votes_count)
      
      # Prepare results data
      results = @poll_options.map do |option|
        percentage = total_votes > 0 ? (option.votes_count.to_f / total_votes * 100).round(1) : 0
        {
          id: option.id,
          content: option.content,
          votes_count: option.votes_count,
          percentage: percentage,
          is_voted: option.id == @poll_option.id
        }
      end
      
      render json: { 
        success: true, 
        message: "Vote recorded successfully", 
        results: results,
        total_votes: total_votes,
        voted_option_id: @poll_option.id
      }
    else
      # Return error if validation fails
      render json: { 
        error: @vote.errors.full_messages.first || "Failed to record vote",
        voted_option_id: nil
      }, status: :unprocessable_entity
    end
  end
end