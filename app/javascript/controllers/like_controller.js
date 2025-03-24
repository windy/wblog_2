import { Controller } from "@hotwired/stimulus"
import Cookies from 'js-cookie'

export default class extends Controller {
  static targets = [ 'likeButton', 'unlikeButton' ]

  connect() {
    // Initialize button states based on cookies
    if (Cookies.get('like')) {
      this.likeButtonTarget.classList.add('liked')
    }
    
    if (Cookies.get('unlike')) {
      this.unlikeButtonTarget.classList.add('unliked')
    }
  }

  toggleLike(e) {
    const button = $(this.likeButtonTarget)
    
    if (button.hasClass('liked')) {
      // User is un-liking
      this.deleteReaction('like', button)
    } else {
      // User is liking
      this.createReaction('like', button)
    }
  }

  toggleUnlike(e) {
    const button = $(this.unlikeButtonTarget)
    
    if (button.hasClass('unliked')) {
      // User is un-unliking
      this.deleteReaction('unlike', button)
    } else {
      // User is unliking
      this.createReaction('unlike', button)
    }
  }

  createReaction(kind, button) {
    const url = button.data('url')
    const oppositeButton = kind === 'like' ? $(this.unlikeButtonTarget) : $(this.likeButtonTarget)
    
    $.ajax({
      url: url,
      type: 'POST',
      data: { kind: kind },
      success: (res) => {
        if (kind === 'like') {
          button.addClass('liked')
          oppositeButton.removeClass('unliked')
          Cookies.set('like', res.id)
        } else {
          button.addClass('unliked')
          oppositeButton.removeClass('liked')
          Cookies.set('unlike', res.id)
        }
        
        this.updateCounts(res)
      }
    })
  }

  deleteReaction(kind, button) {
    const cookieId = Cookies.get(kind)
    const url = button.data('url') + '/' + cookieId
    
    $.ajax({
      url: url,
      type: 'DELETE',
      success: (res) => {
        if (kind === 'like') {
          button.removeClass('liked')
          Cookies.remove('like')
        } else {
          button.removeClass('unliked')
          Cookies.remove('unlike')
        }
        
        this.updateCounts(res)
      }
    })
  }

  updateCounts(res) {
    $(this.likeButtonTarget).children('.count').text(res.likes_count)
    $(this.unlikeButtonTarget).children('.count').text(res.unlikes_count)
  }
}