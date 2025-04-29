import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static values = {
    url: String,
    title: String,
    pic: { type: String, default: "" }
  }

  share(e) {
    e.preventDefault()
    
    const shareUrl = "http://service.weibo.com/share/share.php"
    const params = new URLSearchParams()
    
    params.append("url", encodeURIComponent(this.urlValue))
    params.append("title", encodeURIComponent(this.titleValue))
    
    if (this.picValue) {
      params.append("pic", encodeURIComponent(this.picValue))
    }
    
    const fullUrl = `${shareUrl}?${params.toString()}`
    window.open(fullUrl, "_blank", "width=615,height=505")
  }
}