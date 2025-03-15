import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["excellent", "normal", "poor", "result", "buttons"]
  
  connect() {
    this.postId = this.element.dataset.postId
    this.userVoted = this.element.dataset.userVoted === "true"
    this.voteType = this.element.dataset.voteType || null
    
    if (this.userVoted) {
      this.disableAllButtons()
      this.highlightUserVote()
    }
  }
  
  castVote(event) {
    event.preventDefault()
    
    if (this.userVoted) {
      return
    }
    
    const voteType = event.currentTarget.dataset.voteType
    
    fetch(`/blogs/${this.postId}/votes`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
      },
      body: JSON.stringify({ vote_type: voteType })
    })
    .then(response => {
      if (!response.ok) {
        throw new Error('Voting failed')
      }
      return response.json()
    })
    .then(data => {
      if (data.success) {
        this.updateVoteCounts(data)
        this.userVoted = true
        this.voteType = voteType
        this.disableAllButtons()
        this.highlightUserVote()
      } else {
        console.error(data.message)
      }
    })
    .catch(error => {
      console.error('Error:', error)
    })
  }
  
  updateVoteCounts(data) {
    // Update excellent votes
    if (this.hasExcellentTarget) {
      const excellentCount = this.excellentTarget.querySelector('.vote-count')
      const excellentPercentage = this.excellentTarget.querySelector('.vote-percentage')
      excellentCount.textContent = data.excellent.count
      excellentPercentage.textContent = `${data.excellent.percentage}%`
    }
    
    // Update normal votes
    if (this.hasNormalTarget) {
      const normalCount = this.normalTarget.querySelector('.vote-count')
      const normalPercentage = this.normalTarget.querySelector('.vote-percentage')
      normalCount.textContent = data.normal.count
      normalPercentage.textContent = `${data.normal.percentage}%`
    }
    
    // Update poor votes
    if (this.hasPoorTarget) {
      const poorCount = this.poorTarget.querySelector('.vote-count')
      const poorPercentage = this.poorTarget.querySelector('.vote-percentage')
      poorCount.textContent = data.poor.count
      poorPercentage.textContent = `${data.poor.percentage}%`
    }
    
    // Update total votes
    if (this.hasResultTarget) {
      this.resultTarget.textContent = `Total votes: ${data.total}`
    }
  }
  
  disableAllButtons() {
    if (this.hasButtonsTarget) {
      const buttons = this.buttonsTarget.querySelectorAll('button')
      buttons.forEach(button => {
        button.disabled = true
        button.classList.add('voted')
      })
    }
  }
  
  highlightUserVote() {
    if (!this.voteType) return
    
    const voteTarget = this[`${this.voteType}Target`]
    if (voteTarget) {
      voteTarget.classList.add('user-voted')
    }
  }
}