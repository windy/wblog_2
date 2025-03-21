import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["form"]

  connect() {
    // Restore filter state from URL when page loads
    this.restoreFilterState()
  }

  submit(event) {
    // Prevent default only if this is triggered by an input change
    if (event && event.type === "change") {
      event.preventDefault()
      this.formTarget.submit()
    }
  }

  restoreFilterState() {
    // Get current URL search parameters
    const searchParams = new URLSearchParams(window.location.search)
    
    // Restore each filter value from URL parameters
    const filterParams = ['q', 'time_option', 'label_id', 'min_views', 'min_likes']
    
    filterParams.forEach(param => {
      const value = searchParams.get(param)
      
      if (value) {
        // Find the corresponding form element and set its value
        const element = this.formTarget.querySelector(`[name="${param}"]`)
        
        if (element) {
          if (element.type === 'radio') {
            // For radio buttons, we need to find the specific option
            const radio = this.formTarget.querySelector(`[name="${param}"][value="${value}"]`)
            if (radio) radio.checked = true
          } else {
            // For other inputs (text, select)
            element.value = value
          }
        }
      }
    })
  }
}