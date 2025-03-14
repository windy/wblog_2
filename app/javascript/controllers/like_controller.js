import { Controller } from "@hotwired/stimulus"
import Cookies from 'js-cookie'

export default class extends Controller {
  static targets = [ 'button', 'score', 'stars', 'averageScore' ]
  static values = { currentScore: Number }
  
  connect() {
    this.initializeScore()
    this.renderStars()
  }
  
  initializeScore() {
    const likeId = Cookies.get('like')
    if (likeId) {
      const button = $(this.buttonTarget)
      $.ajax({
        url: button.data('url') + '?id=' + likeId,
        type: 'GET',
        success: (res) => {
          if (res.success) {
            this.currentScoreValue = res.like_score
            button.addClass('liked')
            this.updateScoreDisplay(res.like_score)
            this.updateAverageScore(res.average_score)
          }
        }
      })
    }
  }
  
  renderStars() {
    const starsContainer = this.starsTarget
    starsContainer.innerHTML = ''
    
    for (let i = 0; i <= 10; i++) {
      const star = document.createElement('span')
      star.classList.add('rating-star')
      star.dataset.value = i
      star.textContent = '★'
      star.addEventListener('click', (e) => this.selectScore(i))
      star.addEventListener('mouseover', (e) => this.highlightStars(i))
      star.addEventListener('mouseout', (e) => this.resetStarHighlight())
      starsContainer.appendChild(star)
    }
    
    // Add reset option
    const reset = document.createElement('span')
    reset.classList.add('rating-reset')
    reset.textContent = '×'
    reset.addEventListener('click', (e) => this.resetScore())
    starsContainer.appendChild(reset)
    
    this.highlightCurrentScore()
  }
  
  selectScore(score) {
    this.currentScoreValue = score
    this.submitScore(score)
    this.highlightCurrentScore()
  }
  
  resetScore() {
    if (Cookies.get('like')) {
      this.removeRating()
    } else {
      this.currentScoreValue = 0
      this.highlightCurrentScore()
    }
  }
  
  highlightStars(score) {
    const stars = this.starsTarget.querySelectorAll('.rating-star')
    stars.forEach((star, index) => {
      if (index <= score) {
        star.classList.add('hover')
      } else {
        star.classList.remove('hover')
      }
    })
  }
  
  resetStarHighlight() {
    this.highlightCurrentScore()
  }
  
  highlightCurrentScore() {
    const stars = this.starsTarget.querySelectorAll('.rating-star')
    stars.forEach((star, index) => {
      star.classList.remove('hover')
      if (index <= this.currentScoreValue) {
        star.classList.add('active')
      } else {
        star.classList.remove('active')
      }
    })
  }
  
  updateScoreDisplay(score) {
    if (this.hasScoreTarget) {
      this.scoreTarget.textContent = score
    }
  }
  
  updateAverageScore(avgScore) {
    if (this.hasAverageScoreTarget) {
      this.averageScoreTarget.textContent = avgScore
    }
  }
  
  submitScore(score) {
    const button = $(this.buttonTarget)
    const likeId = Cookies.get('like')
    
    if (likeId) {
      // Update existing rating
      $.ajax({
        url: button.data('url'),
        type: 'POST',
        data: { id: likeId, score: score },
        success: (res) => {
          if (res.success) {
            button.addClass('liked')
            button.children('.count').text(res.count)
            this.updateScoreDisplay(res.like_score)
            this.updateAverageScore(res.average_score)
          }
        }
      })
    } else {
      // Create new rating
      $.ajax({
        url: button.data('url'),
        type: 'POST',
        data: { score: score },
        success: (res) => {
          if (res.success) {
            button.addClass('liked')
            button.children('.count').text(res.count)
            Cookies.set('like', res.id)
            this.updateScoreDisplay(res.like_score)
            this.updateAverageScore(res.average_score)
          }
        }
      })
    }
  }
  
  removeRating() {
    const button = $(this.buttonTarget)
    const likeId = Cookies.get('like')
    
    if (likeId) {
      $.ajax({
        url: button.data('url') + '/' + likeId,
        type: 'DELETE',
        success: (res) => {
          if (res.success) {
            button.removeClass('liked')
            button.children('.count').text(res.count)
            this.currentScoreValue = 0
            this.highlightCurrentScore()
            this.updateScoreDisplay(0)
            this.updateAverageScore(res.average_score)
            Cookies.remove('like')
          }
        }
      })
    }
  }
  
  toggle(e) {
    // Keep for backward compatibility
    if (!this.hasStarsTarget) {
      let button = $(this.buttonTarget)
      if (button.hasClass('liked')) {
        this.removeRating()
      } else {
        this.submitScore(1) // Default score of 1 for legacy toggle
      }
    }
  }
}