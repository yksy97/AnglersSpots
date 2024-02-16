document.addEventListener('DOMContentLoaded', function() {
  const newGenreBtn = document.getElementById('newGenreBtn');
  const existingGenreBtn = document.getElementById('existingGenreBtn');
  const newGenreInput = document.getElementById('newGenreInput');
  const existingGenreSelect = document.getElementById('existingGenreSelect');
  const form = document.getElementById('NewPostForm');
  const submitBtn = document.getElementById('submitBtn');

  // 新規ボタンクリック時の動作
  newGenreBtn.addEventListener('click', function() {
    newGenreInput.style.display = 'block';
    existingGenreSelect.style.display = 'none';
  });

  // 既存ボタンクリック時の動作
  existingGenreBtn.addEventListener('click', function() {
    newGenreInput.style.display = 'none';
    existingGenreSelect.style.display = 'block';
  });

  // フォーム送信時の動作
  form.addEventListener('submit', function(event) {
    const newGenreValue = newGenreInput.querySelector('input').value.trim();
    const existingGenreValue = existingGenreSelect.querySelector('select').value;

    // 新規と既存が両方とも空の場合、またはフォームが正しく入力されていない場合
    if ((!newGenreValue && !existingGenreValue) || !form.checkValidity()) {
      event.preventDefault(); // フォームの送信を阻止
      alert('既存の魚を選択するか、新規の魚を入力してください');
      form.classList.add('was-validated'); // Bootstrapのバリデーションスタイルを適用
    }
  });
});
