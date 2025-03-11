import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ['form', 'option', 'status', 'voteButtons']

  connect() {
    // Initialize the controller
    this.selectedOption = null;
  }

  selectOption(event) {
    // Get the selected option from the clicked button
    const button = event.currentTarget;
    const option = button.dataset.option;
    
    // Update the hidden field value
    if (this.hasOptionTarget) {
      this.optionTarget.value = option;
    }
    
    // Update UI to show selected option
    this.clearSelectedButtons();
    button.classList.add('selected');
    
    // Store the selected option
    this.selectedOption = option;
    
    // Submit the form automatically
    if (this.hasFormTarget) {
      this.submitForm();
    }
  }

  submitForm() {
    if (!this.selectedOption) {
      if (this.hasStatusTarget) {
        this.statusTarget.textContent = '请选择一个选项';
        this.statusTarget.classList.add('text-warning');
      }
      return;
    }

    // Disable all buttons to prevent double submission
    this.disableButtons();
    
    if (this.hasStatusTarget) {
      this.statusTarget.textContent = '提交中...';
      this.statusTarget.classList.remove('text-warning', 'text-danger');
      this.statusTarget.classList.add('text-info');
    }

    // Get form data and submit using fetch
    const form = this.formTarget;
    const formData = new FormData(form);
    
    fetch(form.action, {
      method: 'POST',
      body: formData,
      headers: {
        'Accept': 'text/html',
        'X-Requested-With': 'XMLHttpRequest'
      },
      credentials: 'same-origin'
    })
    .then(response => {
      if (response.ok) {
        return response.text();
      } else {
        throw new Error('Network response was not ok');
      }
    })
    .then(html => {
      // Replace the entire vote form with the response
      const voteContainer = this.element.closest('.vote-form');
      if (voteContainer) {
        voteContainer.innerHTML = html;
      }
    })
    .catch(error => {
      console.error('Error during vote submission:', error);
      
      // Show error message and re-enable buttons
      if (this.hasStatusTarget) {
        this.statusTarget.textContent = '提交失败，请稍后重试';
        this.statusTarget.classList.remove('text-info');
        this.statusTarget.classList.add('text-danger');
      }
      
      this.enableButtons();
    });
  }

  submit(event) {
    // Prevent default form submission
    event.preventDefault();
    this.submitForm();
  }
  
  // Helper methods
  clearSelectedButtons() {
    // Remove 'selected' class from all buttons
    const buttons = this.element.querySelectorAll('.vote-btn');
    buttons.forEach(button => {
      button.classList.remove('selected');
    });
  }
  
  disableButtons() {
    const buttons = this.element.querySelectorAll('.vote-btn');
    buttons.forEach(button => {
      button.disabled = true;
      button.classList.add('disabled');
    });
  }
  
  enableButtons() {
    const buttons = this.element.querySelectorAll('.vote-btn');
    buttons.forEach(button => {
      button.disabled = false;
      button.classList.remove('disabled');
    });
  }
}