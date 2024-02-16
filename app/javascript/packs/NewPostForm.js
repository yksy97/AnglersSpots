document.addEventListener('DOMContentLoaded', function() {
  const form = document.querySelector('.NewPostForm');
  
  form.addEventListener('submit', function(event) {
    if (!form.checkValidity()) {
      event.preventDefault();
      event.stopPropagation();
    }
    form.classList.add('was-validated');
  }, false);
});
