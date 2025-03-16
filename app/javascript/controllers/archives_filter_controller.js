import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["labelSelect", "timeRange", "resetLink"]
  static values = {
    storageKey: { type: String, default: "archivesFilterState" }
  }

  connect() {
    this.loadFilterState()
    
    // Add event listeners for filter changes
    if (this.hasLabelSelectTarget) {
      this.labelSelectTarget.addEventListener('change', this.updateFilterState.bind(this))
    }
    
    // Add event listener for time range changes
    if (this.hasTimeRangeTarget) {
      this.timeRangeTarget.addEventListener('change', this.updateFilterState.bind(this))
    }
    
    // Handle reset link functionality
    if (this.hasResetLinkTarget) {
      this.resetLinkTarget.addEventListener('click', this.resetFilters.bind(this))
    }
  }
  
  // Save filter state to session storage
  updateFilterState() {
    const state = {
      timeRange: this.hasTimeRangeTarget ? this.timeRangeTarget.value : '',
      labelId: this.hasLabelSelectTarget ? this.labelSelectTarget.value : ''
    }
    
    sessionStorage.setItem(this.storageKeyValue, JSON.stringify(state))
  }
  
  // Load filter state from session storage
  loadFilterState() {
    try {
      const savedState = sessionStorage.getItem(this.storageKeyValue)
      if (!savedState) return
      
      const state = JSON.parse(savedState)
      
      // Apply saved time range selection
      if (state.timeRange && this.hasTimeRangeTarget) {
        this.timeRangeTarget.value = state.timeRange
      }
      
      // Apply saved label selection
      if (state.labelId && this.hasLabelSelectTarget) {
        this.labelSelectTarget.value = state.labelId
      }
    } catch (error) {
      console.error("Error loading filter state:", error)
      // Clear potentially corrupted state
      sessionStorage.removeItem(this.storageKeyValue)
    }
  }
  
  // Handle form submission to ensure empty inputs don't generate empty parameters
  submitForm(event) {
    // Remove empty parameters before submission
    const form = event.target
    const inputs = form.querySelectorAll('input, select')
    
    inputs.forEach(input => {
      if (input.value === '' || input.value === null) {
        // Disable empty inputs so they don't appear in URL
        input.disabled = true
      }
    })
  }
  
  // Reset all filters and clear storage
  resetFilters(event) {
    // Don't prevent default navigation to reset URL
    
    // Clear session storage
    sessionStorage.removeItem(this.storageKeyValue)
  }
}