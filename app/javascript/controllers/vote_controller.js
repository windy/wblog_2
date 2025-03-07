import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["button", "recommendCount", "soSoCount", "swipeAwayCount"]

  connect() {
    // Check if there's a current vote from the data attribute
    const currentVote = this.element.dataset.currentVote
    if (currentVote) {
      this.highlightCurrentVote(currentVote)
    }
  }

  vote(event) {
    event.preventDefault()
    const button = event.currentTarget
    const voteType = button.dataset.voteType
    const postId = this.element.dataset.postId
    const url = this.element.dataset.voteUrl

    // Add loading state
    this.setLoadingState(button, true)

    $.ajax({
      url: url,
      type: 'POST',
      data: {
        vote: {
          vote_type: voteType
        }
      },
      success: (response) => {
        this.handleVoteSuccess(response, button)
      },
      error: (xhr) => {
        this.handleVoteError(xhr, button)
      },
      complete: () => {
        this.setLoadingState(button, false)
      }
    })
  }

  handleVoteSuccess(response, clickedButton) {
    // Update vote counts
    if (this.hasRecommendCountTarget) {
      this.recommendCountTarget.textContent = response.recommends_count
    }
    
    if (this.hasSoSoCountTarget) {
      this.soSoCountTarget.textContent = response.so_sos_count
    }
    
    if (this.hasSwipeAwayCountTarget) {
      this.swipeAwayCountTarget.textContent = response.swipe_aways_count
    }

    // Reset all buttons to default state
    this.buttonTargets.forEach(button => {
      button.classList.remove('active')
    })

    // Highlight the current vote button
    if (response.current_vote) {
      this.highlightCurrentVote(response.current_vote)
    }
    
    // Show a temporary success message if needed
    this.showTemporaryMessage(response.message, 'success')
  }

  handleVoteError(xhr, button) {
    let message = 'Failed to record vote'
    
    try {
      const response = JSON.parse(xhr.responseText)
      if (response.message) {
        message = response.message
      }
    } catch (e) {
      console.error('Error parsing vote response:', e)
    }
    
    this.showTemporaryMessage(message, 'error')
  }

  highlightCurrentVote(voteType) {
    // Find button with matching vote-type and highlight it
    const matchingButton = this.buttonTargets.find(button => 
      button.dataset.voteType === voteType
    )
    
    if (matchingButton) {
      matchingButton.classList.add('active')
    }
  }

  setLoadingState(button, isLoading) {
    if (isLoading) {
      button.classList.add('loading')
      button.setAttribute('disabled', 'disabled')
    } else {
      button.classList.remove('loading')
      button.removeAttribute('disabled')
    }
  }

  showTemporaryMessage(message, type = 'info') {
    // Find or create a message container
    let messageContainer = this.element.querySelector('.vote-message')
    
    if (!messageContainer) {
      messageContainer = document.createElement('div')
      messageContainer.className = 'vote-message'
      this.element.appendChild(messageContainer)
    }
    
    // Set message and type
    messageContainer.textContent = message
    messageContainer.className = `vote-message ${type}`
    messageContainer.style.display = 'block'
    
    // Hide after 3 seconds
    setTimeout(() => {
      messageContainer.style.display = 'none'
    }, 3000)
  }
}