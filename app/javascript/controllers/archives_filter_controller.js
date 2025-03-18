import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  connect() {
    // Set initial state based on URL parameters
    this.initializeFilters()
  }

  initializeFilters() {
    // Highlight active time filter if present
    const timeFilter = new URLSearchParams(window.location.search).get('time_filter')
    if (timeFilter) {
      const activeTimeButton = document.getElementById(`time_${timeFilter}`)
      if (activeTimeButton) {
        activeTimeButton.checked = true
        const label = document.querySelector(`label[for="time_${timeFilter}"]`)
        if (label) {
          label.classList.add('active')
        }
      }
    }

    // Highlight selected labels if present
    const params = new URLSearchParams(window.location.search)
    const labelIds = params.getAll('label_ids[]')
    
    if (labelIds && labelIds.length > 0) {
      labelIds.forEach(id => {
        const checkbox = document.querySelector(`input[name="label_ids[]"][value="${id}"]`)
        if (checkbox) {
          checkbox.checked = true
          const label = document.querySelector(`label[for="label_ids_${id}"]`)
          if (label) {
            label.classList.add('selected-label')
          }
        }
      })
    }
  }

  submitForm(event) {
    // Auto-submit form when filter changes
    const form = event.target.closest('form')
    form.submit()
  }

  clearFilters(event) {
    event.preventDefault()
    
    // Get the current search query if any
    const searchQuery = new URLSearchParams(window.location.search).get('q') || ''
    
    // Redirect to archives with only search query if present
    if (searchQuery) {
      window.location.href = `${window.location.pathname}?q=${encodeURIComponent(searchQuery)}`
    } else {
      window.location.href = window.location.pathname
    }
  }
}