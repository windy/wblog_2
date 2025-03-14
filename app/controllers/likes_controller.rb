class LikesController < ApplicationController
  layout false

  def index
    post = Post.find(params[:blog_id])
    like = post.likes.find_by(id: params[:id]) if params[:id].present?
    render json: { 
      success: true, 
      count: post.liked_count, 
      average_score: post.average_score,
      like_score: like&.score || 0
    }
  end

  def create
    post = Post.find(params[:blog_id])
    
    # Check if user already liked this post
    existing_like = post.likes.find_by(id: params[:id]) if params[:id].present?
    
    if existing_like
      # Update existing like with new score
      existing_like.score = params[:score] || 0
      
      if existing_like.save
        render json: { 
          success: true, 
          id: existing_like.id.to_s, 
          count: post.liked_count,
          average_score: post.average_score,
          like_score: existing_like.score
        }
      else
        render json: { 
          success: false, 
          count: post.liked_count,
          average_score: post.average_score
        }
      end
    else
      # Create new like with score
      like = post.likes.build(score: params[:score] || 0)
      
      if like.save
        render json: { 
          success: true, 
          id: like.id.to_s, 
          count: post.liked_count,
          average_score: post.average_score,
          like_score: like.score
        }
      else
        render json: { 
          success: false, 
          count: post.liked_count,
          average_score: post.average_score
        }
      end
    end
  end

  def destroy
    post = Post.find(params[:blog_id])
    like = post.likes.find(params[:id])
    
    if like.destroy
      render json: { 
        success: true, 
        count: post.reload.liked_count,
        average_score: post.average_score
      }
    else
      render json: { 
        success: false, 
        count: post.reload.liked_count,
        average_score: post.average_score
      }
    end
  end
end