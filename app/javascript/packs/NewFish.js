document.addEventListener('DOMContentLoaded', function() {
  const existingGenreBtn = document.getElementById('existingGenreBtn');
  const newGenreBtn = document.getElementById('newGenreBtn');
  const existingGenreSelect = document.getElementById('existingGenreSelect');
  const newGenreInput = document.getElementById('newGenreInput');

  existingGenreBtn.addEventListener('click', function() {
    existingGenreSelect.style.display = 'block';
    newGenreInput.style.display = 'none';
  });

  newGenreBtn.addEventListener('click', function() {
    newGenreInput.style.display = 'block';
    existingGenreSelect.style.display = 'none';
  });
});
