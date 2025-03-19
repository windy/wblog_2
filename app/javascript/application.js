// Entry point for the build script in your package.json
//
import './base'
import './about'

// Auto submit form when filtering options change in archives page
document.addEventListener('DOMContentLoaded', () => {
  // Find elements in archives search form
  const timeRangeSelectors = document.querySelectorAll('.archives-time-range-selector');
  const labelSelector = document.getElementById('archives-label-selector');
  
  // Add event listeners to time range buttons
  if (timeRangeSelectors) {
    timeRangeSelectors.forEach(selector => {
      selector.addEventListener('click', (event) => {
        // Set the value in the hidden input
        const timeRangeInput = document.getElementById('time_range_input');
        if (timeRangeInput) {
          timeRangeInput.value = event.target.dataset.value;
          // Submit the form
          document.getElementById('archives-filter-form').submit();
        }
      });
    });
  }
  
  // Add event listener to label selector dropdown
  if (labelSelector) {
    labelSelector.addEventListener('change', () => {
      document.getElementById('archives-filter-form').submit();
    });
  }
});