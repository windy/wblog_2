import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    title: String,
    url: String
  }

  connect() {
    // Initialize the controller when it connects to the DOM
  }

  share(event) {
    event.preventDefault()
    
    // Build the Sina Weibo share URL with parameters
    const shareUrl = new URL("https://service.weibo.com/share/share.php")
    
    // Add required parameters
    shareUrl.searchParams.append("url", this.urlValue || window.location.href)
    shareUrl.searchParams.append("title", this.titleValue || document.title)
    
    // Optional parameters
    shareUrl.searchParams.append("type", "button")
    shareUrl.searchParams.append("language", "zh_cn")
    
    // Open a new window with the share URL
    window.open(
      shareUrl.toString(),
      "weibo-share-dialog",
      "width=626,height=436,location=no,toolbar=no,menubar=no"
    )
  }
}