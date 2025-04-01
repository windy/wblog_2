import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    title: String,
    url: String
  }

  connect() {
    // Initialize controller
  }

  shareFacebook(e) {
    e.preventDefault()
    const url = this.urlValue || window.location.href
    const shareUrl = `https://www.facebook.com/sharer/sharer.php?u=${encodeURIComponent(url)}`
    this.openShareWindow(shareUrl)
  }

  shareTwitter(e) {
    e.preventDefault()
    const url = this.urlValue || window.location.href
    const title = this.titleValue || document.title
    const shareUrl = `https://twitter.com/intent/tweet?text=${encodeURIComponent(title)}&url=${encodeURIComponent(url)}`
    this.openShareWindow(shareUrl)
  }

  openShareWindow(url) {
    window.open(url, '_blank', 'width=600,height=400,resizable=yes,scrollbars=yes')
  }
}