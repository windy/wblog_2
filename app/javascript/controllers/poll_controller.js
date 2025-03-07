import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["voteForm", "results", "errorMessage", "submitButton", "totalVotes"]

  connect() {
    console.log("Poll controller connected")
    this.selectedOption = null
    this.hasVoted = false
  }

  selectOption(event) {
    this.selectedOption = event.target.value
    this.submitButtonTarget.disabled = false
  }

  async submitVote(event) {
    event.preventDefault()

    if (!this.selectedOption) {
      this.showError("Please select an option")
      return
    }

    try {
      const response = await fetch('/votes', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'X-Requested-With': 'XMLHttpRequest'
        },
        body: JSON.stringify({
          poll_option_id: this.selectedOption
        }),
        credentials: 'same-origin'
      })

      const data = await response.json()

      if (response.ok) {
        this.processSuccessfulVote(data)
      } else {
        this.showError(data.error || "Error recording your vote")
      }
    } catch (error) {
      console.error("Vote submission error:", error)
      this.showError("Network error. Please try again.")
    }
  }

  processSuccessfulVote(data) {
    // Hide the voting form
    this.voteFormTarget.classList.add('d-none')
    
    // Update the results and show them
    this.updateResults(data.results)
    this.resultsTarget.classList.remove('d-none')
    
    // Update total votes count
    this.totalVotesTarget.textContent = `已有 ${data.total_votes} 人参与投票`
    
    // Mark as voted
    this.hasVoted = true
  }

  updateResults(results) {
    if (!this.resultsTarget) return

    // Find the poll results list element
    const resultsList = this.resultsTarget.querySelector('.poll-results-list')
    if (!resultsList) return

    // Find the highest vote count
    const maxVotes = Math.max(...results.map(option => option.votes_count))
    
    // Clear existing results
    resultsList.innerHTML = ''
    
    // Add each option result
    results.forEach(option => {
      const isHighest = option.votes_count === maxVotes && maxVotes > 0
      
      const optionElement = document.createElement('div')
      optionElement.className = `poll-option mb-3 ${isHighest ? 'highest-vote' : ''}`
      optionElement.dataset.optionId = option.id
      
      optionElement.innerHTML = `
        <div class="d-flex justify-content-between mb-1">
          <span class="option-content">
            ${option.content}
            ${isHighest ? '<span class="badge badge-success ml-2">领先</span>' : ''}
          </span>
          <span class="option-stats">
            <span class="vote-count">${option.votes_count}</span>
            票 (<span class="vote-percentage">${option.percentage}</span>%)
          </span>
        </div>
        <div class="progress">
          <div class="progress-bar" role="progressbar" 
               style="width: ${option.percentage}%" 
               aria-valuenow="${option.percentage}" 
               aria-valuemin="0" 
               aria-valuemax="100"></div>
        </div>
      `
      
      resultsList.appendChild(optionElement)
    })
    
    // Add footer text
    const footerElement = document.createElement('div')
    footerElement.className = 'text-muted mt-3'
    footerElement.innerHTML = '<small>投票结果实时更新</small>'
    resultsList.appendChild(footerElement)
  }

  showError(message) {
    const errorElement = this.errorMessageTarget
    errorElement.textContent = message
    errorElement.classList.remove('d-none')
    
    // Hide error after 3 seconds
    setTimeout(() => {
      errorElement.classList.add('d-none')
    }, 3000)
  }
}