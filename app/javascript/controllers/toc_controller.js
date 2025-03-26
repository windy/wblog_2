import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["content", "list"]

  connect() {
    debugger
    if (this.hasContentTarget && this.hasListTarget) {
      this.buildTOC();
      this.initScrollSpy();
    }
  }

  buildTOC() {
    const contentElement = this.contentTarget;
    const headings = contentElement.querySelectorAll('h1, h2, h3');
    
    if (headings.length === 0) {
      this.element.style.display = 'none';
      return;
    }

    const listElement = this.listTarget;
    listElement.innerHTML = '';

    headings.forEach((heading, index) => {
      // Create unique ID for heading if it doesn't exist
      if (!heading.id) {
        heading.id = this.generateUniqueId(heading.textContent, index);
      }
      
      // Create list item
      const listItem = document.createElement('li');
      listItem.className = `toc-${heading.tagName.toLowerCase()}`;
      
      // Create link
      const link = document.createElement('a');
      link.href = `#${heading.id}`;
      link.textContent = heading.textContent;
      link.dataset.action = "click->toc#scrollToSection";
      
      // Add progress bar if needed
      const progressBar = document.createElement('div');
      progressBar.className = 'toc-progress';
      link.appendChild(progressBar);
      
      listItem.appendChild(link);
      listElement.appendChild(listItem);
    });
  }

  scrollToSection(event) {
    event.preventDefault();
    const targetId = event.currentTarget.getAttribute('href');
    const targetElement = document.querySelector(targetId);
    
    if (targetElement) {
      const offset = 20; // Offset to account for fixed headers
      const targetPosition = targetElement.getBoundingClientRect().top + window.pageYOffset - offset;
      
      window.scrollTo({
        top: targetPosition,
        behavior: 'smooth'
      });
      
      // Update URL without page reload
      if (history.pushState) {
        history.pushState(null, null, targetId);
      }
    }
  }

  initScrollSpy() {
    // Initialize ddscrollspy
    $(this.listTarget).ddscrollSpy({
      scrolltopoffset: -50,
      scrollbehavior: 'smooth',
      scrollduration: 500,
      highlightclass: 'active',
      enableprogress: 'toc-progress'
    });

    // Update spy when page is loaded fully
    window.addEventListener('load', () => {
      $(this.listTarget).trigger('updatespy');
    });

    // Handle window resize events
    let resizeTimer;
    window.addEventListener('resize', () => {
      clearTimeout(resizeTimer);
      resizeTimer = setTimeout(() => {
        $(this.listTarget).trigger('updatespy');
      }, 250);
    });
  }

  generateUniqueId(text, index) {
    // Create a slug from the heading text
    const slug = text
      .toLowerCase()
      .replace(/[^\w\s-]/g, '') // Remove special characters
      .replace(/\s+/g, '-') // Replace spaces with -
      .replace(/--+/g, '-') // Replace multiple - with single -
      .trim();
    
    return `heading-${slug}-${index}`;
  }
}