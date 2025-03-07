// Entry point for the build script in your package.json
//
import './base'
import './about'

// Import file upload library
import './libs/jquery.html5-fileupload'

// Add image preview functionality for comment photo uploads
document.addEventListener('DOMContentLoaded', function() {
  // Find the comment image upload field
  const fileInput = document.querySelector('.comment-image-upload');
  
  if (fileInput) {
    fileInput.addEventListener('change', function() {
      // Remove any existing preview
      const existingPreview = document.querySelector('.comment-image-preview');
      if (existingPreview) {
        existingPreview.remove();
      }
      
      // Check if a file was selected
      if (this.files && this.files[0]) {
        const file = this.files[0];
        
        // Only process image files
        if (!file.type.match('image.*')) {
          return;
        }
        
        // Create a preview container
        const previewContainer = document.createElement('div');
        previewContainer.className = 'comment-image-preview';
        previewContainer.style.marginTop = '10px';
        
        // Create FileReader to read the image
        const reader = new FileReader();
        
        // Set up the reader onload callback
        reader.onload = function(e) {
          // Create image element
          const img = document.createElement('img');
          img.src = e.target.result;
          img.className = 'comment-preview-image';
          img.style.maxWidth = '300px';
          img.style.maxHeight = '200px';
          img.style.border = '1px solid #ddd';
          img.style.borderRadius = '4px';
          img.style.padding = '3px';
          
          // Add image to preview container
          previewContainer.appendChild(img);
          
          // Create remove button
          const removeBtn = document.createElement('button');
          removeBtn.type = 'button';
          removeBtn.className = 'btn btn-sm btn-danger';
          removeBtn.textContent = 'Remove Image';
          removeBtn.style.marginTop = '5px';
          removeBtn.style.display = 'block';
          
          // Add click handler to remove button
          removeBtn.addEventListener('click', function() {
            // Clear the file input
            fileInput.value = '';
            // Remove the preview
            previewContainer.remove();
          });
          
          // Add remove button to preview container
          previewContainer.appendChild(removeBtn);
        };
        
        // Read the image file as a data URL
        reader.readAsDataURL(file);
        
        // Insert the preview after the file input
        fileInput.parentNode.insertBefore(previewContainer, fileInput.nextSibling);
      }
    });
  }
});