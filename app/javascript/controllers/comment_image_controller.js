import { Controller } from "@hotwired/stimulus"
import $ from "jquery"

export default class extends Controller {
  static targets = ["fileInput", "uploadButton", "progressBar", "preview", "previewImage"]

  connect() {
    this.bindEvents()
  }

  bindEvents() {
    $(this.uploadButtonTarget).on('click', this.triggerFileInput.bind(this))
    $(this.fileInputTarget).on('change', this.handleFileSelection.bind(this))
  }

  triggerFileInput(event) {
    event.preventDefault()
    this.fileInputTarget.click()
  }

  handleFileSelection(event) {
    const file = event.target.files[0]
    if (!file) return

    // Validate file type
    if (!file.type.match('image.*')) {
      alert('请选择图片文件')
      return
    }

    // Display preview
    this.displayImagePreview(file)
    
    // Setup progress bar
    $(this.progressBarTarget).removeClass('d-none')
    $(this.progressBarTarget).find('.progress-bar').css('width', '0%')
    
    // Create file reader for preview
    const reader = new FileReader()
    reader.onload = (e) => {
      $(this.previewImageTarget).attr('src', e.target.result)
      $(this.previewTarget).removeClass('d-none')
    }
    reader.readAsDataURL(file)
  }

  displayImagePreview(file) {
    const reader = new FileReader()
    
    reader.onloadstart = () => {
      $(this.progressBarTarget).removeClass('d-none')
    }
    
    reader.onprogress = (event) => {
      if (event.lengthComputable) {
        const percentLoaded = Math.round((event.loaded / event.total) * 100)
        $(this.progressBarTarget).find('.progress-bar').css('width', percentLoaded + '%')
        $(this.progressBarTarget).find('.progress-bar').attr('aria-valuenow', percentLoaded)
      }
    }
    
    reader.onload = (event) => {
      $(this.progressBarTarget).find('.progress-bar').css('width', '100%')
      $(this.progressBarTarget).find('.progress-bar').attr('aria-valuenow', 100)
      $(this.previewImageTarget).attr('src', event.target.result)
      $(this.previewTarget).removeClass('d-none')
    }
    
    reader.onerror = () => {
      alert('图片预览失败，请重试')
      $(this.progressBarTarget).addClass('d-none')
    }
    
    reader.readAsDataURL(file)
  }
}