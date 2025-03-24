class LikesController < ApplicationController
  layout false

  def index
    post = Post.find(params[:blog_id])
    render json: { 
      success: true, 
      likes_count: post.liked_count,
      unlikes_count: post.unliked_count
    }
  end

  def create
    post = Post.find(params[:blog_id])
    kind = params[:kind].presence || 'like'
    
    # Check if user already has an opposite reaction and remove it
    if kind == 'like' && cookies[:unlike].present?
      existing_unlike = post.likes.unlikes.find_by(id: cookies[:unlike])
      existing_unlike&.destroy
      cookies.delete(:unlike)
    elsif kind == 'unlike' && cookies[:like].present?
      existing_like = post.likes.likes.find_by(id: cookies[:like])
      existing_like&.destroy
      cookies.delete(:like)
    end
    
    # Create the new reaction
    like = post.likes.build(kind: kind)

    if like.save
      render json: { 
        success: true, 
        id: like.id.to_s, 
        likes_count: post.liked_count, 
        unlikes_count: post.unliked_count,
        kind: kind 
      }
    else
      render json: { 
        success: false, 
        likes_count: post.liked_count, 
        unlikes_count: post.unliked_count 
      }
    end
  end

  def destroy
    post = Post.find(params[:blog_id])
    like = post.likes.find(params[:id])
    
    if like.destroy
      render json: { 
        success: true, 
        likes_count: post.reload.liked_count, 
        unlikes_count: post.reload.unliked_count,
        kind: like.kind
      }
    else
      render json: { 
        success: false, 
        likes_count: post.reload.liked_count, 
        unlikes_count: post.reload.unliked_count 
      }
    end
  end
end